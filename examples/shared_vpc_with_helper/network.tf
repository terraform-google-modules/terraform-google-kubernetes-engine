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



resource "google_compute_network" "main" {
  depends_on = [google_project_service.gke_projects]
  name                    = "cft-gke-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
  project = google_project.gke_shared_host_project.project_id
}

resource "google_compute_subnetwork" "main" {
  depends_on = [google_compute_network.main]
  name          = "cft-gke-test-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/17"
  network       = google_compute_network.main.self_link
  project = google_project.gke_shared_host_project.project_id

  secondary_ip_range {
    range_name    = "cft-gke-test-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "cft-gke-test-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}

//==========

//resource "google_compute_subnetwork_iam_member" "gke_shared_vpc_subnets" {
////  provider = google-beta
//  subnetwork = google_compute_subnetwork.main.name
//  role = "roles/compute.networkUser"
//  project = google_project.gke_shared_host_project.project_id
//  member  = "serviceAccount:${google_service_account.gke_service.email}"
//
//  depends_on = [
//    google_project.gke_shared_host_project,
//    google_service_account.gke_service,
//  ]
//}
//
//
//resource "google_project_iam_member" "gke_host_agent" {
//  project = google_project.gke_service_project.project_id
//  role    = "roles/container.hostServiceAgentUser"
//  member  = "serviceAccount:${google_service_account.gke_service.email}"
//  depends_on = [
//    google_project.gke_shared_host_project,
//    google_service_account.gke_service,
//  ]
//}


/******************************************
  compute.networkUser role granted to GKE service account for GKE on shared VPC subnets
 *****************************************/
//resource "google_compute_subnetwork_iam_member" "gke_shared_vpc_subnets" {
////  provider = google-beta
//  subnetwork = google_compute_subnetwork.main.self_link
//  role = "roles/compute.networkUser"
//  project = google_project.gke_shared_host_project.project_id
//  member  = google_service_account.gke_service.name
//
//  depends_on = [
//    google_project.gke_shared_host_project,
//    google_service_account.gke_service,
//  ]
//}
//
///******************************************
//  container.hostServiceAgentUser role granted to GKE service account for GKE on shared VPC
// *****************************************/
//resource "google_project_iam_member" "gke_host_agent" {
//  project = google_project.gke_shared_host_project.project_id
//  role    = "roles/container.hostServiceAgentUser"
//  member  = google_service_account.gke_service.account_id
//  depends_on = [
//    google_project.gke_shared_host_project,
//    google_service_account.gke_service,
//  ]
//}