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
  cluster_type = "simple-regional-beta"
}

provider "google-beta" {
  version = "~> 3.23.0"
  region  = var.region
}

module "gke" {
  source                      = "../../modules/beta-public-cluster/"
  project_id                  = var.project_id
  name                        = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                    = var.regional
  region                      = var.region
  zones                       = var.zones
  network                     = var.network
  subnetwork                  = var.subnetwork
  ip_range_pods               = var.ip_range_pods
  ip_range_services           = var.ip_range_services
  create_service_account      = var.compute_engine_service_account == "create"
  service_account             = var.compute_engine_service_account
  istio                       = var.istio
  cloudrun                    = var.cloudrun
  dns_cache                   = var.dns_cache
  gce_pd_csi_driver           = var.gce_pd_csi_driver
  sandbox_enabled             = var.sandbox_enabled
  remove_default_node_pool    = var.remove_default_node_pool
  node_pools                  = var.node_pools
  database_encryption         = var.database_encryption
  enable_binary_authorization = var.enable_binary_authorization
  pod_security_policy_config  = var.pod_security_policy_config
  release_channel             = "REGULAR"

  # Disable workload identity
  identity_namespace = null
  node_metadata      = "UNSPECIFIED"
}

data "google_client_config" "default" {
}
