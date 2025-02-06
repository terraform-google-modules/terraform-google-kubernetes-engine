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

provider "google" {
  region = var.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 36.0"

  project_id = var.project_id
  regional   = false
  region     = var.region
  zones      = [var.zone]

  name = "config-sync-cluster${var.cluster_name_suffix}"

  network           = google_compute_network.main.name
  subnetwork        = google_compute_subnetwork.main.name
  ip_range_pods     = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services = google_compute_subnetwork.main.secondary_ip_range[1].range_name

  service_account     = "create"
  deletion_protection = false
  node_pools = [
    {
      name         = "node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 4
      machine_type = "e2-standard-4"
    },
  ]
}
