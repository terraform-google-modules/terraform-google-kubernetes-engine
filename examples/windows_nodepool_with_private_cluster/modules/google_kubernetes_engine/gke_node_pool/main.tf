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

// This file was automatically generated from a template in ./autogen/main

locals {
  enable_autoscaling = var.enable_autoscaling ? [true] : []
  node_locations     = var.regional ? var.zones : null

}

/******************************************
  Create Container Cluster node pools
 *****************************************/

resource "google_container_node_pool" "pools" {

  provider       = google
  name           = var.node_pool_name
  project        = var.project_id
  location       = var.regional ? var.region : var.zones[0]
  node_locations = local.node_locations

  cluster           = var.gke_cluster_name
  version           = var.auto_upgrade ? "" : var.gke_cluster_min_master_version
  max_pods_per_node = var.max_pods_per_node
  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  initial_node_count = var.enable_autoscaling ? var.initial_node_count : null
  node_count         = var.enable_autoscaling ? null : var.node_count



  dynamic "autoscaling" {
    for_each = local.enable_autoscaling
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  node_config {
    image_type      = var.image_type
    machine_type    = var.machine_type
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    local_ssd_count = var.local_ssd_count

    oauth_scopes = [
      # Providing access to all of the api
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    preemptible = var.preemptible
    #####
    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }
    labels          = var.labels
    service_account = var.service_account
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }


}

