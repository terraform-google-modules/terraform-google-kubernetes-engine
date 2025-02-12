/**
 * Copyright 2025 Google LLC
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
  cluster_type           = "simple-autopilot-private-cmek"
  network_name           = "simple-autopilot-private-cmek-network"
  subnet_name            = "simple-autopilot-private-cmek-subnet"
  master_auth_subnetwork = "simple-autopilot-private-master-subnet"
  pods_range_name        = "ip-range-pods-simple-autopilot-private"
  svc_range_name         = "ip-range-svc-simple-autopilot-private"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}

data "google_client_config" "default" {}

data "google_project" "main" {
  project_id = var.project_id
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 4.0"

  project_id           = var.project_id
  key_protection_level = "HSM"
  location             = "us-central1"
  keyring              = "keyring"
  keys                 = ["key"]
  prevent_destroy      = false
}

resource "google_kms_crypto_key_iam_member" "main" {
  crypto_key_id = values(module.kms.keys)[0]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.main.number}@compute-system.iam.gserviceaccount.com"
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 36.0"

  project_id                      = var.project_id
  name                            = "${local.cluster_type}-cluster"
  regional                        = true
  region                          = "us-central1"
  network                         = module.gcp-network.network_name
  subnetwork                      = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                   = local.pods_range_name
  ip_range_services               = local.svc_range_name
  release_channel                 = "REGULAR"
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = true
  enable_private_nodes            = true
  network_tags                    = [local.cluster_type]
  deletion_protection             = false
  boot_disk_kms_key               = values(module.kms.keys)[0]
  depends_on                      = [google_kms_crypto_key_iam_member.main]
}
