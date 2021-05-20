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
  gke_hub_sa_key = var.use_existing_sa ? var.sa_private_key : google_service_account_key.gke_hub_key[0].private_key

  is_gke_flag = var.use_kubeconfig ? 0 : 1
  hub_project = var.hub_project_id == "" ? var.project_id : var.hub_project_id

  cluster_uri               = "https://container.googleapis.com/projects/${var.project_id}/locations/${var.location}/clusters/${var.cluster_name}"
  create_cmd_gke_entrypoint = "${path.module}/scripts/gke_hub_registration.sh"
  create_cmd_gke_body       = "${local.is_gke_flag} ${var.gke_hub_membership_name} ${local.gke_hub_sa_key} ${local.cluster_uri} ${local.hub_project} ${var.labels}"
  destroy_gke_entrypoint    = "${path.module}/scripts/gke_hub_unregister.sh"
  destroy_gke_body          = "${local.is_gke_flag} ${var.gke_hub_membership_name} ${local.cluster_uri} ${local.hub_project}"
}

data "google_client_config" "default" {
}

resource "google_service_account" "gke_hub_sa" {
  count        = var.use_existing_sa ? 0 : 1
  account_id   = var.gke_hub_sa_name
  project      = local.hub_project
  display_name = "Service Account for GKE Hub Registration"
}

resource "google_project_iam_member" "gke_hub_member" {
  count   = var.use_existing_sa ? 0 : 1
  project = local.hub_project
  role    = "roles/gkehub.connect"
  member  = "serviceAccount:${google_service_account.gke_hub_sa[0].email}"
}

resource "google_project_iam_member" "hub_service_agent_gke" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = var.project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_iam_member" "hub_service_agent_hub" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = local.hub_project
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_service_identity" "sa_gkehub" {
  count    = var.hub_project_id == "" ? 0 : 1
  provider = google-beta
  project  = local.hub_project
  service  = "gkehub.googleapis.com"
}

resource "google_service_account_key" "gke_hub_key" {
  count              = var.use_existing_sa ? 0 : 1
  service_account_id = google_service_account.gke_hub_sa[0].name
}

module "gke_hub_registration" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 2.1.0"

  platform                          = "linux"
  gcloud_sdk_version                = var.gcloud_sdk_version
  upgrade                           = true
  use_tf_google_credentials_env_var = var.use_tf_google_credentials_env_var
  module_depends_on                 = concat([var.cluster_endpoint], var.module_depends_on)

  create_cmd_entrypoint  = local.create_cmd_gke_entrypoint
  create_cmd_body        = local.create_cmd_gke_body
  destroy_cmd_entrypoint = local.destroy_gke_entrypoint
  destroy_cmd_body       = local.destroy_gke_body
}
