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

/******************************************
  Create regional cluster
 *****************************************/
resource "google_container_cluster" "primary" {
  count       = "${var.regional ? 1 : 0}"
  name        = "${var.name}"
  description = "${var.description}"
  project     = "${var.project_id}"

  region           = "${var.region}"
  additional_zones = "${var.zones}"

  network            = "projects/${local.network_project_id}/global/networks/${var.network}"
  subnetwork         = "projects/${local.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"
  min_master_version = "${local.kubernetes_version}"

  addons_config {
    http_load_balancing {
      disabled = "${var.http_load_balancing ? 0 : 1}"
    }

    horizontal_pod_autoscaling {
      disabled = "${var.horizontal_pod_autoscaling ? 0 : 1}"
    }

    kubernetes_dashboard {
      disabled = "${var.kubernetes_dashboard ? 0 : 1}"
    }

    network_policy_config {
      disabled = "${var.network_policy ? 0 : 1}"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.ip_range_pods}"
    services_secondary_range_name = "${var.ip_range_services}"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "${var.maintenance_start_time}"
    }
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  node_pool {
    name = "default-pool"

    node_config {
      service_account = "${var.node_service_account}"
    }
  }
}

/******************************************
  Create regional node pools
 *****************************************/
resource "google_container_node_pool" "pools" {
  count              = "${var.regional ? length(var.node_pools) : 0}"
  name               = "${lookup(var.node_pools[count.index], "name")}"
  project            = "${var.project_id}"
  region             = "${var.region}"
  cluster            = "${var.name}"
  version            = "${lookup(var.node_pools[count.index], "auto_upgrade", false) ? "" : lookup(var.node_pools[count.index], "version", local.node_version)}"
  initial_node_count = "${lookup(var.node_pools[count.index], "min_count", 1)}"

  autoscaling {
    min_node_count = "${lookup(var.node_pools[count.index], "min_count", 1)}"
    max_node_count = "${lookup(var.node_pools[count.index], "max_count", 100)}"
  }

  management {
    auto_repair  = "${lookup(var.node_pools[count.index], "auto_repair", true)}"
    auto_upgrade = "${lookup(var.node_pools[count.index], "auto_upgrade", true)}"
  }

  node_config {
    image_type   = "${lookup(var.node_pools[count.index], "image_type", "COS")}"
    machine_type = "${lookup(var.node_pools[count.index], "machine_type", "n1-standard-2")}"
    labels       = "${merge(map("cluster_name", var.name), map("node_pool", lookup(var.node_pools[count.index], "name")), var.node_pools_labels["all"], var.node_pools_labels[lookup(var.node_pools[count.index], "name")])}"
    taint        = "${concat(var.node_pools_taints["all"], var.node_pools_taints[lookup(var.node_pools[count.index], "name")])}"
    tags         = "${concat(list("gke-${var.name}"), list("gke-${var.name}-${lookup(var.node_pools[count.index], "name")}"), var.node_pools_tags["all"], var.node_pools_tags[lookup(var.node_pools[count.index], "name")])}"

    disk_size_gb    = "${lookup(var.node_pools[count.index], "disk_size_gb", 100)}"
    disk_type       = "${lookup(var.node_pools[count.index], "disk_type", "pd-standard")}"
    service_account = "${lookup(var.node_pools[count.index], "service_account", var.node_service_account)}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = ["initial_node_count"]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = ["google_container_cluster.primary"]
}
