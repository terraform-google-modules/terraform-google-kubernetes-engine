/**
 * Copyright 2019 Google LLC
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
  projects               = [var.gke_svpc_host_project, var.gke_svpc_service_project]
  service_project_number = element(coalescelist(data.google_project.service_project[*].number, ["null"]), 0)

  gke_s_account           = "serviceAccount:service-${local.service_project_number}@container-engine-robot.iam.gserviceaccount.com"
  gke_default_s_account   = "serviceAccount:${local.service_project_number}@cloudservices.gserviceaccount.com"
  shared_vpc_users_length = 3
  shared_vpc_users        = [local.gke_s_account, local.gke_default_s_account, var.gke_sa]
}

/******************************************
	Container API enable
 *****************************************/

module "gke_svpc_host_api" {
  source      = "terraform-google-modules/project-factory/google//modules/project_services"
  version     = "4.0.0"
  enable_apis = var.enable_shared_vpc_helper
  project_id  = var.gke_svpc_host_project

  activate_apis = [
    "container.googleapis.com"
  ]
}

module "gke_svpc_service_api" {
  source      = "terraform-google-modules/project-factory/google//modules/project_services"
  version     = "4.0.0"
  enable_apis = var.enable_shared_vpc_helper
  project_id  = var.gke_svpc_service_project

  activate_apis = [
    "container.googleapis.com"
  ]
}


data "google_project" "service_project" {
  count      = var.enable_shared_vpc_helper ? 1 : 0
  project_id = var.gke_svpc_service_project
}


/******************************************************************************************************************
  compute.networkUser role granted to all Service accounts on shared VPC
 *****************************************************************************************************************/

resource "google_project_iam_member" "svpc_membership" {
  count = var.enable_shared_vpc_helper ? local.shared_vpc_users_length : 0

  project = var.gke_svpc_host_project
  role    = "roles/compute.networkUser"
  member  = element(local.shared_vpc_users, count.index)

  depends_on = [
    module.gke_svpc_host_api,
    module.gke_svpc_service_api
  ]

}

/******************************************
  compute.networkUser role granted to service accounts for GKE on shared VPC subnets
 *****************************************/

resource "google_compute_subnetwork_iam_member" "gke_shared_vpc_subnets" {
  count      = var.enable_shared_vpc_helper ? local.shared_vpc_users_length : 0
  subnetwork = var.gke_subnetwork
  role       = "roles/compute.networkUser"
  region     = var.region
  project    = var.gke_svpc_host_project
  member     = element(local.shared_vpc_users, count.index)

  depends_on = [
    module.gke_svpc_host_api,
    module.gke_svpc_service_api
  ]
}

/******************************************
  container.hostServiceAgentUser role granted to GKE service account for GKE on shared VPC
 *****************************************/

resource "google_project_iam_member" "gke_host_agent" {
  count   = var.enable_shared_vpc_helper ? 1 : 0
  project = var.gke_svpc_host_project
  role    = "roles/container.hostServiceAgentUser"
  member  = local.gke_s_account
  depends_on = [
    module.gke_svpc_host_api,
    module.gke_svpc_service_api
  ]
}
