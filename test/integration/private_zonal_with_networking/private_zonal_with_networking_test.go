// Copyright 2022-2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package private_zonal_with_networking

import (
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestPrivateZonalWithNetworking(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		// Commenting Default Verify due to issue 1478 for location Policy
		// bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		subnetName := bpt.GetStringOutput("subnet_name")
		region := bpt.GetStringOutput("region")
		ipRangePodsName := bpt.GetStringOutput("ip_range_pods_name")
		ipRangeServicesName := bpt.GetStringOutput("ip_range_services_name")
		serviceAccount := bpt.GetStringOutput("service_account")
		peeringName := bpt.GetStringOutput("peering_name")

		//Unsetting project as the default sanitizer order replaced project id but retains SA
		gcloud.Runf(t, "config unset project")
		op := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)

		g := golden.NewOrUpdate(t, op.String(),
			golden.WithSanitizer(golden.StringSanitizer(serviceAccount, "SERVICE_ACCOUNT")),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(clusterName, "CLUSTER_NAME")),
		)
		assert.Equal(peeringName, op.Get("privateClusterConfig.peeringName").String(), "has the correct PeeringName")
		validateJSONPaths := []string{
			"status",
			"location",
			"locations",
			"privateClusterConfig.enablePrivateEndpoint",
			"privateClusterConfig.enablePrivateNodes",
			"addonsConfig",
		}
		for _, pth := range validateJSONPaths {
			g.JSONEq(assert, op, pth)
		}

		for _, np := range op.Get("nodePools").Array() {
			npName := np.Get("name").String()
			// sanitize current nodepool data
			np = g.GetSanitizedJSON(np)
			// retrieve matching nodepool data from goldenfile
			gNp := utils.GetFirstMatchResult(t, g.GetJSON().Get("nodePools").Array(), "name", npName)
			switch npName {
			case "default-pool":
				assert.False(np.Get("initialNodeCount").Exists(), "has no initial node count")
				assert.False(np.Get("autoscaling.enabled").Exists(), "does not have autoscaling enabled")
			case "default-node-pool":
				assert.JSONEq(gNp.Get("config").String(), np.Get("config").String())
			}
		}

		sOp := gcloud.Runf(t, "compute networks subnets describe %s --project=%s --region=%s", subnetName, projectId, region)
		assert.Contains(sOp.Get("secondaryIpRanges").Array()[0].Get("rangeName").String(), ipRangePodsName, "Contains Pod Address Name")
		assert.Contains(sOp.Get("secondaryIpRanges").Array()[0].Get("ipCidrRange").String(), "192.168.0.0/18", "Contains Pod Address")
		assert.Contains(sOp.Get("secondaryIpRanges").Array()[1].Get("rangeName").String(), ipRangeServicesName, "Contains SVC Address Name")
		assert.Contains(sOp.Get("secondaryIpRanges").Array()[1].Get("ipCidrRange").String(), "192.168.64.0/18", "Contains SVC Address")

	})

	bpt.Test()
}
