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

  iam_ksa_binding_members = var.create_metrics_gcp_sa ? concat(
    var.enable_config_sync ? ["config-management-monitoring/default"] : [],
    var.enable_policy_controller ? ["gatekeeper-system/gatekeeper-admin"] : [],
  ) : []
}

resource "tls_private_key" "k8sop_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Wait for ACM
resource "time_sleep" "wait_acm" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null || var.enable_policy_controller || var.enable_config_sync) ? 1 : 0
  depends_on = [google_gke_hub_feature_membership.main]

  create_duration = (length(var.policy_bundles) > 0) ? "600s" : "300s"
}

resource "google_service_account_iam_binding" "ksa_iam" {
  count      = length(local.iam_ksa_binding_members) > 0 ? 1 : 0
  depends_on = [google_gke_hub_feature_membership.main]

  service_account_id = google_service_account.acm_metrics_writer_sa[0].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    for ksa in local.iam_ksa_binding_members : "serviceAccount:${var.project_id}.svc.id.goog[${ksa}]"
  ]
}

resource "kubernetes_annotations" "annotate-sa-config-management-monitoring" {
  count = var.enable_config_sync && var.create_metrics_gcp_sa ? 1 : 0

  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "default"
    namespace = "config-management-monitoring"
  }

  annotations = {
    "iam.gke.io/gcp-service-account" : google_service_account.acm_metrics_writer_sa[0].email
  }

  depends_on = [time_sleep.wait_acm]
}

resource "kubernetes_annotations" "annotate-sa-gatekeeper-system" {
  count      = var.enable_policy_controller && var.create_metrics_gcp_sa ? 1 : 0
  depends_on = [time_sleep.wait_acm]

  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "gatekeeper-admin"
    namespace = "gatekeeper-system"
  }

  annotations = {
    "iam.gke.io/gcp-service-account" : google_service_account.acm_metrics_writer_sa[0].email
  }
}

resource "time_static" "restarted_at" {}
resource "kubernetes_annotations" "annotate-sa-gatekeeper-system-restart" {
  count = var.enable_policy_controller && var.create_metrics_gcp_sa ? 1 : 0

  api_version = "apps/v1"
  kind        = "Deployment"
  metadata {
    name      = "gatekeeper-controller-manager"
    namespace = "gatekeeper-system"
  }
  template_annotations = {
    "kubectl.kubernetes.io/restartedAt" = time_static.restarted_at.rfc3339
  }

  depends_on = [kubernetes_annotations.annotate-sa-gatekeeper-system]
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
