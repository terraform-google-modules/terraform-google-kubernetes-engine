/**
 * Copyright 2022 Google LLC
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
  cluster_type           = "simple-ap-private-non-default-sa"
  network_name           = "${local.cluster_type}-network"
  subnet_name            = "${local.cluster_type}-subnet"
  master_auth_subnetwork = "${local.cluster_type}-master-subnet"
  pods_range_name        = "ip-range-pods-${local.cluster_type}"
  svc_range_name         = "ip-range-svc-${local.cluster_type}"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                          = "../../modules/beta-autopilot-private-cluster/"
  project_id                      = var.project_id
  name                            = "${local.cluster_type}-cluster"
  regional                        = true
  region                          = "us-central1"
  network                         = module.gcp-network.network_name
  subnetwork                      = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                   = local.pods_range_name
  ip_range_services               = local.svc_range_name
  release_channel                 = "REGULAR"
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = true
  enable_private_nodes            = true
  master_ipv4_cidr_block          = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]
}
