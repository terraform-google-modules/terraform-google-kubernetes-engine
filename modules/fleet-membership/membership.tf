/**
 * Copyright 2018-2024 Google LLC
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

# Create the membership
resource "google_gke_hub_membership" "primary" {
  count    = var.enable_fleet_registration ? 1 : 0
  provider = google-beta

  project       = local.hub_project_id
  membership_id = local.gke_hub_membership_name
  location      = var.membership_location

  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${data.google_container_cluster.primary.id}"
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${data.google_container_cluster.primary.id}"
  }
}
