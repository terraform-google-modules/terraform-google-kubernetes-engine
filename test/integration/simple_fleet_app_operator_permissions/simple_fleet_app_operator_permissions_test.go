// Copyright 2024 Google LLC
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

package simple_fleet_app_operator_permissions

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestSimpleFleetAppOperatorPermissions(t *testing.T) {
	appOppT := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)
	appOppT.DefineVerify(func(assert *assert.Assertions) {
		appOppT.DefaultVerify(assert)

		projectId := appOppT.GetStringOutput("project_id")
		scopeId := "app-operator-team"
		appOperatorEmail := fmt.Sprintf("app-operator-id@%s.iam.gserviceaccount.com", projectId)
		appOperatorPrincipal := fmt.Sprintf("serviceAccount:%s", appOperatorEmail)
		scopeLevelRole := "roles/gkehub.scopeViewer"
		projectLevelRole := "roles/gkehub.scopeViewerProjectLevel"
		logViewRole := "roles/logging.viewAccessor"
		logViewContainerBucket := fmt.Sprintf("projects/%s/locations/global/buckets/fleet-o11y-scope-%s/views/fleet-o11y-scope-%s-k8s_container", projectId, scopeId, scopeId)
		logViewPodBucket := fmt.Sprintf("projects/%s/locations/global/buckets/fleet-o11y-scope-%s/views/fleet-o11y-scope-%s-k8s_pod", projectId, scopeId, scopeId)

		scopeRrbList := gcloud.Runf(t, "container fleet scopes rbacrolebindings list --scope %s --project %s", scopeId, projectId).String()
		assert.Equal(strings.Contains(scopeRrbList, appOperatorEmail), true, "app operator email should be in the list of Scope RBAC Role Bindings")

		scopeIam := gcloud.Runf(t, "container fleet scopes get-iam-policy %s --project %s", scopeId, projectId).String()
		assert.Equal(strings.Contains(scopeIam, appOperatorPrincipal), true, "app operator principal should be in the Scope IAM policy")
		assert.Equal(strings.Contains(scopeIam, scopeLevelRole), true, "app operator Scope role should be in the Scope IAM policy")

		projectIam := gcloud.Runf(t, "projects get-iam-policy %s", projectId).String()
		assert.Equal(strings.Contains(projectIam, appOperatorPrincipal), true, "app operator principal should be in the project IAM policy")
		assert.Equal(strings.Contains(projectIam, projectLevelRole), true, "app operator Scope role should be in the project IAM policy")
		assert.Equal(strings.Contains(projectIam, logViewRole), true, "app operator log view role should be in the project IAM policy")
		assert.Equal(strings.Contains(projectIam, logViewContainerBucket), true, "app operator log view container bucket should be in the project IAM policy")
		assert.Equal(strings.Contains(projectIam, logViewPodBucket), true, "app operator log view pod bucket should be in the project IAM policy")
	})

	appOppT.Test()
}

