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
  cluster_type = "simple-zonal-asm"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_project" "project" {
  project_id = var.project_id
}

module "gke" {
  source                  = "../../"
  project_id              = var.project_id
  name                    = "test-prefix-cluster-test-suffix"
  regional                = false
  region                  = var.region
  zones                   = var.zones
  release_channel         = "REGULAR"
  network                 = google_compute_network.main.name
  subnetwork              = google_compute_subnetwork.main.name
  ip_range_pods           = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services       = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  network_policy          = false
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
  identity_namespace      = "${var.project_id}.svc.id.goog"
  node_pools = [
    {
      name         = "asm-node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 3
      machine_type = "e2-standard-4"
    },
  ]
}

module "asm" {
  source                    = "../../modules/asm"
  project_id                = var.project_id
  cluster_name              = module.gke.name
  cluster_location          = module.gke.location
  multicluster_mode         = "connected"
  enable_cni                = true
  enable_fleet_registration = true
  enable_mesh_feature       = true
}
