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

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  cluster_type           = "safer-cluster"
  network_name           = "safer-cluster-network-${random_string.suffix.result}"
  subnet_name            = "safer-cluster-subnet"
  master_auth_subnetwork = "safer-cluster-master-subnet"
  pods_range_name        = "ip-range-pods-${random_string.suffix.result}"
  svc_range_name         = "ip-range-svc-${random_string.suffix.result}"
}

provider "google" {
  version = "~> 3.16.0"
}

provider "google-beta" {
  version = "~> 3.23.0"
}

module "gke" {
  source                         = "../../modules/safer-cluster/"
  project_id                     = var.project_id
  name                           = "${local.cluster_type}-cluster-${random_string.suffix.result}"
  regional                       = true
  region                         = var.region
  network                        = module.gcp-network.network_name
  subnetwork                     = module.gcp-network.subnets_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                  = local.pods_range_name
  ip_range_services              = local.svc_range_name
  compute_engine_service_account = var.compute_engine_service_account
  master_ipv4_cidr_block         = "172.16.0.0/28"
  add_cluster_firewall_rules     = true
  firewall_inbound_ports         = ["9443", "15017"]

  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]

  istio    = true
  cloudrun = true
}

data "google_client_config" "default" {
}

