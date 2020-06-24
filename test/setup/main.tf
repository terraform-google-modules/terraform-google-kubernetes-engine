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

resource "random_id" "random_project_id_suffix" {
  byte_length = 4
}

module "gke-project-1" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 8.0"

  name                 = "ci-gke-${random_id.random_project_id_suffix.hex}"
  random_project_id    = true
  org_id               = var.org_id
  folder_id            = var.folder_id
  billing_account      = var.billing_account
  skip_gcloud_download = true

  auto_create_network = true

  activate_apis = [
    "bigquery.googleapis.com",
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
  version = "~> 8.0"

  name                 = "ci-gke-${random_id.random_project_id_suffix.hex}"
  random_project_id    = true
  org_id               = var.org_id
  folder_id            = var.folder_id
  billing_account      = var.billing_account
  skip_gcloud_download = true

  activate_apis = [
    "bigquery.googleapis.com",
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

# apis as documented https://cloud.google.com/service-mesh/docs/gke-install-new-cluster#setting_up_your_project
module "gke-project-asm" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 8.0"

  name                 = "ci-gke-asm-${random_id.random_project_id_suffix.hex}"
  random_project_id    = true
  org_id               = var.org_id
  folder_id            = var.folder_id
  billing_account      = var.billing_account
  skip_gcloud_download = true

  activate_apis = [
    "container.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "anthos.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
}
