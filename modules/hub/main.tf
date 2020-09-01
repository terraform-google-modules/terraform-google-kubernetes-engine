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
  gke_hub_sa_key = google_service_account_key.gke_hub_key.private_key
}

data "google_client_config" "default" {
}

resource "google_service_account" "gke_hub_sa" {
  account_id   = var.gke_hub_sa_name
  project      = var.project_id
  display_name = "Service Account for GKE Hub Registration"
}

resource "google_project_iam_member" "gke_hub_member" {
  project = var.project_id
  role    = "roles/gkehub.connect"
  member  = "serviceAccount:${google_service_account.gke_hub_sa.email}"
}

resource "google_service_account_key" "gke_hub_key" {
  service_account_id = google_service_account.gke_hub_sa.name
}

module "gke_hub_registration" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 1.0"

  platform                          = "linux"
  gcloud_sdk_version                = var.gcloud_sdk_version
  skip_download                     = var.skip_gcloud_download
  upgrade                           = true
  use_tf_google_credentials_env_var = var.use_tf_google_credentials_env_var
  module_depends_on                 = [var.cluster_endpoint]

  create_cmd_entrypoint  = "${path.module}/scripts/gke_hub_registration.sh"
  create_cmd_body        = "${var.gke_hub_membership_name} ${var.location} ${var.cluster_name} ${local.gke_hub_sa_key} ${var.project_id}"
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "container hub memberships unregister ${var.gke_hub_membership_name} --gke-cluster=${var.location}/${var.cluster_name} --project ${var.project_id}"
}
