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
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
	"github.com/tidwall/gjson"
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

		clusterVersion := fmt.Sprintf("v%s", bpt.GetStringOutput("cluster_version"))

		var op gjson.Result
		utils.Poll(t, func() (bool, error) {
			cmdOp, err := gcloud.RunCmdE(t, testCommand,
				gcloud.WithCommonArgs([]string{}),
			)
			if err != nil {
				t.Logf("Waiting for SSH connectivity via IAP: %v", err)
				return true, err
			}
			op = gjson.Parse(cmdOp)
			if !op.Get("gitVersion").Exists() {
				return true, fmt.Errorf("gitVersion not yet present in output")
			}
			return false, nil
		}, 20, 10*time.Second)

		assert.Equal(clusterVersion, op.Get("gitVersion").String(), "SSH into VM and verify connectivity to GKE")
	})

	bpt.Test()
}
