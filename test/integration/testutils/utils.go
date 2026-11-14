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
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/golden"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/gruntwork-io/terratest/modules/k8s"
	tfjson "github.com/hashicorp/terraform-json"
	"github.com/stretchr/testify/assert"
	"github.com/tidwall/gjson"
)

const (
	RetriesOnTransientErrors    int = 5
	DefaultTerraformParallelism int = 3
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
		".*Error 504.*":    "Gateway timeout.",
		".*backendError.*": "Backend error.",
		".*Error code 13, message: an internal error has occurred": "Internal error.",

		// GKE Cluster update/lock conflicts
		".*Error 400.*Cluster is running incompatible operation.*":      "Incompatible operation.",
		".*Error 400.*Master is being updated.*":                        "Master is being updated.",
		".*Error 400.*Cluster is being updated.*":                       "Cluster is being updated.",
		".*Error 400.*Cluster is not ready for operation.*":             "Cluster not ready.",
		".*Error 400.*is currently creating a node pool.*":              "Node pool creation conflict.",
		".*Error 400.*is currently deleting a node pool.*":              "Node pool deletion conflict.",
		".*Error 400.*is already being used by.*":                       "Resource dependency cleanup delay.",
		".*Error 400.*resourceInUseByAnotherResource.*":                 "Resource in use by another resource.",
		".*Error 400.*Precondition check failed.*":                      "Concurrent operation precondition failure.",
		".*resource is currently locked as part of another operation.*": "Resource locked.",
		".*NodePool.*was created in the error state.*":                  "Node pool creation failed in error state.",
		".*Cluster.*was created in the error state.*":                   "Cluster creation failed in error state.",
		".*Failed to create cluster.*":                                  "Failed to create cluster.",
		".*DeployPatch failed.*":                                        "Cluster control plane deploy patch failed.",
		".*Failed to create psm_notification_config.*":                  "GKE PSM notification config concurrent creation race.",
		".*ProjectPSMNotificationConfigs.*":                             "GKE PSM notification config concurrent creation race.",
		".*Try a different location, or try again later: Google Compute Engine does not have enough resources available to fulfill request.*": "Compute resource pool exhausted.",
		".*GCE_STOCKOUT.*": "GCE stockout.",
		".*does not have enough resources available to fulfill.*": "Compute resource pool exhausted.",

		// Transient IAM / SA replication
		".*Permission.*denied on resource.*":   "IAM permission replication delay.",
		".*Caller is missing IAM permission.*": "IAM permission replication delay.",
		".*serviceAccount.*does not exist.*":   "Service account replication delay.",

		// Transport / Network drops
		".*connection reset by peer.*":              "Connection reset by peer.",
		".*TLS handshake timeout.*":                 "TLS handshake timeout.",
		".*transport: Error while dialing.*":        "Transport dialing error.",
		".*i/o timeout.*":                           "I/O timeout.",
		".*context deadline exceeded.*":             "Client context deadline exceeded.",
		".*net/http: request canceled.*":            "HTTP request canceled.",
		".*dial tcp.*connect: connection refused.*": "Control plane endpoint temporarily unavailable.",
		".*unexpected EOF.*":                        "Unexpected EOF during API transport.",
	}

	ClusterAlwaysExemptPaths = []string{
		"nodePools", // node pools are separately checked by name
		"monitoringConfig.componentConfig.enableComponents",
		"labelFingerprint",
		"maintenancePolicy.resourceVersion",
		"privateClusterConfig.privateEndpoint",
		"controlPlaneEndpointsConfig.ipEndpointsConfig.privateEndpoint",
		"etag",
	}
)

func GetTestProjectFromSetup(t *testing.T, idx int) string {
	setup := tft.NewTFBlueprintTest(t,
		tft.WithParallelism(DefaultTerraformParallelism),
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, RetriesOnTransientErrors, 2*time.Minute),
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
	isExempt := func(addr string) bool {
		return slices.ContainsFunc(verifyExemptResources, func(str string) bool {
			return strings.HasSuffix(addr, str)
		})
	}

	_, ps := b.PlanAndShow()
	hasDrift := false
	for _, r := range ps.ResourceChangesMap {
		if isExempt(r.Address) {
			continue
		}
		if !slices.Equal(tfjson.Actions{tfjson.ActionNoop}, r.Change.Actions) {
			hasDrift = true
			t.Logf("Post-apply plan reported %v on %s; waiting 30s to re-check eventual consistency...", r.Change.Actions, r.Address)
		}
	}
	if hasDrift {
		time.Sleep(30 * time.Second)
		_, ps = b.PlanAndShow()
	}

	for _, r := range ps.ResourceChangesMap {
		if isExempt(r.Address) {
			t.Logf("Exempt plan address: %s", r.Address)
			continue
		}
		assert.Equal(tfjson.Actions{tfjson.ActionNoop}, r.Change.Actions, "Plan must be no-op for resource: %s", r.Address)
	}
}

// GetIsolatedKubectlOptions creates an isolated kubeconfig in a temp dir and populates credentials
// via gcloud, avoiding state collisions on the default kubeconfig.
func GetIsolatedKubectlOptions(t *testing.T, projectID, location, clusterName string, regional bool) *k8s.KubectlOptions {
	kubeconfigPath := filepath.Join(t.TempDir(), "kubeconfig")
	locFlag := "--zone"
	if regional {
		locFlag = "--region"
	}
	utils.Poll(t, func() (bool, error) {
		cmd := exec.Command("gcloud", "container", "clusters", "get-credentials", clusterName, locFlag, location, "--project", projectID)
		cmd.Env = append(os.Environ(), "KUBECONFIG="+kubeconfigPath)
		output, err := cmd.CombinedOutput()
		if err != nil {
			t.Logf("get-credentials failed: %v, output: %s", err, string(output))
			return true, err
		}
		return false, nil
	}, 6, 5*time.Second)
	return k8s.NewKubectlOptions(fmt.Sprintf("gke_%s_%s_%s", projectID, location, clusterName), kubeconfigPath, "")
}

// TGKEAssertGolden asserts a cluster and listed node pools against paths in golden image
func TGKEAssertGolden(assert *assert.Assertions, golden *golden.GoldenFile, clusterJson *gjson.Result, nodePools []string, exemptClusterPaths []string) {
	// Retrieve golden paths
	clusterCheckPaths := utils.GetTerminalJSONPaths(golden.GetJSON())

	// Remove exempt cluster paths
	exemptPaths := slices.Concat(exemptClusterPaths, ClusterAlwaysExemptPaths)
	clusterCheckPaths = slices.DeleteFunc(clusterCheckPaths, func(s string) bool {
		for _, exempPath := range exemptPaths {
			if s == exempPath || strings.HasPrefix(s, exempPath+".") {
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
