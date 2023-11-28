/**
 * Copyright 2022 Google LLC
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

resource "google_gke_hub_membership" "membership" {
  count         = var.enable_fleet_registration ? 1 : 0
  provider      = google-beta
  project       = local.fleet_id
  membership_id = "${data.google_container_cluster.asm.name}-membership"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${data.google_container_cluster.asm.id}"
    }
  }
}

resource "google_gke_hub_feature" "mesh" {
  count    = var.enable_mesh_feature ? 1 : 0
  name     = "servicemesh"
  project  = local.fleet_id
  location = "global"
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "mesh_feature_membership" {
  count = var.enable_fleet_registration && var.enable_mesh_feature && var.mesh_management != "" ? 1 : 0

  location   = "global"
  feature    = google_gke_hub_feature.mesh[0].name
  membership = google_gke_hub_membership.membership[0].membership_id
  mesh {
    management = var.mesh_management
  }
  provider = google-beta
}
