// Copyright 2022-2024 Google LLC
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
package deploy_service

import (
	"fmt"
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestDeployService(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		// bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		gcloud.Runf(t, "container clusters get-credentials %s --region %s --project %s", clusterName, location, projectId)
		k8sOpts := k8s.KubectlOptions{}

		var serviceIp string
		utils.Poll(t, func() (bool, error) {
			listServices, err := k8s.RunKubectlAndGetOutputE(t, &k8sOpts, "get", "svc", "terraform-example", "-o", "json")
			if err != nil {
				return true, err
			}
			kubeService := utils.ParseKubectlJSONResult(t, listServices)
			ip := kubeService.Get("status.loadBalancer.ingress.0.ip").String()
			if ip == "" {
				return true, fmt.Errorf("waiting for load balancer IP allocation")
			}
			serviceIp = ip
			return false, nil
		}, 30, 10*time.Second)

		serviceUrl := fmt.Sprintf("http://%s:8080", serviceIp)

		var responseData []byte
		pollHTTPEndPoint := func(cmd string) func() (bool, error) {
			return func() (bool, error) {
				resp, err := http.Get(cmd)
				if err != nil {
					t.Logf("%s", err)
					return true, err
				}
				defer resp.Body.Close()
				if resp.StatusCode != http.StatusOK {
					return true, fmt.Errorf("expected status 200, got %d", resp.StatusCode)
				}
				body, err := io.ReadAll(resp.Body)
				if err != nil {
					return true, err
				}
				if !strings.Contains(string(body), "Thank you for using nginx.") {
					return true, fmt.Errorf("response body does not yet contain expected content")
				}
				responseData = body
				return false, nil
			}
		}

		utils.Poll(t, pollHTTPEndPoint(serviceUrl), 20, 10*time.Second)
		assert.Contains(string(responseData), "Thank you for using nginx.", "Service is Functional")
	})

	bpt.Test()
}
