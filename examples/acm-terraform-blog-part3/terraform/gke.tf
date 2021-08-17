/**
 * Copyright 2021 Google LLC
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

module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.project
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com"
  ]
}

module "gke" {
  source             = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version            = "~> 16.0"
  project_id         = module.enabled_google_apis.project_id
  name               = "sfl-acm-part3"
  region             = var.region
  zones              = [var.zone]
  initial_node_count = 4
  network            = "default"
  subnetwork         = "default"
  ip_range_pods      = ""
  ip_range_services  = ""
  config_connector   = true
  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]
  depends_on = [
    module.enabled_google_apis
  ]
}

/*
module "wi" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version             = "~> 16.0.1"
  name                = "crnmsa"
  cluster_name        = "sfl-acm-part3" 
  k8s_sa_name         = "cnrm-controller-manager"
  use_existing_k8s_sa = true
  namespace           = "cnrm-system"
  project_id          = module.enabled_google_apis.project_id
  roles               = ["roles/owner"]
   depends_on = [
    module.gke
  ]
}
*/

resource "google_service_account" "cnrmsa" {
  account_id   = "cnrmsa"
  project = module.enabled_google_apis.project_id
  display_name = "IAM service account used by Config Connector"
  depends_on = [
    module.gke
  ]
}

resource "google_project_iam_member" "project" {
  project = var.project
  role    = "roles/owner"
  member = "serviceAccount:${google_service_account.cnrmsa.email}"
  depends_on = [
    google_service_account.cnrmsa
  ]
}

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.cnrmsa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
  ]
}

