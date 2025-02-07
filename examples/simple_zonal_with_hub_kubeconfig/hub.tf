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

module "hub" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/hub-legacy"
  version = "~> 36.0"

  project_id              = var.project_id
  location                = "remote"
  cluster_name            = kind_cluster.test-cluster.name
  cluster_endpoint        = kind_cluster.test-cluster.endpoint
  gke_hub_membership_name = kind_cluster.test-cluster.name
  gke_hub_sa_name         = "sa-for-kind-cluster-membership"
  use_kubeconfig          = true
  labels                  = "testlabel=usekubecontext"
}
