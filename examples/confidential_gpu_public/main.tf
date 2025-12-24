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
  cluster_type           = "confidential-gpu"
  network_name           = "confidential-gpu-network-${random_string.suffix.result}"
  subnet_name            = "confidential-gpu-subnet"
  master_auth_subnetwork = "confidential-gpu-master-subnet"
  pods_range_name        = "ip-range-pods-${random_string.suffix.result}"
  svc_range_name         = "ip-range-svc-${random_string.suffix.result}"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

data "google_project" "main" {
  project_id = var.project_id
}

resource "google_kms_crypto_key_iam_member" "main" {
  crypto_key_id = module.kms.keys[local.key_name]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.main.number}@compute-system.iam.gserviceaccount.com"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version = "~> 37.0"

  project_id                        = var.project_id
  name                              = "${local.cluster_type}-cluster-${random_string.suffix.result}"
  region                            = var.region
  zones                             = var.zones
  network                           = module.gcp-network.network_name
  subnetwork                        = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                     = local.pods_range_name
  ip_range_services                 = local.svc_range_name
  create_service_account            = false
  initial_node_count                = 1
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = false
  deletion_protection               = false
  service_account                   = "default"
  logging_variant                   = "MAX_THROUGHPUT"
  dns_allow_external_traffic        = true

  enable_confidential_nodes = true

  database_encryption = [
    {
      "key_name" : module.kms.keys[local.key_name],
      "state" : "ENCRYPTED"
    }
  ]

  node_pools = [
    {
      name                              = "default"
      machine_type                      = "a3-highgpu-1g"
      confidential_instance_type        = "TDX"
      spot                              = true
      disk_type                         = "hyperdisk-balanced"
      boot_disk_kms_key                 = module.kms.keys[local.key_name]
      enable_confidential_storage       = true
      accelerator_count                 = 1
      accelerator_type                  = "nvidia-h100-80gb"
      gpu_driver_version                = "INSTALLATION_DISABLED"
      node_locations                    = join(",", var.zones)
      local_ssd_ephemeral_storage_count = 2
    },
  ]
}

module "kubectl" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 4.0"

  project_id              = var.project_id
  cluster_name            = module.gke.name
  cluster_location        = module.gke.location
  module_depends_on       = [module.gke.endpoint]
  kubectl_create_command  = "kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/5619568e366f5ea5de4431bbe8e68934c5f582da/nvidia-driver-installer/cos/daemonset-confidential.yaml"
  kubectl_destroy_command = "kubectl delete -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/5619568e366f5ea5de4431bbe8e68934c5f582da/nvidia-driver-installer/cos/daemonset-confidential.yaml"
  skip_download           = true
}
