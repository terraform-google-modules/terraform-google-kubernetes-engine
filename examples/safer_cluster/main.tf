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

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  cluster_type           = "safer-cluster"
  network_name           = "safer-cluster-network-${random_string.suffix.result}"
  subnet_name            = "safer-cluster-subnet"
  master_auth_subnetwork = "safer-cluster-master-subnet"
  pods_range_name        = "ip-range-pods-${random_string.suffix.result}"
  svc_range_name         = "ip-range-svc-${random_string.suffix.result}"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

// A random valid k8s version is retrived
// to specify as an explicit version.
data "google_container_engine_versions" "current" {
  project  = var.project_id
  location = var.region
}

resource "random_shuffle" "version" {
  input        = data.google_container_engine_versions.current.valid_master_versions
  result_count = 1
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version = "~> 36.0"

  project_id                 = var.project_id
  name                       = "${local.cluster_type}-cluster-${random_string.suffix.result}"
  regional                   = true
  region                     = var.region
  network                    = module.gcp-network.network_name
  subnetwork                 = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  master_ipv4_cidr_block     = "172.16.0.0/28"
  add_cluster_firewall_rules = true
  firewall_inbound_ports     = ["9443", "15017"]
  kubernetes_version         = random_shuffle.version.result[0]
  release_channel            = "UNSPECIFIED"
  deletion_protection        = false

  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]

  notification_config_topic = google_pubsub_topic.updates.id
}

resource "google_pubsub_topic" "updates" {
  name    = "cluster-updates-${random_string.suffix.result}"
  project = var.project_id
}
