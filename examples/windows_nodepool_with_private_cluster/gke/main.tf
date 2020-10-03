
/**
 * Copyright 2020 Google LLC
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

module "gke_private_cluster" {
  source                     = "../modules/google_kubernetes_engine/gke_private_cluster/"
  project_id                 = var.project
  name                       = "test-gke-cluster"
  region                     = var.region
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = "pod-range"     #Note:pod-range is name of additional range in subnet. e.g : 10.2.0.0/16 or 10.2.4.0/21 (select wider range for pods as autoscalling will have large ip Requirements)
  ip_range_services          = "service-range" #e.g : 10.2.4.0/24 
  regional                   = var.regional
  zones                      = var.zones
  http_load_balancing        = true
  network_policy             = true
  horizontal_pod_autoscaling = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  remove_default_node_pool   = true
  create_service_account     = false
  service_account            = var.service_account
  kubernetes_version         = var.gke_cluster_master_version
  master_authorized_networks = var.master_authorized_networks
  cluster_resource_labels    = var.gce_labels
}

#Linux Nodepool 
module "gke_node_pool_01" {
  source                         = "../modules/google_kubernetes_engine/gke_node_pool/"
  project_id                     = var.project
  gke_cluster_name               = module.gke_private_cluster.name
  node_pool_name                 = "default-node-pool"
  region                         = var.region
  regional                       = var.regional
  zones                          = module.gke_private_cluster.zones
  gke_cluster_min_master_version = var.gke_cluster_min_master_version
  image_type                     = "COS"
  machine_type                   = var.node_pool_01["machine_type"]
  preemptible                    = false
  auto_upgrade                   = false
  auto_repair                    = true
  max_pods_per_node              = "100"
  node_count                     = "1"
  local_ssd_count                = "0"
  enable_autoscaling             = true
  min_node_count                 = var.node_pool_01["min_node_count"]
  max_node_count                 = var.node_pool_01["max_node_count"]
  labels                         = var.node_pool_01["kubernetes_labels"]
  disk_size_gb                   = var.node_pool_01["disk_size_gb"]
  disk_type                      = var.node_pool_01["disk_type"]
  service_account                = var.service_account
}

#Windows Nodepool 
module "gke_node_pool_02" {
  source                         = "../modules/google_kubernetes_engine/gke_node_pool/"
  project_id                     = var.project
  gke_cluster_name               = module.gke_private_cluster.name
  node_pool_name                 = "windows-node-pool"
  region                         = var.region
  regional                       = var.regional
  zones                          = module.gke_private_cluster.zones
  gke_cluster_min_master_version = var.gke_cluster_min_master_version
  image_type                     = "WINDOWS_LTSC"
  machine_type                   = var.node_pool_02["machine_type"]
  preemptible                    = false
  auto_upgrade                   = false
  auto_repair                    = true
  max_pods_per_node              = "100"
  node_count                     = "1"
  local_ssd_count                = "0"
  enable_autoscaling             = true
  min_node_count                 = var.node_pool_02["min_node_count"]
  max_node_count                 = var.node_pool_02["max_node_count"]
  labels                         = var.node_pool_02["kubernetes_labels"]
  disk_size_gb                   = var.node_pool_02["disk_size_gb"]
  disk_type                      = var.node_pool_02["disk_type"]
  service_account                = var.service_account
}
