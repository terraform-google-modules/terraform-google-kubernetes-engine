/**
 * Copyright 2018-2023 Google LLC
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
  hub_project_id                   = var.hub_project_id == "" ? var.project_id : var.hub_project_id
  gke_hub_membership_name_complete = var.membership_name != "" ? var.membership_name : "${var.project_id}-${var.location}-${var.cluster_name}"
  gke_hub_membership_name          = trimsuffix(substr(local.gke_hub_membership_name_complete, 0, 63), "-")
  gke_hub_membership_location      = try(regex(local.gke_hub_membership_location_re, data.google_container_cluster.primary.fleet[0].membership)[0], null)
  gke_hub_membership_location_re   = "//gkehub.googleapis.com/projects/[^/]*/locations/([^/]*)/memberships/[^/]*$"
}

# Retrieve GKE cluster info
data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

# Give the service agent permissions on hub project
resource "google_project_iam_member" "hub_service_agent_gke" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = var.hub_project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_iam_member" "hub_service_agent_hub" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = local.hub_project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_service_identity" "sa_gkehub" {
  count    = var.hub_project_id == "" ? 0 : 1
  provider = google-beta
  project  = local.hub_project_id
  service  = "gkehub.googleapis.com"
}
