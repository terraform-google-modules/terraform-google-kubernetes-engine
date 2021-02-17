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
  int_required_roles = [
    "roles/cloudkms.admin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/container.developer",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/compute.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/composer.worker",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/compute.osLogin",
    "roles/compute.instanceAdmin",
    "roles/iam.roleAdmin",
    "roles/iap.admin",
    "roles/gkehub.admin",
  ]

  # roles as documented https://cloud.google.com/service-mesh/docs/installation-permissions
  int_asm_required_roles = [
    "roles/editor",
    "roles/compute.admin",
    "roles/container.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/servicemanagement.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/meshconfig.admin",
    "roles/gkehub.admin",
    "roles/privateca.admin",
  ]
}

resource "random_id" "random_suffix" {
  byte_length = 2
}

resource "google_service_account" "int_test" {
  project      = module.gke-project-1.project_id
  account_id   = "gke-int-test-${random_id.random_suffix.hex}"
  display_name = "gke-int-test"
}

resource "google_service_account" "gke_sa_1" {
  project      = module.gke-project-1.project_id
  account_id   = "gke-sa-int-test-p1-${random_id.random_suffix.hex}"
  display_name = "gke-sa-int-test-p1"
}

resource "google_service_account" "gke_sa_2" {
  project      = module.gke-project-2.project_id
  account_id   = "gke-sa-int-test-p2-${random_id.random_suffix.hex}"
  display_name = "gke-sa-int-test-p2"
}

resource "google_service_account" "gke_sa_asm" {
  project      = module.gke-project-asm.project_id
  account_id   = "gke-sa-int-test-asm-${random_id.random_suffix.hex}"
  display_name = "gke-sa-int-test-asm"
}

resource "google_project_iam_member" "int_test_1" {
  count = length(local.int_required_roles)

  project = module.gke-project-1.project_id
  role    = local.int_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "int_test_2" {
  count = length(local.int_required_roles)

  project = module.gke-project-2.project_id
  role    = local.int_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "int_test_asm" {
  for_each = toset(concat(local.int_required_roles, local.int_asm_required_roles))

  project = module.gke-project-asm.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

resource "google_project_iam_binding" "kubernetes_engine_kms_access" {
  project = module.gke-project-1.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${module.gke-project-1.project_number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}
