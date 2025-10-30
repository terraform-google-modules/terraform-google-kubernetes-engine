/**
 * Copyright 2025 Google LLC
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
  cluster_type           = "gke-autopilot"
  default_workload_pool  = "${var.project_id}.svc.id.goog"
  network_name           = "autopilot-network"
  subnet_name            = "autopilot-subnet"
  master_auth_subnetwork = "autopilot-master-subnet"
  pods_range_name        = "ip-range-pods-autopilot"
  svc_range_name         = "ip-range-svc-autopilot"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/gke-autopilot-cluster"
  version = "~> 41.0"

  project_id = var.project_id
  name       = "${local.cluster_type}-cluster"
  location   = var.region
  network    = module.gcp-network.network_self_link
  subnetwork = module.gcp-network.subnets_self_links[index(module.gcp-network.subnets_names, local.subnet_name)]

  ip_allocation_policy = {
    cluster_secondary_range_name  = local.pods_range_name
    services_secondary_range_name = local.svc_range_name
  }

  private_cluster_config = {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config = {
      enabled = true
    }
  }

  master_authorized_networks_config = {
    cidr_blocks = [{
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    }]
  }

  confidential_nodes = {
    enabled = true
  }

  workload_identity_config = {
    workload_pool = local.default_workload_pool
  }
}
