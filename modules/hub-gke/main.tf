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
  hub_project_id          = var.hub_project_id == "" ? var.project_id : var.hub_project_id
  gke_hub_membership_name = var.gke_hub_membership_name != "" ? var.gke_hub_membership_name : "${var.project_id}-${var.location}-${var.cluster_name}"
}

# Retrieve GKE cluster info
data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

data "google_client_config" "default" {
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

# Create the membership
resource "google_gke_hub_membership" "primary" {
  count    = var.enable_gke_hub_registration ? 1 : 0
  provider = google-beta

  project       = local.hub_project_id
  membership_id = local.gke_hub_membership_name

  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${data.google_container_cluster.primary.id}"
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${data.google_container_cluster.primary.id}"
  }

  depends_on = [
    var.module_depends_on
  ]
}
