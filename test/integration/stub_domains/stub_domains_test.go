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
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestStubDomains(t *testing.T) {
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
		nodeServiceAccount := bpt.GetStringOutput("compute_engine_service_account")

		// Retrieve Project CAI
		projectCAI := cai.GetProjectResources(t, projectId, cai.WithAssetTypes([]string{"container.googleapis.com/Cluster"}))

		// Retrieve Cluster from CAI
		// Equivalent gcloud describe command (classic)
		// cluster := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)
		clusterResourceName := fmt.Sprintf("//container.googleapis.com/projects/%s/locations/%s/clusters/%s", projectId, location, clusterName)
		cluster := projectCAI.Get("#(name=\"" + clusterResourceName + "\").resource.data")

		// Setup golden image with sanitizers
		g := golden.NewOrUpdate(t, cluster.String(),
			golden.WithSanitizer(golden.StringSanitizer(nodeServiceAccount, "NODE_SERVICE_ACCOUNT")),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(randomString, "RANDOM_STRING")),
			golden.WithSanitizer(golden.StringSanitizer(kubernetesEndpoint, "KUBERNETES_ENDPOINT")),
		)

		// Cluster Assertions
		testutils.TGKEAssertGolden(assert, g, &cluster, []string{}, []string{"monitoringConfig.componentConfig.enableComponents"}) // TODO: enableComponents is UL

		// K8s Assertions
		// CAI does not include k8s.io/ConfigMap
		gcloud.Runf(t, "container clusters get-credentials %s --region %s --project %s", clusterName, location, projectId)
		k8sOpts := k8s.NewKubectlOptions(fmt.Sprintf("gke_%s_%s_%s", projectId, location, clusterName), "", "")

		// kube-dns
		listKubeDnsConfigMap, err := k8s.RunKubectlAndGetOutputE(t, k8sOpts, "get", "configmap", "kube-dns", "-n", "kube-system", "-o", "json", "--show-managed-fields")
		assert.NoError(err)
		kubeDnsCM := utils.ParseKubectlJSONResult(t, listKubeDnsConfigMap)
		assert.Contains("kube-dns", kubeDnsCM.Get("metadata.name").String(), "kube-dns configmap is present")
		assert.Equal("Terraform", kubeDnsCM.Get("metadata.managedFields.0.manager").String(), "kube-dns configmap is managed by Terraform")
		//assert.Equal("[\"8.8.8.8\",\"8.8.4.4\"]\n", kubeDnsCM.Get("data.stubDomains").String(), "kube-dns configmap reflects the upstream_nameservers configuration")

		assert.JSONEq(`{
			"example.com": [
				"10.254.154.11",
				"10.254.154.12"
			],
			"example.net": [
				"10.254.154.11",
				"10.254.154.12"
			]
		}`,
		kubeDnsCM.Get("data.stubDomains").String(), "kube-dns configmap the expected stubdomains")

		// ip-masq-agent
		listIpMasqAgentConfigMap, err := k8s.RunKubectlAndGetOutputE(t, k8sOpts, "get", "configmap", "ip-masq-agent", "-n", "kube-system", "-o", "json", "--show-managed-fields")
		assert.NoError(err)
		ipMasqAgentConfigMap := utils.ParseKubectlJSONResult(t, listIpMasqAgentConfigMap)
		assert.Contains("ip-masq-agent", ipMasqAgentConfigMap.Get("metadata.name").String(), "ip-masq-agent configmap is present")
		assert.Equal("terraform", ipMasqAgentConfigMap.Get("metadata.labels.maintained_by").String(), "ip-masq-agent configmap is maintained_by Terraform")
		assert.Equal("nonMasqueradeCIDRs:\n  - 10.0.0.0/8\n  - 172.16.0.0/12\n  - 192.168.0.0/16\nresyncInterval: 60s\nmasqLinkLocal: false\n", ipMasqAgentConfigMap.Get("data.config").String(), "ip-masq-agent configmap is configured properly")

	})
	bpt.Test()
}
