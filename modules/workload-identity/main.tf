/**
 * Copyright 2019 Google LLC
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
  k8s_sa_gcp_derived_name = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${local.output_k8s_name}]"
  gcp_sa_email            = google_service_account.cluster_service_account.email

  # This will cause terraform to block returning outputs until the service account is created
  k8s_given_name         = var.k8s_sa_name != null ? var.k8s_sa_name : var.name
  output_k8s_name        = var.use_existing_k8s_sa ? local.k8s_given_name : kubernetes_service_account.main[0].metadata[0].name
  output_k8s_namespace   = var.use_existing_k8s_sa ? var.namespace : kubernetes_service_account.main[0].metadata[0].namespace
  token                  = var.use_existing_k8s_sa ? data.google_client_config.default.0.access_token : ""
  cluster_ca_certificate = var.use_existing_k8s_sa ? data.google_container_cluster.primary.0.master_auth.0.cluster_ca_certificate : ""
  cluster_endpoint       = var.use_existing_k8s_sa ? "https://${data.google_container_cluster.primary.0.endpoint}" : ""
}

data "google_container_cluster" "primary" {
  count    = var.use_existing_k8s_sa ? 1 : 0
  name     = var.cluster_name
  project  = var.project_id
  location = var.location
}

data "google_client_config" "default" {
  count = var.use_existing_k8s_sa ? 1 : 0
}

resource "google_service_account" "cluster_service_account" {
  account_id   = var.name
  display_name = substr("GCP SA bound to K8S SA ${local.k8s_given_name}", 0, 100)
  project      = var.project_id
}

resource "kubernetes_service_account" "main" {
  count = var.use_existing_k8s_sa ? 0 : 1

  automount_service_account_token = var.automount_service_account_token
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.cluster_service_account.email
    }
  }
}

module "annotate-sa" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 0.5"

  platform              = "linux"
  additional_components = ["kubectl"]
  enabled               = var.use_existing_k8s_sa
  skip_download         = true

  create_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  create_cmd_body       = "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl annotate --overwrite sa -n ${local.output_k8s_namespace} ${local.k8s_given_name} iam.gke.io/gcp-service-account=${local.gcp_sa_email}"

  destroy_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  destroy_cmd_body       = "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl annotate sa -n ${local.output_k8s_namespace} ${local.k8s_given_name} iam.gke.io/gcp-service-account-"
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.cluster_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_sa_gcp_derived_name
}
