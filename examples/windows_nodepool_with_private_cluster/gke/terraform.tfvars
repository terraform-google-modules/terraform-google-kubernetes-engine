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

# Global
project = "project-id"
region  = "asia-south1"
zones   = ["asia-south1-a"]

# Network
network = "test-vpc"
# Node Subnet
subnetwork = "gke-subnet"

# cluster configurations
gke_cluster_master_version     = "1.16.13-gke.1"
gke_cluster_min_master_version = "1.16.13-gke.1"

#master node ip range
master_ipv4_cidr_block = "10.x.x.x/28"

#master_authorized_networks = [
#  {
#   cidr_block="10.16.0.0/28",
#  display_name="allow internal network"
#      }
#  ]

# a regional or a zonal cluster
regional = "true"
gce_labels = {
  project = "test",
  group   = "gke-apps",
  env     = "test"
}
service_account = "service account email"

# node pool configuration for Linux node pool 
node_pool_01 = {
  machine_type   = "n1-standard-2",
  min_node_count = 1,
  max_node_count = 5,
  disk_size_gb   = 100,
  disk_type      = "pd-standard",
  kubernetes_labels = {
    project = "test",
    env     = "test"
  }
}

# node pool configuration for windows node pool 
node_pool_02 = {
  machine_type   = "n1-standard-2",
  min_node_count = 1,
  max_node_count = 5,
  disk_size_gb   = 100,
  disk_type      = "pd-standard",
  kubernetes_labels = {
    project = "test",
    env     = "test"
  }
}

