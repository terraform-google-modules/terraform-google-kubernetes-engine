/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  required_providers {
    kind = {
      source  = "kyma-incubator/kind"
      version = "0.0.6"
    }
  }
}
provider "kind" {}

# creating a cluster with kind of the name "test-cluster" with kubernetes version v1.18.4 and two nodes
resource "kind_cluster" "test-cluster" {
  name           = "test-cluster"
  node_image     = "kindest/node:v1.18.4"
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
  }
  provisioner "local-exec" {
    command = "kubectl config set-context kind-test-cluster"
  }
}
