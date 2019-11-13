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
  cluster_type = "safer-cluster"
}

provider "google-beta" {
  version = "~> 2.18.0"
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

module "gke" {
  source                         = "../../modules/safer-cluster/"
  project_id                     = var.project_id
  name                           = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                       = true
  region                         = var.region
  network                        = module.gcp-network.network_name
  subnetwork                     = module.gcp-network.subnets_names[0]
  ip_range_pods                  = var.ip_range_pods
  ip_range_services              = var.ip_range_services
  compute_engine_service_account = var.compute_engine_service_account
  master_ipv4_cidr_block         = var.master_ipv4_cidr_block
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = var.master_auth_subnetwork_cidr
          display_name = "VPC"
        },
      ]
    },
  ]
  istio    = var.istio
  cloudrun = var.cloudrun
}

data "google_client_config" "default" {
}

