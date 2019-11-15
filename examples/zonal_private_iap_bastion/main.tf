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

module "gke" {
  source                  = "../../modules/beta-private-cluster"
  enable_private_endpoint = "true"
  enable_private_nodes    = "true"
  master_ipv4_cidr_block  = "172.16.0.16/28"

  project_id         = var.project_id
  name               = var.cluster_name
  region             = var.region
  zones              = var.zones
  regional           = false
  kubernetes_version = "latest"

  network           = module.gke-network.network_name
  subnetwork        = module.gke-network.subnets_names[0]
  ip_range_pods     = "${module.gke-network.network_name}-${var.cluster_name}-pod-range"
  ip_range_services = "${module.gke-network.network_name}-${var.cluster_name}-service-range"

  http_load_balancing         = "true"
  network_policy              = "true"
  horizontal_pod_autoscaling  = "false"
  enable_binary_authorization = "true"

  service_account          = "create"
  remove_default_node_pool = "true"
  issue_client_certificate = "false"

  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = module.gke-network.subnets_ips[0],
          display_name = "internal subnet"
        }
      ]
    },
  ]

  disable_legacy_metadata_endpoints = "true"

  node_pools = [
    {
      name               = "my-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 2
      max_count          = 10
      disk_size_gb       = 50
      disk_type          = "pd-ssd"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = true
      initial_node_count = 1
    },
    {
      name               = "my-other-nodepool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 1
      disk_size_gb       = 50
      disk_type          = "pd-ssd"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    my-node-pool = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    my-other-nodepool = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  node_pools_labels = {

    all = {
      l1 = "v1"
      l2 = "v2"
    }

    my-node-pool = {
      seven = "eight"
    }

    my-other-nodepool = {
    }
  }

  node_pools_metadata = {
    all               = {}
    my-node-pool      = {}
    my-other-nodepool = {}
  }

  node_pools_tags = {
    all = [
      "blue",
      "green",
    ]

    my-node-pool = []

    my-other-nodepool = [
      "red",
      "white",
    ]

  }

  node_pools_taints = {
    all = []

    my-node-pool = []

    my-other-nodepool = []

  }
}
