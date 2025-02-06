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
  cluster_type = "simple-regional-private"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 36.0"

  project_id                  = var.project_id
  name                        = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                    = true
  region                      = var.region
  network                     = var.network
  subnetwork                  = var.subnetwork
  ip_range_pods               = var.ip_range_pods
  ip_range_services           = var.ip_range_services
  create_service_account      = false
  service_account             = var.compute_engine_service_account
  enable_private_endpoint     = true
  enable_private_nodes        = true
  enable_secret_manager_addon = true
  default_max_pods_per_node   = 20
  remove_default_node_pool    = true
  deletion_protection         = false

  node_pools = [
    {
      name              = "pool-01"
      min_count         = 1
      max_count         = 100
      local_ssd_count   = 0
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      auto_repair       = true
      auto_upgrade      = true
      service_account   = var.compute_engine_service_account
      preemptible       = false
      max_pods_per_node = 12
    },
  ]

  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]
}
