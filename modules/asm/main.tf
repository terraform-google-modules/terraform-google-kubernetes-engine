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

module "asm_install" {
  source            = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version           = "~> 1.4"
  module_depends_on = [var.cluster_endpoint]

  gcloud_sdk_version    = var.gcloud_sdk_version
  skip_download         = var.skip_gcloud_download
  upgrade               = true
  additional_components = ["kubectl", "kpt", "beta", "kustomize"]
  cluster_name          = var.cluster_name
  cluster_location      = var.location
  project_id            = var.project_id


  kubectl_create_command  = "${path.module}/scripts/install_asm.sh ${var.project_id} ${var.cluster_name} ${var.location} ${var.asm_dir} ${var.asm_version}"
  kubectl_destroy_command = "kubectl delete ns istio-system"
}

module "gke_hub_registration" {
  source = "../hub"

  project_id                  = var.project_id
  cluster_name                = var.cluster_name
  cluster_endpoint            = var.cluster_endpoint
  location                    = var.location
  skip_gcloud_download        = var.skip_gcloud_download
  gcloud_sdk_version          = var.gcloud_sdk_version
  enable_gke_hub_registration = var.enable_gke_hub_registration
  gke_hub_sa_name             = var.gke_hub_sa_name
  gke_hub_membership_name     = var.gke_hub_membership_name

}
