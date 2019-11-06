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
  k8s_sa_gcp_derived_name = "serviceAccount:${var.project}.svc.id.goog[${var.namespace}/${var.name}]"
  gcp_sa_email            = "${var.name}@${var.project}.iam.gserviceaccount.com"
  create_k8s_sa           = var.use_existing_k8s_sa ? 0 : 1

  # This will cause terraform to block returninig outputs until the service account is created
  output_k8s_name      = var.use_existing_k8s_sa ? var.name : kubernetes_service_account.main[0].metadata[0].name
  output_k8s_namespace = var.use_existing_k8s_sa ? var.namespace : kubernetes_service_account.main[0].metadata[0].namespace
}

resource "kubernetes_service_account" "main" {
  count = local.create_k8s_sa
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = local.gcp_sa_email
    }
  }
}

resource "google_service_account" "main" {
  account_id   = var.name
  display_name = substr("GCP SA bound to K8S SA ${local.k8s_sa_gcp_derived_name}", 0, 100)
  project      = var.project
}

resource "google_service_account_iam_binding" "main" {
  service_account_id = "${google_service_account.main.name}"
  role               = "roles/iam.workloadIdentityUser"

  members = [local.k8s_sa_gcp_derived_name]
}
