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
  # GCP service account ids must be <= 30 chars matching regex ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$
  service_account_name = trimsuffix(substr(var.metrics_gcp_sa_name, 0, 30), "-")

  iam_ksa_binding_members = var.create_metrics_gcp_sa ? [
    var.enable_config_sync ? "config-management-monitoring/default" : null,
    var.enable_policy_controller ? "gatekeeper-system/gatekeeper-admin" : null,
  ] : []
}

resource "tls_private_key" "k8sop_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Wait for the ACM operator to create the namespace
resource "time_sleep" "wait_acm" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null || var.enable_policy_controller || var.enable_config_sync) ? 1 : 0
  depends_on = [google_gke_hub_feature_membership.main]

  create_duration = "300s"
}

resource "google_service_account_iam_binding" "ksa_iam" {
  count              = length(local.iam_ksa_binding_members) > 0 ? 1 : 0
  service_account_id = google_service_account.acm_metrics_writer_sa[0].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    for ksa in local.iam_ksa_binding_members : "serviceAccount:${var.project_id}.svc.id.goog[${ksa}]"
  ]

  depends_on = [google_gke_hub_feature_membership.main]
}

module "annotate-sa-config-management-monitoring" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  count            = var.enable_config_sync && var.create_metrics_gcp_sa ? 1 : 0
  skip_download    = true
  cluster_name     = var.cluster_name
  cluster_location = var.location
  project_id       = var.project_id

  kubectl_create_command  = "kubectl annotate --overwrite sa -n config-management-monitoring default iam.gke.io/gcp-service-account=${google_service_account.acm_metrics_writer_sa[0].email}"
  kubectl_destroy_command = "kubectl annotate sa -n config-management-monitoring default iam.gke.io/gcp-service-account-"

  module_depends_on = time_sleep.wait_acm
}

module "annotate-sa-gatekeeper-system" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  count            = var.enable_policy_controller && var.create_metrics_gcp_sa ? 1 : 0
  skip_download    = true
  cluster_name     = var.cluster_name
  cluster_location = var.location
  project_id       = var.project_id

  kubectl_create_command  = "kubectl annotate --overwrite sa -n gatekeeper-system gatekeeper-admin iam.gke.io/gcp-service-account=${google_service_account.acm_metrics_writer_sa[0].email}"
  kubectl_destroy_command = "kubectl annotate sa -n gatekeeper-system gatekeeper-admin iam.gke.io/gcp-service-account-"

  module_depends_on = time_sleep.wait_acm
}

module "annotate-sa-gatekeeper-system-restart" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  count            = var.enable_policy_controller && var.create_metrics_gcp_sa ? 1 : 0
  skip_download    = true
  cluster_name     = var.cluster_name
  cluster_location = var.location
  project_id       = var.project_id

  kubectl_create_command  = "kubectl rollout restart deployment gatekeeper-controller-manager -n gatekeeper-system"
  kubectl_destroy_command = ""

  module_depends_on = module.annotate-sa-gatekeeper-system
}

resource "google_service_account" "acm_metrics_writer_sa" {
  count = var.create_metrics_gcp_sa ? 1 : 0

  display_name = "ACM Metrics Writer SA"
  account_id   = local.service_account_name
  project      = var.project_id
}

resource "google_project_iam_member" "acm_metrics_writer_sa_role" {
  count   = var.create_metrics_gcp_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.acm_metrics_writer_sa[0].email}"
}

resource "kubernetes_secret_v1" "creds" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null) ? 1 : 0
  depends_on = [time_sleep.wait_acm]

  metadata {
    name      = "git-creds"
    namespace = "config-management-system"
  }

  data = {
    (local.k8sop_creds_secret_key) = local.private_key
  }
}
