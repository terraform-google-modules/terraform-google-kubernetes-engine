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

resource "random_id" "folder_rand" {
  byte_length = 2
}

resource "google_folder" "ci_gke_folder" {
  display_name = "ci-tests-gke-folder-${random_id.folder_rand.hex}"
  parent       = "folders/${replace(var.folder_id, "folders/", "")}"
}

module "gke-project-1" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name              = "ci-gke"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_gke_folder.id
  billing_account   = var.billing_account

  auto_create_network = true

  activate_apis = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "cloudbilling.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

module "gke-project-2" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name              = "ci-gke"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_gke_folder.id
  billing_account   = var.billing_account

  activate_apis = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "cloudbilling.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

/* Create Shared VPC host and service projects to test shared-vpc-helper submodule.
Only compute.googleapis.com is enabled. All others needed resourcess will provided by the submodule.
*/
module "gke_svpc_host_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name              = "ci-gke-svpc-host"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_gke_folder.id
  billing_account   = var.billing_account

  auto_create_network = false

  activate_apis = [
    "compute.googleapis.com"
  ]
}

// Enables the Shared VPC feature for a created project, assigning it as a Shared VPC host project.
resource "google_compute_shared_vpc_host_project" "gke_svpc_host_project" {
  depends_on = [
    module.gke_svpc_host_project
  ]
  project = module.gke_svpc_host_project.project_id
}

// Create service account. Plane ressourcess are used in reason ISUUE TODO: add link to issue
resource "google_project" "gke_service_project" {
  name            = "ci-gke-svpc-service"
  folder_id       = google_folder.ci_gke_folder.id
  project_id      = "ci-gke-svpc-service-${random_id.folder_rand.hex}"
  billing_account = var.billing_account
}

// Enable compute api to assigning it as a Shared VPC service project.
resource "google_project_service" "gke_service_project_api" {
  depends_on = [google_project.gke_service_project]
  project    = google_project.gke_service_project.project_id
  service    = "compute.googleapis.com"
}

resource "google_compute_shared_vpc_service_project" "gke_service_project" {
  depends_on = [
    google_compute_shared_vpc_host_project.gke_svpc_host_project,
  ]
  host_project    = module.gke_svpc_host_project.project_id
  service_project = google_project.gke_service_project.project_id
}
