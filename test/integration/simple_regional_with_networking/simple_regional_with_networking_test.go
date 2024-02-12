// Copyright 2022-2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package simple_regional_with_networking

import (
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestSimpleRegionalWithNetworking(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		//Skipping Default Verify as the Verify Stage fails due to change in Client Cert Token
		// bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		serviceAccount := bpt.GetStringOutput("service_account")
		region := bpt.GetStringOutput("region")
		subnetName := bpt.GetStringOutput("subnet_name")
		ipRangeServicesName := bpt.GetStringOutput("ip_range_services_name")
		ipRangePodName := bpt.GetStringOutput("ip_range_pods_name")

		op := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)
		g := golden.NewOrUpdate(t, op.String(),
			golden.WithSanitizer(golden.StringSanitizer(serviceAccount, "SERVICE_ACCOUNT")),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(clusterName, "CLUSTER_NAME")),
		)
		validateJSONPaths := []string{
			"status",
			"location",
			"privateClusterConfig.enablePrivateEndpoint",
			"privateClusterConfig.enablePrivateNodes",
			"addonsConfig.horizontalPodAutoscaling",
			"addonsConfig.httpLoadBalancing",
			"addonsConfig.kubernetesDashboard.disabled",
			"addonsConfig.networkPolicyConfig.disabled",
			"nodePools.autoscaling.enabled",
			"nodePools.autoscaling.minNodeCount",
			"nodePools.autoscaling.maxNodeCount",
			"nodePools.config.machineType",
			"nodePools.config.diskSizeGb",
			"nodePools.config.machineType",
			"nodePools.config.labels",
			"nodePools.config.tags",
			"nodePools.management.autoRepair",
			"nodePools.management.autoUpgrade",
		}
		for _, pth := range validateJSONPaths {
			g.JSONEq(assert, op, pth)
		}

		op1 := gcloud.Runf(t, "compute networks subnets describe %s --project=%s --region=%s", subnetName, projectId, region)
		assert.Contains(op1.Get("secondaryIpRanges").Array()[0].Get("rangeName").String(), ipRangePodName, "Has the correct secondaryIpRanges configuration")
		assert.Contains(op1.Get("secondaryIpRanges").Array()[0].Get("ipCidrRange").String(), "192.168.0.0/18", "Has the correct secondaryIpRanges configuration")
		assert.Contains(op1.Get("secondaryIpRanges").Array()[1].Get("rangeName").String(), ipRangeServicesName, "Has the correct secondaryIpRanges configuration")
		assert.Contains(op1.Get("secondaryIpRanges").Array()[1].Get("ipCidrRange").String(), "192.168.64.0/18", "Has the correct secondaryIpRanges configuration")

	})

	bpt.Test()
}
