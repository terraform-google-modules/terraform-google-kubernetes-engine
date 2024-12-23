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
package safer_cluster_iap_bastion

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

func TestSaferClusterIapBastion(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		// Skipping Default Verify as the Verify Stage fails due to change in Client Cert Token
		// bpt.DefaultVerify(assert)
		testutils.TGKEVerify(t, bpt, assert) // Verify Resources

		testCommand, _ := strings.CutPrefix(bpt.GetStringOutput("test_command"), "gcloud ")

		// pre run ssh command so that ssh-keygen can run
		gcloud.RunCmd(t, testCommand,
			gcloud.WithCommonArgs([]string{}),
		)

		clusterVersion := fmt.Sprintf("v%s", bpt.GetStringOutput("cluster_version"))

		op := gcloud.Run(t, testCommand,
			gcloud.WithCommonArgs([]string{}),
		)

		assert.Equal(clusterVersion, op.Get("gitVersion").String(), "SSH into VM and verify connectivity to GKE")
	})

	bpt.Test()
}
