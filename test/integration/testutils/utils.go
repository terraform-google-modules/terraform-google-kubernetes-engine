// Copyright 2022-2025 Google LLC
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

package testutils

import (
	"cmp"
	"fmt"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	tfjson "github.com/hashicorp/terraform-json"
	"github.com/stretchr/testify/assert"
	"github.com/tidwall/gjson"
)

var (
	RetryableTransientErrors = map[string]string{
		// Error 409: Operation / Policy conflicts
		".*Error 409.*unable to queue the operation":            "Unable to queue operation.",
		".*Error 409.*There were concurrent policy changes.*":   "Concurrent policy changes.",
		".*Error 409.*Another operation is already in progress": "Another operation in progress.",
		".*Error 409.*is in use":                                "Resource in use.",

		// Rate limiting & Quotas
		".*rateLimitExceeded.*":        "Rate limit exceeded.",
		".*quotaExceeded.*":            "Quota exceeded.",
		".*RESOURCE_EXHAUSTED.*":       "Resource exhausted.",
		".*User Rate Limit Exceeded.*": "User rate limit exceeded.",

		// 5xx and Internal Server Errors
		".*Error 500.*":    "Internal server error.",
		".*Error 502.*":    "Bad gateway.",
		".*Error 503.*":    "Service unavailable.",
		".*backendError.*": "Backend error.",
		".*Error code 13, message: an internal error has occurred": "Internal error.",

		// GKE Cluster update/lock conflicts
		".*Error 400: Cluster is running incompatible operation.*":      "Incompatible operation.",
		".*Error 400.*Master is being updated.*":                        "Master is being updated.",
		".*Error 400.*Cluster is being updated.*":                       "Cluster is being updated.",
		".*Error 400.*Cluster is not ready for operation.*":             "Cluster not ready.",
		".*resource is currently locked as part of another operation.*": "Resource locked.",

		// Transient IAM / SA replication
		".*Permission.*denied on resource.*":   "IAM permission replication delay.",
		".*Caller is missing IAM permission.*": "IAM permission replication delay.",
		".*serviceAccount.*does not exist.*":   "Service account replication delay.",

		// Transport / Network drops
		".*connection reset by peer.*":       "Connection reset by peer.",
		".*TLS handshake timeout.*":          "TLS handshake timeout.",
		".*transport: Error while dialing.*": "Transport dialing error.",
		".*i/o timeout.*":                    "I/O timeout.",
	}

	ClusterAlwaysExemptPaths = []string{
		"nodePools", // node pools are separately checked by name
		"monitoringConfig.componentConfig.enableComponents",
		"labelFingerprint",
		"maintenancePolicy.resourceVersion",
		"etag",
	}
)

func GetTestProjectFromSetup(t *testing.T, idx int) string {
	setup := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, 3, 2*time.Minute),
	)
	projectIDs := setup.GetTFSetupOutputListVal("project_ids")
	if len(projectIDs)-1 < idx {
		t.Fatalf("project_ids has %d elements, index of %d is invalid", len(projectIDs), idx)
	}
	return projectIDs[idx]
}

// TGKEVerify asserts no resource changes exist after apply.
func TGKEVerify(t *testing.T, b *tft.TFBlueprintTest, assert *assert.Assertions) {
	TGKEVerifyExemptResources(t, b, assert, []string{})
}

// TGKEVerifyExemptResources asserts no resource changes exist after apply except exempt resources: e.g. google_container_cluster.primary
func TGKEVerifyExemptResources(t *testing.T, b *tft.TFBlueprintTest, assert *assert.Assertions, verifyExemptResources []string) {
	_, ps := b.PlanAndShow()
	for _, r := range ps.ResourceChangesMap {
		if slices.ContainsFunc(verifyExemptResources, func(str string) bool {
			return strings.HasSuffix(r.Address, str)
		}) {
			t.Logf("Exempt plan address: %s", r.Address)
			continue
		}
		assert.Equal(tfjson.Actions{tfjson.ActionNoop}, r.Change.Actions, "Plan must be no-op for resource: %s", r.Address)
	}
}

// TGKEAssertGolden asserts a cluster and listed node pools against paths in golden image
func TGKEAssertGolden(assert *assert.Assertions, golden *golden.GoldenFile, clusterJson *gjson.Result, nodePools []string, exemptClusterPaths []string) {
	// Retrieve golden paths
	clusterCheckPaths := utils.GetTerminalJSONPaths(golden.GetJSON())

	// Remove exempt cluster paths
	exemptPaths := slices.Concat(exemptClusterPaths, ClusterAlwaysExemptPaths)
	clusterCheckPaths = slices.DeleteFunc(clusterCheckPaths, func(s string) bool {
		for _, exempPath := range exemptPaths {
			if strings.HasPrefix(s, exempPath) {
				return true
			}
		}
		return false
	})

	// Cluster assertions
	golden.JSONPathEqs(assert, *clusterJson, clusterCheckPaths)

	// NodePool assertions
	for _, nodePool := range nodePools {
		assert.Truef(clusterJson.Get(fmt.Sprintf("nodePools.#(name==%s).name", nodePool)).Exists(), "NodePool not found: %s", nodePool)

		nodeCheckPaths := utils.GetTerminalJSONPaths(golden.GetJSON().Get(fmt.Sprintf("nodePools.#(name==%s)", nodePool)))

		for _, nodeCheckPath := range nodeCheckPaths {
			gotData := golden.ApplySanitizers(clusterJson.Get(fmt.Sprintf("nodePools.#(name==%s)", nodePool)).Get(nodeCheckPath).String())
			gfData := golden.GetJSON().Get(fmt.Sprintf("nodePools.#(name==%s)", nodePool)).Get(nodeCheckPath).String()
			assert.Equalf(gfData, gotData, "For node %q path %q expected %q to match fixture %q", nodePool, nodeCheckPath, gotData, gfData)
		}
	}
}

// GKEClusterSanitizer returns a Sanitizer that sanitizes common GKE cluster fields,
// including dynamic node image versions.
func GKEClusterSanitizer(serviceAccount, projectId, clusterName string, clusterJson gjson.Result) golden.Sanitizer {
	return func(s string) string {
		s = golden.StringSanitizer(serviceAccount, "SERVICE_ACCOUNT")(s)
		s = golden.StringSanitizer(projectId, "PROJECT_ID")(s)
		s = golden.StringSanitizer(clusterName, "CLUSTER_NAME")(s)

		var images []string
		for _, np := range clusterJson.Get("nodePools").Array() {
			image := np.Get("config.nodeImageConfig.image").String()
			if image != "" && !slices.Contains(images, image) {
				images = append(images, image)
			}
		}

		// Sort images by length descending to prevent substring collision
		slices.SortFunc(images, func(a, b string) int {
			return cmp.Compare(len(b), len(a))
		})

		for _, image := range images {
			s = golden.StringSanitizer(image, "NODE_IMAGE")(s)
		}
		return s
	}
}
