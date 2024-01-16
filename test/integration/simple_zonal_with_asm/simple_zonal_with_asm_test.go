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
package simple_zonal_with_asm

import (
	"fmt"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-kubernetes-engine/test/integration/testutils"
)

func TestSimpleZonalWithASM(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(testutils.RetryableTransientErrors, 3, 2*time.Minute),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		//Skipping Default Verify as the Verify Stage fails due to change in Client Cert Token
		// bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		projectNumber := bpt.GetStringOutput("project_number")
		location := bpt.GetStringOutput("location")
		clusterName := bpt.GetStringOutput("cluster_name")

		op := gcloud.Runf(t, "container clusters describe %s --zone %s --project %s", clusterName, location, projectId)
		assert.Contains(op.Get("resourceLabels.mesh_id").String(), fmt.Sprintf("proj-%s", projectNumber), "Mesh ID's exists")

		op1 := gcloud.Runf(t, "container hub memberships describe %s-membership --project %s ", clusterName, projectId)
		assert.Contains(op1.Get("endpoint.gkeCluster.resourceLink").String(), fmt.Sprintf("//container.googleapis.com/projects/%s/locations/%s/clusters/%s", projectId, location, clusterName), "Custom Terraform Created")

		gcloud.Runf(t, "container clusters get-credentials %s --region %s --project %s", clusterName, location, projectId)
		k8sOpts := k8s.KubectlOptions{}
		listNameSpace, err := k8s.RunKubectlAndGetOutputE(t, &k8sOpts, "get", "ns", "istio-system", "-o", "json")
		assert.NoError(err)
		kubeNS := utils.ParseJSONResult(t, listNameSpace)
		assert.Contains(kubeNS.Get("metadata.name").String(), "istio-system", "Namespace is Functional")
		listConfigMap, err := k8s.RunKubectlAndGetOutputE(t, &k8sOpts, "get", "configmap", "asm-options", "-n", "istio-system", "-o", "json")
		assert.NoError(err)
		kubeCM := utils.ParseJSONResult(t, listConfigMap)
		assert.Contains(kubeCM.Get("metadata.name").String(), "asm-options", "Configmap is Present")

	})

	bpt.Test()
}
