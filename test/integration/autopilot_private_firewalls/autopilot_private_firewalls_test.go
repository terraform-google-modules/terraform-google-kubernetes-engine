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
package autopilot_private_firewalls

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestAutopilotPrivateFirewalls(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)
	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)
		projectId := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		serviceAccount := bpt.GetStringOutput("service_account")
		clusterNetworkTag := "gke-" + clusterName
		firewallRules := []string{"gke-%s-intra-cluster-egress", "gke-%s-webhooks", "gke-shadow-%s-all", "gke-shadow-%s-master", "gke-shadow-%s-vms", "gke-shadow-%s-inkubelet", "gke-shadow-%s-exkubelet"}
		var fws []string
		for _, fw := range firewallRules {
			n := fmt.Sprintf(fw, clusterName)
			fws = append(fws, n)
		}
		op := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)
		g := golden.NewOrUpdate(t, op.String(),
			golden.WithSanitizer(golden.StringSanitizer(serviceAccount, "SERVICE_ACCOUNT")),
			golden.WithSanitizer(golden.StringSanitizer(projectId, "PROJECT_ID")),
			golden.WithSanitizer(golden.StringSanitizer(clusterName, "CLUSTER_NAME")),
		)
		validateJSONPaths := []string{
			"autopilot.enabled",
			"location",
			"privateClusterConfig.enablePrivateEndpoint",
			"privateClusterConfig.enablePrivateNodes",
			"privateClusterConfig.addClusterFirewallRules",
			"privateClusterConfig.addMasterWebhookFirewallRules",
			"privateClusterConfig.addShadowFirewallRules",
		}

		for _, pth := range validateJSONPaths {
			g.JSONEq(assert, op, pth)
		}

		assert.Contains([]string{"RUNNING", "RECONCILING"}, op.Get("status").String())               // comes up healthy
		assert.Contains(op.Get("nodePoolAutoConfig.networkTags.tags").String(), "allow-google-apis") // example network_tag attached
		assert.Contains(op.Get("nodePoolAutoConfig.networkTags.tags").String(), clusterNetworkTag)   // the cluster_network_tag attached

		for _, n := range fws {
			fw := gcloud.Runf(t, "compute firewall-rules --project %s describe %s", projectId, n)
			assert.Contains(fw.Get("targetTags").String(), clusterNetworkTag) // firewall target tag is the cluster_network_tag
		}
	})
	bpt.Test()
}
