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

locals {
  cluster_type = "simple-rgnl-cluster-autosc"
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

  project_id                = var.project_id
  name                      = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                  = true
  region                    = var.region
  network                   = var.network
  subnetwork                = var.subnetwork
  ip_range_pods             = var.ip_range_pods
  ip_range_services         = var.ip_range_services
  create_service_account    = false
  service_account           = var.compute_engine_service_account
  default_max_pods_per_node = 20
  remove_default_node_pool  = true
  deletion_protection       = false

  add_cluster_firewall_rules = true
  firewall_inbound_ports     = ["8443", "9443", "15017"]

  # Just an example
  network_tags = ["egress-internet"]

  cluster_autoscaling = {
    enabled             = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
    min_cpu_platform    = "Intel Skylake"
    min_cpu_cores       = 4
    max_cpu_cores       = 86
    min_memory_gb       = 16
    max_memory_gb       = 256
    disk_size           = 100
    disk_type           = "pd-standard"
    image_type          = "COS_CONTAINERD"
    gpu_resources       = []
    auto_repair         = true
    auto_upgrade        = true
    strategy            = "SURGE"
    max_surge           = 1
    max_unavailable     = 0
  }
}
