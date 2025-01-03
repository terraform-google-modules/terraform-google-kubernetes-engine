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

locals {
  apis = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "pubsub.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "anthos.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "logging.googleapis.com",
    "meshca.googleapis.com",
    "meshconfig.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudtrace.googleapis.com",
    "meshca.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkeconnect.googleapis.com",
    "privateca.googleapis.com",
    "gkehub.googleapis.com",
    "cloudasset.googleapis.com"
  ]
}

module "gke-project-1" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name                     = "ci-gke-${random_id.random_project_id_suffix.hex}"
  random_project_id        = true
  random_project_id_length = 4
  org_id                   = var.org_id
  folder_id                = var.folder_id
  billing_account          = var.billing_account
  # due to https://github.com/hashicorp/terraform-provider-google/issues/9505 for AP
  default_service_account = "keep"

  auto_create_network = true

  activate_apis = local.apis
  activate_api_identities = [
    {
      api   = "container.googleapis.com"
      roles = ["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/container.serviceAgent"]
    },
  ]
}

module "gke-project-2" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-gke-${random_id.random_project_id_suffix.hex}"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account
  # due to https://github.com/hashicorp/terraform-provider-google/issues/9505 for AP
  default_service_account = "keep"

  activate_apis = local.apis
  activate_api_identities = [
    {
      api   = "container.googleapis.com"
      roles = ["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/container.serviceAgent"]
    },
  ]
}

# apis as documented https://cloud.google.com/service-mesh/docs/scripted-install/reference#setting_up_your_project
module "gke-project-asm" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-gke-asm-${random_id.random_project_id_suffix.hex}"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account
  # due to https://github.com/hashicorp/terraform-provider-google/issues/9505 for AP
  default_service_account = "keep"

  activate_apis = local.apis
}

module "gke-project-fleet" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-gke-fleet-${random_id.random_project_id_suffix.hex}"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account
  # due to https://github.com/hashicorp/terraform-provider-google/issues/9505 for AP
  default_service_account = "keep"

  activate_apis = local.apis
}

