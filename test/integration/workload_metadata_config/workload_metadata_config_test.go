// Copyright 2024-2025 Google LLC
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
package node_pool

import (
	"fmt"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/cai"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestWorkloadMetadataConfig(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		// Skipping Default Verify as the Verify Stage fails due to change in Client Cert Token
		// bpt.DefaultVerify(assert)
		testutils.TGKEVerify(t, bpt, assert) // Verify Resources

		projectId := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		randomString := bpt.GetStringOutput("random_string")
		kubernetesEndpoint := bpt.GetStringOutput("kubernetes_endpoint")
		nodeServiceAccount := bpt.GetStringOutput("service_account")

		// Retrieve Project CAI
		projectCAI := cai.GetProjectResources(t, projectId, cai.WithAssetTypes([]string{"container.googleapis.com/Cluster"}))

		// Retrieve Cluster from CAI
		// Equivalent gcloud describe command (classic)
		// cluster := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)
		clusterResourceName := fmt.Sprintf("//container.googleapis.com/projects/%s/zones/%s/clusters/%s", projectId, location, clusterName)
		cluster := projectCAI.Get("#(name=\"" + clusterResourceName + "\").resource.data")

		// Setup golden image with sanitizers
		g := golden.NewOrUpdate(t, cluster.String(),
			golden.WithSanitizer(golden.StringSanitizer(nodeServiceAccount, "NODE_SERVICE_ACCOUNT")),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(randomString, "RANDOM_STRING")),
			golden.WithSanitizer(golden.StringSanitizer(kubernetesEndpoint, "KUBERNETES_ENDPOINT")),
		)

		// Cluster Assertions
		testutils.TGKEAssertGolden(assert, g, &cluster, []string{"default-pool"}, []string{"monitoringConfig.componentConfig.enableComponents"}) // TODO: enableComponents is UL

		// IAM Assertions
		// CAI IAM data can be stale
		registryProjectIds := bpt.GetJsonOutput("registry_project_ids")
		serviceAccount := bpt.GetStringOutput("service_account")

		for _, registryProjectId := range registryProjectIds.Array() {
			imaPolicy := gcloud.Runf(t, "projects get-iam-policy %s", registryProjectId.String())
			assert.Contains(imaPolicy.Get("bindings.#(role==\"roles/storage.objectViewer\").members").Value().([]interface{}), fmt.Sprintf("serviceAccount:%s", serviceAccount))
			assert.Contains(imaPolicy.Get("bindings.#(role==\"roles/artifactregistry.reader\").members").Value().([]interface{}), fmt.Sprintf("serviceAccount:%s", serviceAccount))
		}
	})
	bpt.Test()
}
