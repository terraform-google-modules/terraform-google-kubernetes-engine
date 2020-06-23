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
  cluster_type = "regional"
}

provider "google" {
  version = "~> 3.16.0"
  region  = var.region
}

provider "kubernetes" {
  version                = "~> 1.10, != 1.11.0"
  host                   = module.gke.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  load_config_file       = false
}

module "gke" {
  source                   = "../../modules/beta-public-cluster/"
  project_id               = var.project_id
  name                     = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                   = var.region
  network                  = var.network
  subnetwork               = var.subnetwork
  ip_range_pods            = var.ip_range_pods
  ip_range_services        = var.ip_range_services
  remove_default_node_pool = true
  service_account          = "create"
  node_metadata            = "GKE_METADATA_SERVER"
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
  source              = "../../modules/workload-identity"
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
  source              = "../../modules/workload-identity"
  project_id          = var.project_id
  name                = "existing-${module.gke.name}"
  cluster_name        = module.gke.name
  location            = module.gke.location
  namespace           = "default"
  use_existing_k8s_sa = true
  k8s_sa_name         = kubernetes_service_account.test.metadata.0.name
}

data "google_client_config" "default" {
}
