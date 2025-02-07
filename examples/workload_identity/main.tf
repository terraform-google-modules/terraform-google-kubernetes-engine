/**
 * Copyright 2018-2024 Google LLC
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
  cluster_type = "regional"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)

  ignore_annotations = [
    "^iam.gke.io\\/.*"
  ]
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 36.0"

  project_id               = var.project_id
  name                     = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                   = var.region
  network                  = var.network
  subnetwork               = var.subnetwork
  ip_range_pods            = var.ip_range_pods
  ip_range_services        = var.ip_range_services
  remove_default_node_pool = true
  service_account          = "create"
  node_metadata            = "GKE_METADATA"
  deletion_protection      = false
  node_pools = [
    {
      name         = "wi-pool"
      min_count    = 1
      max_count    = 2
      auto_upgrade = true
    }
  ]
}

# example without existing KSA
module "workload_identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 36.0"

  project_id          = var.project_id
  name                = "iden-${module.gke.name}"
  namespace           = "default"
  use_existing_k8s_sa = false
}

# example with existing KSA
resource "kubernetes_service_account" "test" {
  metadata {
    name = "foo-ksa"
  }
  secret {
    name = "bar"
  }
}

module "workload_identity_existing_ksa" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 36.0"

  project_id          = var.project_id
  name                = "existing-${module.gke.name}"
  cluster_name        = module.gke.name
  location            = module.gke.location
  namespace           = "default"
  use_existing_k8s_sa = true
  k8s_sa_name         = kubernetes_service_account.test.metadata[0].name
}

# example with existing GSA
resource "google_service_account" "custom" {
  account_id = "custom-gsa"
  project    = var.project_id
}

module "workload_identity_existing_gsa" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 36.0"

  project_id          = var.project_id
  name                = google_service_account.custom.account_id
  use_existing_gcp_sa = true
  # wait till custom GSA is created to force module data source read during apply
  # https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1059
  depends_on = [google_service_account.custom]
}
