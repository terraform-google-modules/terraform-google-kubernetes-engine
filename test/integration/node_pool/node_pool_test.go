// Copyright 2024 Google LLC
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
	"slices"
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

func TestNodePool(t *testing.T) {
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

		// Retrieve Project CAI
		projectCAI := cai.GetProjectResources(t, projectId, cai.WithAssetTypes([]string{"container.googleapis.com/Cluster", "k8s.io/Node"}))
		t.Log(projectCAI.Raw)
		// Retrieve Cluster from CAI
		clusterResourceName := fmt.Sprintf("//container.googleapis.com/projects/%s/locations/%s/clusters/%s", projectId, location, clusterName)

		if !projectCAI.Get("#(name=\"" + clusterResourceName + "\").resource.data").Exists() {
			t.Fatalf("Cluster not found: %s", clusterResourceName)
		}

		cluster := projectCAI.Get("#(name=\"" + clusterResourceName + "\").resource.data")
		t.Log(cluster.Raw)
		// Equivalent gcloud describe command (classic)
		// cluster := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)

		// Cluster Assertions (classic)
		assert.Contains([]string{"RUNNING", "RECONCILING"}, cluster.Get("status").String(), "Cluster is Running")
		assert.Equal("COS_CONTAINERD", cluster.Get("autoscaling.autoprovisioningNodePoolDefaults.imageType").String(), "has the expected image type")
		assert.Equal("https://www.googleapis.com/auth/cloud-platform", cluster.Get("autoscaling.autoprovisioningNodePoolDefaults.oauthScopes.0").String(), "has the expected oauth scopes")
		assert.Equal("default", cluster.Get("autoscaling.autoprovisioningNodePoolDefaults.serviceAccount").String(), "has the expected service account")
		assert.Equal("OPTIMIZE_UTILIZATION", cluster.Get("autoscaling.autoscalingProfile").String(), "has the expected autoscaling profile")
		assert.True(cluster.Get("autoscaling.enableNodeAutoprovisioning").Bool(), "has the expected node autoprovisioning")
		assert.JSONEq(`[
				{
						"maximum": "20",
						"minimum": "5",
						"resourceType": "cpu"
				},
				{
						"maximum": "30",
						"minimum": "10",
						"resourceType": "memory"
				}
			]`,
			cluster.Get("autoscaling.resourceLimits").String(), "has the expected resource limits")

		// Cluster Assertions using golden image (TestNodePool.json) with sanitizer
		g := golden.NewOrUpdate(t, cluster.String(),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(randomString, "RANDOM_STRING")),
			golden.WithSanitizer(golden.StringSanitizer(kubernetesEndpoint, "KUBERNETES_ENDPOINT")),
		)
		checkPaths := utils.GetTerminalJSONPaths(g.GetJSON())

		exemptPaths := []string{"nodePools"}
		checkPaths = slices.DeleteFunc(checkPaths, func(s string) bool {
			return slices.Contains(exemptPaths, s)
		})
		g.JSONPathEqs(assert, cluster, checkPaths)

		// NodePool Assertions
		nodePools := []string{"pool-01", "pool-02", "pool-03", "pool-04", "pool-05"}
		for _, nodePool := range nodePools {
			g.JSONPathEqs(assert, cluster.Get(fmt.Sprintf("nodePools.#(name==%s).name", nodePool)), utils.GetTerminalJSONPaths(g.GetJSON().Get(fmt.Sprintf("nodePools.#(name==%s).name", nodePool))))
		}

		// nodePool-01 Assertions
		assert.Equal("pool-01", cluster.Get("nodePools.#(name==\"pool-01\").name").String(), "pool-1 exists")
		assert.Equal("e2-medium", cluster.Get("nodePools.#(name==\"pool-01\").config.machineType").String(), "is the expected machine type")
		assert.Equal("COS_CONTAINERD", cluster.Get("nodePools.#(name==\"pool-01\").config.imageType").String(), "has the expected image")
		assert.True(cluster.Get("nodePools.#(name==\"pool-01\").autoscaling.enabled").Bool(), "has autoscaling enabled")
		assert.Equal(int64(1), cluster.Get("nodePools.#(name==\"pool-01\").autoscaling.minNodeCount").Int(), "has the expected minimum node count")
		assert.True(cluster.Get("nodePools.#(name==\"pool-01\").management.autoRepair").Bool(), "has autorepair enabled")
		assert.True(cluster.Get("nodePools.#(name==\"pool-01\").management.autoUpgrade").Bool(), "has automatic upgrades enabled")
		assert.Equal("kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-local-data \"$HOSTNAME\"", cluster.Get("nodePools.#(name==\"pool-01\").config.metadata.shutdown-script").String(), "pool-2 exists")
		assert.Equal("false", cluster.Get("nodePools.#(name==\"pool-01\").config.metadata.disable-legacy-endpoints").String(), "pool-2 exists")
		assert.JSONEq(fmt.Sprintf(`{"all-pools-example": "true", "pool-01-example": "true", "cluster_name": "%s", "node_pool": "pool-01"}`, clusterName),
			cluster.Get("nodePools.#(name==\"pool-01\").config.labels").String(), "has the expected labels")
		assert.ElementsMatch([]string{"all-node-example", "pool-01-example", fmt.Sprintf("gke-%s", clusterName), fmt.Sprintf("gke-%s-pool-01", clusterName)},
			cluster.Get("nodePools.#(name==\"pool-01\").config.tags").Value().([]interface{}), "has the expected network tags")
		assert.Equal(int64(10000), cluster.Get("nodePools.#(name==\"pool-01\").config.linuxNodeConfig.sysctls.net\\.core\\.netdev_max_backlog").Int(), "has the expected linux node config net.core.netdev_max_backlog sysctl")
		assert.Equal(int64(10000), cluster.Get("nodePools.#(name==\"pool-01\").config.linuxNodeConfig.sysctls.net\\.core\\.rmem_max").Int(), "has the expected linux node config net.core.rmem_max sysctl")

		// nodePool-02 Assertions
		assert.Equal("pool-02", cluster.Get("nodePools.#(name==\"pool-02\").name").String(), "pool-2 exists")
		assert.Equal("n1-standard-2", cluster.Get("nodePools.#(name==\"pool-02\").config.machineType").String(), "is the expected machine type")
		assert.True(cluster.Get("nodePools.#(name==\"pool-02\").autoscaling.enabled").Bool(), "has autoscaling enabled")
		assert.Equal(int64(1), cluster.Get("nodePools.#(name==\"pool-02\").autoscaling.minNodeCount").Int(), "has the expected minimum node count")
		assert.Equal(int64(2), cluster.Get("nodePools.#(name==\"pool-02\").autoscaling.maxNodeCount").Int(), "has the expected maximum node count")
		assert.Equal(int64(30), cluster.Get("nodePools.#(name==\"pool-02\").config.diskSizeGb").Int(), "has the expected disk size")
		assert.Equal("pd-standard", cluster.Get("nodePools.#(name==\"pool-02\").config.diskType").String(), "has the expected disk type")
		assert.Equal("COS_CONTAINERD", cluster.Get("nodePools.#(name==\"pool-02\").config.imageType").String(), "has the expected image")
		assert.JSONEq(fmt.Sprintf(`{"all-pools-example": "true", "cluster_name": "%s", "node_pool": "pool-02"}`, clusterName),
			cluster.Get("nodePools.#(name==\"pool-02\").config.labels").String(), "has the expected labels")
		assert.ElementsMatch([]string{"all-node-example", fmt.Sprintf("gke-%s", clusterName), fmt.Sprintf("gke-%s-pool-02", clusterName)},
			cluster.Get("nodePools.#(name==\"pool-02\").config.tags").Value().([]interface{}), "has the expected network tags")
		assert.Equal(int64(10000), cluster.Get("nodePools.#(name==\"pool-02\").config.linuxNodeConfig.sysctls.net\\.core\\.netdev_max_backlog").Int(), "has the expected linux node config sysctls")

		// nodwPool-03 Assertions
		assert.Equal("pool-03", cluster.Get("nodePools.#(name==\"pool-03\").name").String(), "pool-3 exists")
		assert.JSONEq(fmt.Sprintf(`["%s-b", "%s-c"]`, location, location), cluster.Get("nodePools.#(name==\"pool-03\").locations").String(), "has nodes in correct locations")
		assert.Equal("n1-standard-2", cluster.Get("nodePools.#(name==\"pool-03\").config.machineType").String(), "is the expected machine type")
		assert.False(cluster.Get("nodePools.#(name==\"pool-03\").autoscaling.enabled").Bool(), "has autoscaling enabled")
		assert.Equal(int64(2), cluster.Get("nodePools.#(name==\"pool-03\").initialNodeCount").Int(), "has the expected inital node count")
		assert.True(cluster.Get("nodePools.#(name==\"pool-03\").management.autoRepair").Bool(), "has autorepair enabled")
		assert.True(cluster.Get("nodePools.#(name==\"pool-03\").management.autoUpgrade").Bool(), "has automatic upgrades enabled")
		assert.JSONEq(fmt.Sprintf(`{"all-pools-example": "true", "cluster_name": "%s", "node_pool": "pool-03", "sandbox.gke.io/runtime": "gvisor"}`, clusterName),
			cluster.Get("nodePools.#(name==\"pool-03\").config.labels").String(), "has the expected labels")
		assert.ElementsMatch([]string{"all-node-example", fmt.Sprintf("gke-%s", clusterName), fmt.Sprintf("gke-%s-pool-03", clusterName)},
			cluster.Get("nodePools.#(name==\"pool-03\").config.tags").Value().([]interface{}), "has the expected network tags")
		assert.Equal("172.16.0.0/18", cluster.Get("nodePools.#(name==\"pool-03\").networkConfig.podIpv4CidrBlock").String(), "has the expected pod range")
		assert.Equal("test", cluster.Get("nodePools.#(name==\"pool-03\").networkConfig.podRange").String(), "has the expected pod range")
		assert.Equal("COS_CONTAINERD", cluster.Get("nodePools.#(name==\"pool-03\").config.imageType").String(), "has the expected image")
		assert.Equal("static", cluster.Get("nodePools.#(name==\"pool-03\").config.kubeletConfig.cpuManagerPolicy").String(), "has the expected cpuManagerPolicy kubelet config")
		assert.True(cluster.Get("nodePools.#(name==\"pool-03\").config.kubeletConfig.cpuCfsQuota").Bool(), "has the expected cpuCfsQuota kubelet config")
		assert.Equal(int64(20000), cluster.Get("nodePools.#(name==\"pool-03\").config.linuxNodeConfig.sysctls.net\\.core\\.netdev_max_backlog").Int(), "has the expected linux node config sysctls")

		// nodePool-04 Assertions
		assert.Equal("pool-04", cluster.Get("nodePools.#(name==\"pool-04\").name").String(), "pool-4 exists")
		assert.False(cluster.Get("nodePools.#(name==\"pool-04\").config.queuedProvisioning.enabled").Bool(), "has queued provisioning not enabled")

		// nodePool-05 Assertions
		assert.Equal("pool-05", cluster.Get("nodePools.#(name==\"pool-05\").name").String(), "pool-5 exists")
		assert.True(cluster.Get("nodePools.#(name==\"pool-05\").config.advancedMachineFeatures.enableNestedVirtualization").Bool(), "has enable_nested_virtualization enabled")

		// K8s Assertions
		gcloud.Runf(t, "container clusters get-credentials %s --region %s --project %s", clusterName, location, projectId)
		k8sOpts := k8s.KubectlOptions{}
		clusterNodesOp, err := k8s.RunKubectlAndGetOutputE(t, &k8sOpts, "get", "nodes", "-o", "json")
		assert.NoError(err)
		clusterNodes := utils.ParseKubectlJSONResult(t, clusterNodesOp)
		assert.JSONEq(`[
				{
					"effect": "PreferNoSchedule",
					"key": "all-pools-example",
					"value": "true"
				},
				{
					"effect": "PreferNoSchedule",
					"key": "pool-01-example",
					"value": "true"
				}
			]`,
			clusterNodes.Get("items.#(metadata.labels.node_pool==\"pool-01\").spec.taints").String(), "has the expected taints")
		assert.JSONEq(`[
				{
					"effect": "PreferNoSchedule",
					"key": "all-pools-example",
					"value": "true"
				},
				{
					"effect": "NoSchedule",
					"key": "nvidia.com/gpu",
					"value": "present"
				}
			]`,
			clusterNodes.Get("items.#(metadata.labels.node_pool==\"pool-02\").spec.taints").String(), "has the expected all-pools-example taint")
		assert.JSONEq(`[
				{
					"effect": "PreferNoSchedule",
					"key": "all-pools-example",
					"value": "true"
				},
				{
					"effect": "NoSchedule",
					"key": "sandbox.gke.io/runtime",
					"value": "gvisor"
				}
			]`,
			clusterNodes.Get("items.#(metadata.labels.node_pool==\"pool-03\").spec.taints").String(), "has the expected all-pools-example taint")
	})

	bpt.Test()
}
