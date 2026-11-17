// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package containerd_registry_hosts

import (
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestContainerdRegistryHosts(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithParallelism(testutils.DefaultTerraformParallelism),
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, testutils.RetriesOnTransientErrors, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		testutils.TGKEVerify(t, bpt, assert)

		projectID := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		cluster := gcloud.Runf(t, "container clusters describe %s --location %s --project %s", clusterName, location, projectID)
		registries := cluster.Get("nodePoolDefaults.nodeConfigDefaults.containerdConfig.registryHosts").Array()
		if !assert.Len(registries, 1) {
			return
		}
		assert.Equal("docker.io", registries[0].Get("server").String())

		hosts := registries[0].Get("hosts").Array()
		if !assert.Len(hosts, 1) {
			return
		}
		assert.Equal("https://mirror.gcr.io", hosts[0].Get("host").String())
		var capabilities []string
		for _, capability := range hosts[0].Get("capabilities").Array() {
			capabilities = append(capabilities, capability.String())
		}
		assert.ElementsMatch([]string{"HOST_CAPABILITY_PULL", "HOST_CAPABILITY_RESOLVE"}, capabilities)
		assert.Contains([]string{"RUNNING", "RECONCILING"}, cluster.Get("status").String())
	})

	bpt.Test()
}
