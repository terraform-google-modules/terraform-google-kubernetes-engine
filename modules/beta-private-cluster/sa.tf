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

// This file was automatically generated from a template in ./autogen

locals {
  service_account_list = compact(
    concat(
      google_service_account.cluster_service_account.*.email,
      ["dummy"],
    ),
  )
  service_account = var.service_account == "create" ? element(local.service_account_list, 0) : var.service_account
}

resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  count        = var.service_account == "create" ? 1 : 0
  project      = var.project_id
  account_id   = "tf-gke-${substr(var.name, 0, min(15, length(var.name)))}-${random_string.cluster_service_account_suffix.result}"
  display_name = "Terraform-managed service account for cluster ${var.name}"
}

resource "google_project_iam_member" "cluster_service_account-log_writer" {
  count   = var.service_account == "create" ? 1 : 0
  project = google_service_account.cluster_service_account[0].project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-metric_writer" {
  count   = var.service_account == "create" ? 1 : 0
  project = google_project_iam_member.cluster_service_account-log_writer[0].project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-monitoring_viewer" {
  count   = var.service_account == "create" ? 1 : 0
  project = google_project_iam_member.cluster_service_account-metric_writer[0].project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}
