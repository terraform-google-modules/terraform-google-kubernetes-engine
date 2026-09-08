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
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
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
		customAppOperatorEmail := fmt.Sprintf("custom-app-operator-id@%s.iam.gserviceaccount.com", projectId)
		customAppOperatorPrincipal := fmt.Sprintf("serviceAccount:%s", customAppOperatorEmail)
		customScopeLevelRole := "roles/gkehub.scopeViewer"
		customProjectLevelRole := "roles/gkehub.scopeEditorProjectLevel"
		logViewRole := "roles/logging.viewAccessor"
		logViewContainerBucket := fmt.Sprintf("projects/%s/locations/global/buckets/fleet-o11y-scope-%s/views/fleet-o11y-scope-%s-k8s_container", projectId, scopeId, scopeId)
		logViewPodBucket := fmt.Sprintf("projects/%s/locations/global/buckets/fleet-o11y-scope-%s/views/fleet-o11y-scope-%s-k8s_pod", projectId, scopeId, scopeId)
		filterFormat := "\"bindings.members:%s\""
		flattenOpt := "bindings[].members"

		utils.Poll(t, func() (bool, error) {
			scopeRrbList := gcloud.Runf(t, "container fleet scopes rbacrolebindings list --scope %s --project %s", scopeId, projectId).String()
			if !strings.Contains(scopeRrbList, appOperatorEmail) || !strings.Contains(scopeRrbList, customAppOperatorEmail) {
				return true, fmt.Errorf("waiting for Scope RBAC Role Bindings")
			}

			scopeIam := gcloud.Runf(t, "container fleet scopes get-iam-policy %s --project %s --filter %s", scopeId, projectId, fmt.Sprintf(filterFormat, appOperatorPrincipal)).String()
			if !strings.Contains(scopeIam, scopeLevelRole) {
				return true, fmt.Errorf("waiting for app operator Scope role in Scope IAM policy")
			}

			customScopeIam := gcloud.Runf(t, "container fleet scopes get-iam-policy %s --project %s --filter %s", scopeId, projectId, fmt.Sprintf(filterFormat, customAppOperatorPrincipal)).String()
			if !strings.Contains(customScopeIam, customScopeLevelRole) {
				return true, fmt.Errorf("waiting for custom app operator Scope role in Scope IAM policy")
			}

			projectIam := gcloud.Runf(t, "projects get-iam-policy %s --filter %s --flatten %s", projectId, fmt.Sprintf(filterFormat, appOperatorPrincipal), flattenOpt).String()
			if !strings.Contains(projectIam, projectLevelRole) || !strings.Contains(projectIam, logViewRole) ||
				!strings.Contains(projectIam, logViewContainerBucket) || !strings.Contains(projectIam, logViewPodBucket) {
				return true, fmt.Errorf("waiting for app operator project IAM policy")
			}

			customProjectIam := gcloud.Runf(t, "projects get-iam-policy %s --filter %s --flatten %s", projectId, fmt.Sprintf(filterFormat, customAppOperatorPrincipal), flattenOpt).String()
			if !strings.Contains(customProjectIam, customProjectLevelRole) || !strings.Contains(customProjectIam, logViewRole) ||
				!strings.Contains(customProjectIam, logViewContainerBucket) || !strings.Contains(customProjectIam, logViewPodBucket) {
				return true, fmt.Errorf("waiting for custom app operator project IAM policy")
			}

			return false, nil
		}, 20, 5*time.Second)
	})

	appOppT.Test()
}
