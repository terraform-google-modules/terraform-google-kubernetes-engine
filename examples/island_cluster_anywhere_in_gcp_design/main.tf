/**
 * Copyright 2024 Google LLC
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

resource "random_id" "rand" {
  byte_length = 4
}

resource "google_service_account" "gke-sa" {
  for_each = { for k, v in var.gke_spokes : k => v }

  account_id = "gke-sa-${random_id.rand.hex}"
  project    = each.value["project_id"]
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "~> 36.0"

  for_each = { for k, v in var.gke_spokes : k => v }

  name                                 = each.value["cluster_name"]
  project_id                           = each.value["project_id"]
  region                               = var.region
  release_channel                      = "RAPID"
  zones                                = var.node_locations
  network                              = module.net[each.key].network_name
  subnetwork                           = "${each.value["cluster_name"]}-${var.region}-snet"
  ip_range_pods                        = "${each.value["cluster_name"]}-${var.region}-snet-pods"
  ip_range_services                    = "${each.value["cluster_name"]}-${var.region}-snet-services"
  enable_private_endpoint              = true
  enable_private_nodes                 = true
  datapath_provider                    = "ADVANCED_DATAPATH"
  monitoring_enable_managed_prometheus = false
  enable_shielded_nodes                = true
  master_global_access_enabled         = false
  master_ipv4_cidr_block               = var.secondary_ranges["master_cidr"]
  master_authorized_networks           = var.master_authorized_networks
  deletion_protection                  = false
  remove_default_node_pool             = true
  disable_default_snat                 = true
  gateway_api_channel                  = "CHANNEL_STANDARD"

  node_pools = [
    {
      name                      = "default"
      machine_type              = "e2-highcpu-2"
      min_count                 = 1
      max_count                 = 100
      local_ssd_count           = 0
      spot                      = true
      local_ssd_ephemeral_count = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = google_service_account.gke-sa[each.key].email
      initial_node_count        = 1
      enable_secure_boot        = true
    },
  ]

  node_pools_tags = {
    all = ["gke-${random_id.rand.hex}"]
  }

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  timeouts = {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
