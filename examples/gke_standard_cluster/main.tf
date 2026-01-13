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
  cluster_type             = "gke-standard"
  default_workload_pool    = "${var.project_id}.svc.id.goog"
  secondary_pod_range_name = "gke-additional-pods-${random_string.suffix.result}"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/gke-standard-cluster"
  version = "~> 43.0"

  project_id = var.project_id
  name       = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  location   = var.region
  network    = var.network
  subnetwork = var.subnetwork

  # Needed for the Multi-Network for Pods configuration
  datapath_provider       = "ADVANCED_DATAPATH"
  enable_multi_networking = true

  ip_allocation_policy = {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  private_cluster_config = {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config = {
      enabled = true
    }
  }

  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config = {
    workload_pool = local.default_workload_pool
  }

  master_authorized_networks_config = {
    cidr_blocks = [{
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    }]
  }

  master_auth = {
    client_certificate_config = {
      issue_client_certificate = false
    }
  }

  addons_config = {
    dns_cache_config = {
      enabled = var.dns_cache
    }

    gce_persistent_disk_csi_driver_config = {
      enabled = var.gce_pd_csi_driver
    }
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Secondary VPC for the additional interface
resource "google_compute_network" "additional_network" {
  name                    = "gke-additional-network-${random_string.suffix.result}"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnetwork with a secondary range
resource "google_compute_subnetwork" "additional_subnetwork" {
  name          = "gke-additional-subnet-${random_string.suffix.result}"
  network       = google_compute_network.additional_network.id
  region        = var.region
  project       = var.project_id
  ip_cidr_range = "10.100.0.0/24"

  # REQUIRED for `additional_pod_network_configs`
  secondary_ip_range {
    range_name    = local.secondary_pod_range_name
    ip_cidr_range = "10.101.0.0/20"
  }
}

module "node_pool" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/gke-node-pool"
  version = "~> 43.0"

  project_id = var.project_id
  location   = var.region
  cluster    = module.gke.cluster_name
  node_config = {
    disk_size_gb    = 100
    disk_type       = "pd-standard"
    image_type      = "COS_CONTAINERD"
    machine_type    = "e2-medium"
    service_account = var.service_account
    workload_metadata_config = {
      mode = "GKE_METADATA"
    }
    kubelet_config = {
      insecure_kubelet_readonly_port_enabled = false
    }
  }

  network_config = {
    additional_node_network_configs = [
      {
        network    = google_compute_network.additional_network.name
        subnetwork = google_compute_subnetwork.additional_subnetwork.name
      }
    ]

    additional_pod_network_configs = [
      {
        subnetwork          = google_compute_subnetwork.additional_subnetwork.name
        secondary_pod_range = local.secondary_pod_range_name
        max_pods_per_node   = 32
      }
    ]
  }
}
