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
  cluster_type           = "confidential-autopilot-private"
  network_name           = "confidential-autopilot-private-network"
  subnet_name            = "confidential-autopilot-private-subnet"
  master_auth_subnetwork = "confidential-autopilot-master-subnet"
  pods_range_name        = "ip-range-pods-confidential-autopilot"
  svc_range_name         = "ip-range-svc-confidential-autopilot"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}

data "google_project" "main" {
  project_id = var.project_id
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 4.0"

  project_id           = var.project_id
  key_protection_level = "HSM"
  location             = var.region
  keyring              = "keyring-${random_string.suffix.result}"
  keys                 = ["key"]
  prevent_destroy      = false
}

resource "google_kms_crypto_key_iam_member" "main" {
  crypto_key_id = values(module.kms.keys)[0]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.main.number}@compute-system.iam.gserviceaccount.com"
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 43.0"

  project_id                      = var.project_id
  name                            = "${local.cluster_type}-cluster"
  regional                        = true
  region                          = var.region
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
  enable_confidential_nodes       = true

  database_encryption = [
    {
      "key_name" : values(module.kms.keys)[0],
      "state" : "ENCRYPTED"
    }
  ]

  depends_on = [google_kms_crypto_key_iam_member.main]
}
