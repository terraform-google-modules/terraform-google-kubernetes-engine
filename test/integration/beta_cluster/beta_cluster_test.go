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

package beta_cluster

import (
	"fmt"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestBetaCluster(t *testing.T) {
	gke := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	gke.DefineVerify(func(assert *assert.Assertions) {
		gke.DefaultVerify(assert)

		projectId := gke.GetStringOutput("project_id")
		location := gke.GetStringOutput("location")
		clusterName := gke.GetStringOutput("cluster_name")
		serviceAccount := gke.GetStringOutput("service_account")
		op := gcloud.Runf(t, "beta container clusters describe %s --zone %s --project %s", clusterName, location, projectId)
		// save output as goldenfile
		g := golden.NewOrUpdate(t, op.String(),
			golden.WithSanitizer(golden.StringSanitizer(serviceAccount, "SERVICE_ACCOUNT")),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(clusterName, "CLUSTER_NAME")),
		)
		// assert json paths against goldenfile data
		validateJSONPaths := []string{
			"status",
			"location",
			"locations",
			"privateClusterConfig.enablePrivateEndpoint",
			"networkConfig.datapathProvider",
			"databaseEncryption.state",
			// "identityServiceConfig.enabled", TODO: b/378974729
			"addonsConfig",
			"networkConfig.datapathProvider",
			"binaryAuthorization",
			"databaseEncryption.state",
			"loggingConfig",
			"monitoringConfig",
		}
		for _, pth := range validateJSONPaths {
			g.JSONEq(assert, op, pth)
		}
		for _, np := range op.Get("nodePools").Array() {
			npName := np.Get("name").String()
			// sanitze current nodepool data
			np = g.GetSanitizedJSON(np)
			// retrive matching nodepool data from goldenfile
			gNp := utils.GetFirstMatchResult(t, g.GetJSON().Get("nodePools").Array(), "name", npName)
			switch npName {
			case "default-pool":
				assert.False(np.Get("initialNodeCount").Exists(), "has no initial node count")
				assert.False(np.Get("autoscaling.enabled").Exists(), "does not have autoscaling enabled")
			case "default-node-pool":
				assert.JSONEq(gNp.Get("config").String(), np.Get("config").String())
				assert.JSONEq(gNp.Get("autoscaling").String(), np.Get("autoscaling").String())
				assert.JSONEq(gNp.Get("management").String(), np.Get("management").String())
			}
		}

		// verify SA
		op = gcloud.Runf(t, "iam service-accounts describe %s --project %s", serviceAccount, projectId)
		assert.Equal(fmt.Sprintf("Terraform-managed service account for cluster %s", clusterName), op.Get("displayName").String(), "has the correct displayname")

	})
	gke.Test()
}
