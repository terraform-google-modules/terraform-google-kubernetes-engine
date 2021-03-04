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
  name       = "beta-cluster-${random_string.suffix.result}"
  project_id = var.project_ids[0]
}

resource "google_kms_key_ring" "db" {
  location = var.region
  name     = "${local.name}-db"
  project  = local.project_id
}

resource "google_kms_crypto_key" "db" {
  name     = local.name
  key_ring = google_kms_key_ring.db.self_link
}

module "this" {
  source = "../../../examples/simple_regional_beta"

  cluster_name_suffix            = "-${random_string.suffix.result}"
  project_id                     = local.project_id
  regional                       = true
  region                         = var.region
  zones                          = slice(var.zones, 0, 1)
  network                        = google_compute_network.main.name
  subnetwork                     = google_compute_subnetwork.main.name
  ip_range_pods                  = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services              = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  compute_engine_service_account = "create"

  // Beta features
  istio = true

  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.db.self_link
  }]

  cloudrun = true

  dns_cache = true

  gce_pd_csi_driver = true

  enable_binary_authorization = true

  enable_pod_security_policy = true

  // Dataplane-V2 Feature
  datapath_provider = "ADVANCED_DATAPATH"
}

data "google_client_config" "default" {
}
