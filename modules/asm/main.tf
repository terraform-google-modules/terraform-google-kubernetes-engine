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

locals {
  gke_hub_sa_key = var.enable_gke_hub_registration ? google_service_account_key.gke_hub_key[0].private_key : ""
}

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

resource "google_service_account" "gke_hub_sa" {
  count        = var.enable_gke_hub_registration ? 1 : 0
  account_id   = var.gke_hub_sa_name
  project      = var.project_id
  display_name = "Service Account for GKE Hub Registration"
}

resource "google_project_iam_member" "gke_hub_member" {
  count   = var.enable_gke_hub_registration ? 1 : 0
  project = var.project_id
  role    = "roles/gkehub.connect"
  member  = "serviceAccount:${google_service_account.gke_hub_sa[0].email}"
}

resource "google_service_account_key" "gke_hub_key" {
  count              = var.enable_gke_hub_registration ? 1 : 0
  service_account_id = google_service_account.gke_hub_sa[0].name
}

module "gke_hub_registration" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 1.2"

  platform           = "linux"
  gcloud_sdk_version = var.gcloud_sdk_version
  skip_download      = var.skip_gcloud_download
  upgrade            = true
  enabled            = var.enable_gke_hub_registration
  module_depends_on  = [module.asm_install.wait]

  create_cmd_entrypoint  = "${path.module}/scripts/gke_hub_registration.sh"
  create_cmd_body        = "${var.gke_hub_membership_name} ${var.location} ${var.cluster_name} ${local.gke_hub_sa_key}"
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "container hub memberships unregister ${var.gke_hub_membership_name} --gke-cluster=${var.location}/${var.cluster_name} --project ${var.project_id}"
}
