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

provider "google" {
  version = "~> 3.42.0"
  region  = var.region
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
  source = "../../modules/private-cluster"

  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services
  name              = "stub-domains-private-cluster${var.cluster_name_suffix}"
  network           = var.network
  project_id        = var.project_id
  region            = var.region
  subnetwork        = var.subnetwork

  deploy_using_private_endpoint = true
  enable_private_endpoint       = false
  enable_private_nodes          = true

  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]

  master_ipv4_cidr_block = "172.16.0.0/28"

  create_service_account = false
  service_account        = var.compute_engine_service_account

  stub_domains = {
    "example.com" = [
      "10.254.154.11",
      "10.254.154.12",
    ]
    "example.net" = [
      "10.254.154.11",
      "10.254.154.12",
    ]
  }
}
