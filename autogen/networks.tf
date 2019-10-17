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

{{ autogeneration_note }}

data "google_compute_network" "gke_network" {
  {% if beta_cluster %}
  provider = google-beta
  {% else %}
  provider = google
  {% endif %}

  name    = var.network
  project = local.network_project_id
}

data "google_compute_subnetwork" "gke_subnetwork" {
  {% if beta_cluster %}
  provider = google-beta
  {% else %}
  provider = google
  {% endif %}

  name    = var.subnetwork
  region  = local.region
  project = local.network_project_id
}
