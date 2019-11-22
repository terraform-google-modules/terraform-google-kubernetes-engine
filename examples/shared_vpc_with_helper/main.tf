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
  region  = var.region
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_project" "gke_shared_host_project" {
  name       = var.gke_shared_host_project
  project_id = "${var.gke_shared_host_project}-${random_string.suffix.result}"
  org_id     = var.org_id
  billing_account = var.billing_account
}

resource "google_project" "gke_service_project" {
  depends_on = ["google_project.gke_shared_host_project"]
  name       = var.gke_service_project
  project_id = "${var.gke_service_project}-${random_string.suffix.result}"
  org_id     = var.org_id
  billing_account = var.billing_account
}

/******************************************
	APIs enable
 *****************************************/

// enable api to created projects
resource "google_project_service" "gke_projects" {
  depends_on = [google_project.gke_service_project, google_project.gke_shared_host_project]
  count = 2
  project  = element([google_project.gke_shared_host_project.project_id, google_project.gke_service_project.project_id], count.index)
  service  = "compute.googleapis.com"
  disable_on_destroy = false
  disable_dependent_services = false
}

// share vpc

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  depends_on = [google_project_service.gke_projects]
  project = google_project.gke_shared_host_project.project_id
}

resource "google_compute_shared_vpc_service_project" "gke_service_project" {
  depends_on = [google_compute_shared_vpc_host_project.shared_vpc_host]
  host_project = google_project.gke_shared_host_project.project_id
  service_project = google_project.gke_service_project.project_id
}

// create service account
resource "google_service_account" "gke_service" {
  depends_on = [google_project.gke_service_project]
  account_id   = "gke-service-${random_string.suffix.result}"
  display_name = "gke-service"
  project = google_project.gke_service_project.project_id
}


//module "svpc_helper" {
//  enable_shared_vpc_helper = true
//  source = "../../modules/shared-vpc-helper"
//
//  gke_svpc_host_project = google_project.gke_shared_host_project.project_id
//  gke_svpc_service_project = google_project.gke_service_project.project_id
//
//  region = var.region
//  gke_subnetwork = google_compute_subnetwork.main.name
//  gke_sa = "serviceAccount:${google_service_account.gke_service.email}"
//
//}
//
//
//output "n1" {
//  value = google_compute_subnetwork.main.secondary_ip_range
//}
//
//output "n2" {
//  value = google_compute_subnetwork.main.name
//}

module "gke" {
  source                 = "../../"
  enable_shared_vpc_helper = true
  project_id             = google_project.gke_service_project.project_id
  name                   = "gke-cluster${random_string.suffix.result}"
  region                 = var.region
  network                = google_compute_network.main.name
  network_project_id     = google_project.gke_shared_host_project.project_id
  subnetwork             = google_compute_subnetwork.main.name
  ip_range_pods          = google_compute_subnetwork.main.secondary_ip_range[0]["range_name"]
  ip_range_services      = google_compute_subnetwork.main.secondary_ip_range[1]["range_name"]
  create_service_account = true
}