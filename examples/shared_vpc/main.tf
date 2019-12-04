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
  version = "~> 2.18.0"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

/************************************************
	Networking in shared VPC to host cluster in
 ***********************************************/

locals {
  gke_svpc_subnet     = "gke-svpc-main-${random_string.suffix.result}"
  pods_gke_subnet     = "${local.gke_svpc_subnet}-pods"
  services_gke_subnet = "${local.gke_svpc_subnet}-services"
}

// Inputs for Shared VPC aren't provided in reason it handled by VPC helper submodule
module "gke_cluster_svpc_network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 1.5.0"
  project_id   = var.svpc_host_project_id
  network_name = "gke-svpc-network"

  subnets = [
    {
      subnet_name   = local.gke_svpc_subnet
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${local.gke_svpc_subnet}" = [
      {
        range_name    = local.pods_gke_subnet
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.services_gke_subnet
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

/******************************************
	Main module with shared_vpc_helper
 *****************************************/

module "gke" {
  source                   = "../../"
  enable_shared_vpc_helper = true
  project_id               = var.svpc_service_project_id
  name                     = "gke-svpc-cluster-${random_string.suffix.result}"
  region                   = var.region
  network                  = module.gke_cluster_svpc_network.network_name
  network_project_id       = var.svpc_host_project_id
  subnetwork               = module.gke_cluster_svpc_network.subnets_names[0]
  ip_range_pods            = local.pods_gke_subnet
  ip_range_services        = local.services_gke_subnet
  create_service_account   = true
}

data "google_client_config" "default" {
  depends_on = [module.gke]
}

data "google_project" "svpc_host_project" {
  project_id = var.svpc_host_project_id
}

data "google_project" "svpc_service_project" {
  project_id = var.svpc_service_project_id
}
