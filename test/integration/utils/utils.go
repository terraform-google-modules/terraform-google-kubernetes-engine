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

package utils

import (
	"slices"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	tfjson "github.com/hashicorp/terraform-json"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func GetTestProjectFromSetup(t *testing.T, idx int) string {
	setup := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)
	projectIDs := setup.GetTFSetupOutputListVal("project_ids")
	if len(projectIDs)-1 < idx {
		t.Fatalf("project_ids has %d elements, index of %d is invalid", len(projectIDs), idx)
	}
	return projectIDs[idx]
}

var (
	// TGKEVerify Exempt Resources. e.g. google_container_cluster.primary
	verifyExemptResources = []string{}
)

func TGKEVerify(t *testing.T, b *tft.TFBlueprintTest, assert *assert.Assertions) {
	_, ps := b.PlanAndShow()
	for _, r := range ps.ResourceChangesMap {
		if slices.Contains(verifyExemptResources, r.Address) {
			t.Logf("Exempt plan address: %s", r.Address)
			continue
		}
		assert.Equal(tfjson.Actions{tfjson.ActionNoop}, r.Change.Actions, "Plan must be no-op for resource: %s", r.Address)
	}
}
