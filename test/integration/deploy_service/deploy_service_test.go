// Copyright 2022 Google LLC
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
	"io/ioutil"
	"net/http"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
)

func TestDeployService(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		// bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")
		gcloud.Runf(t, "container clusters get-credentials %s --region %s --project %s", clusterName, location, projectId)
		k8sOpts := k8s.KubectlOptions{}
		listServices, err := k8s.RunKubectlAndGetOutputE(t, &k8sOpts, "get", "svc", "terraform-example", "-o", "json")
		assert.NoError(err)
		kubeService := utils.ParseJSONResult(t, listServices)
		serviceIp := kubeService.Get("status.loadBalancer.ingress").Array()[0].Get("ip")
		serviceUrl := fmt.Sprintf("http://%s:8080", serviceIp)

		pollHTTPEndPoint := func(cmd string) func() (bool, error) {
			return func() (bool, error) {
				build, err := http.Get(cmd)
				if build.StatusCode == 200 {
					assert.NoError(err)
					return false, nil
				}
				return true, nil
			}
		}

		utils.Poll(t, pollHTTPEndPoint(serviceUrl), 20, 10*time.Second)
		response, err := http.Get(serviceUrl)
		assert.NoError(err)
		responseData, err := ioutil.ReadAll(response.Body)
		assert.NoError(err)
		assert.Contains(string(responseData), "Thank you for using nginx.", "Service is Functional")
	})

	bpt.Test()
}
