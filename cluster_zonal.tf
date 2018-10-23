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
  Create zonal cluster
 *****************************************/
resource "google_container_cluster" "zonal_primary" {
  provider    = "google-beta"
  count       = "${(local.cluster_deployment_type == "zonal") ? 1 : 0 }"
  name        = "${var.name}"
  description = "${var.description}"
  project     = "${var.project_id}"

  zone             = "${var.zones[0]}"
  additional_zones = "${slice(var.zones,1,length(var.zones))}"

  network            = "${data.google_compute_network.gke_network.self_link}"
  subnetwork         = "${data.google_compute_subnetwork.gke_subnetwork.self_link}"
  min_master_version = "${local.kubernetes_version}"

  logging_service    = "${var.logging_service}"
  monitoring_service = "${var.monitoring_service}"

  master_authorized_networks_config = "${var.master_authorized_networks_config}"

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
      service_account = "${lookup(var.node_pools[0], "service_account", "")}"
    }
  }
}

/******************************************
  Create zonal node pools
 *****************************************/
resource "google_container_node_pool" "zonal_pools" {
  provider           = "google-beta"
  count              = "${(local.cluster_deployment_type == "zonal") ? length(var.node_pools) : 0 }"
  name               = "${lookup(var.node_pools[count.index], "name")}"
  project            = "${var.project_id}"
  zone               = "${var.zones[0]}"
  cluster            = "${var.name}"
  version            = "${lookup(var.node_pools[count.index], "auto_upgrade", false) ? "" : lookup(var.node_pools[count.index], "version", local.node_version)}"
  initial_node_count = "${lookup(var.node_pools[count.index], "min_count", 1)}"

  autoscaling {
    min_node_count = "${lookup(var.node_pools[count.index], "min_count", 1)}"
    max_node_count = "${lookup(var.node_pools[count.index], "max_count", 100)}"
  }

  management {
    auto_repair  = "${lookup(var.node_pools[count.index], "auto_repair", true)}"
    auto_upgrade = "${lookup(var.node_pools[count.index], "auto_upgrade", false)}"
  }

  node_config {
    image_type   = "${lookup(var.node_pools[count.index], "image_type", "COS")}"
    machine_type = "${lookup(var.node_pools[count.index], "machine_type", "n1-standard-2")}"
    labels       = "${merge(map("cluster_name", var.name), map("node_pool", lookup(var.node_pools[count.index], "name")), var.node_pools_labels["all"], var.node_pools_labels[lookup(var.node_pools[count.index], "name")])}"
    taint        = "${concat(var.node_pools_taints["all"], var.node_pools_taints[lookup(var.node_pools[count.index], "name")])}"
    tags         = "${concat(list("gke-${var.name}"), list("gke-${var.name}-${lookup(var.node_pools[count.index], "name")}"), var.node_pools_tags["all"], var.node_pools_tags[lookup(var.node_pools[count.index], "name")])}"

    disk_size_gb    = "${lookup(var.node_pools[count.index], "disk_size_gb", 100)}"
    disk_type       = "${lookup(var.node_pools[count.index], "disk_type", "pd-standard")}"
    service_account = "${lookup(var.node_pools[count.index], "service_account", "")}"

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

  depends_on = ["google_container_cluster.zonal_primary"]
}
