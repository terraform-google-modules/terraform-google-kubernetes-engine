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
  cluster_type        = "shared-vpc"
  api_to_activate     = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com"]
  main_gke_subnet     = "${var.network}-subnet-01"
  pods_gke_subnet     = "${local.main_gke_subnet}-pods"
  services_gke_subnet = "${local.main_gke_subnet}-services"

  subnet_01_cidr      = "10.10.10.0/24"
  service_subnet_cidr = "10.2.0.0/16"
  pod_subnet_cidr     = "10.1.0.0/16"

}



provider "google" {
  version = "~> 2.0"
  project = var.project_id
}


// Create GKE network in shared host account
module "shared_host_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 1.4.0"

  project_id   = var.network_project_id
  network_name = var.network

  delete_default_internet_gateway_routes = false
  shared_vpc_host                        = true

  subnets = [
    {
      subnet_name           = local.main_gke_subnet
      subnet_ip             = local.subnet_01_cidr
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${local.main_gke_subnet}" = [
      {
        range_name    = local.pods_gke_subnet
        ip_cidr_range = local.pod_subnet_cidr
      },
      {
        range_name    = local.services_gke_subnet
        ip_cidr_range = local.service_subnet_cidr
      },
    ]
  }

}


module "gke_service_project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 4.0"
  random_project_id = true
  name              = var.project_id
  org_id            = var.organization_id
  billing_account   = var.billing_account
  shared_vpc        = module.shared_host_vpc.svpc_host_project_id
  activate_apis     = local.api_to_activate
}


module "gke" {
  source                 = "../../"
  project_id             = module.gke_service_project.project_id
  name                   = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                 = var.region
  network                = var.network
  network_project_id     = module.shared_host_vpc.svpc_host_project_id
  subnetwork             = local.main_gke_subnet
  ip_range_pods          = local.pods_gke_subnet
  ip_range_services      = local.services_gke_subnet
  create_service_account = false
  service_account        = "${module.gke_service_project.service_account_id}@${module.gke_service_project.project_id}.iam.gserviceaccount.com"
}

data "google_client_config" "default" {
}
