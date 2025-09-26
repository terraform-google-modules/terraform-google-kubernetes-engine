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
  cluster_type          = "gke-standard"
  default_workload_pool = "${var.project_id}.svc.id.goog"
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
  version = "~> 39.0"

  project_id = var.project_id
  name       = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  location   = var.region
  network    = var.network
  subnetwork = var.subnetwork

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

  addons_config = {
    dns_cache_config = {
      enabled = var.dns_cache
    }

    gce_persistent_disk_csi_driver_config = {
      enabled = var.gce_pd_csi_driver
    }
  }
}

module "node_pool" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/gke-node-pool"
  version = "~> 39.0"

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
  }
}
