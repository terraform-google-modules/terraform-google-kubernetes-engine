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

{{ autogeneration_note }}

/******************************************
  Create zonal cluster
 *****************************************/
resource "google_container_cluster" "zonal_primary" {
  provider    = "{% if private_cluster %}google-beta{%else %}google{% endif %}"
  count       = "${var.regional ? 0 : 1}"
  name        = "${var.name}"
  description = "${var.description}"
  project     = "${var.project_id}"

  zone           = "${var.zones[0]}"
  node_locations = ["${slice(var.zones,1,length(var.zones))}"]

  network            = "${replace(data.google_compute_network.gke_network.self_link, "https://www.googleapis.com/compute/v1/", "")}"
  subnetwork         = "${replace(data.google_compute_subnetwork.gke_subnetwork.self_link, "https://www.googleapis.com/compute/v1/", "")}"
  min_master_version = "${local.kubernetes_version_zonal}"

  logging_service    = "${var.logging_service}"
  monitoring_service = "${var.monitoring_service}"

  master_authorized_networks_config = ["${var.master_authorized_networks_config}"]

  master_auth {
    username = "${var.basic_auth_username}"
    password = "${var.basic_auth_password}"

    client_certificate_config {
      issue_client_certificate = "${var.issue_client_certificate}"
    }
  }

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
      service_account = "${lookup(var.node_pools[0], "service_account", local.service_account)}"
    }
  }
{% if private_cluster %}

  private_cluster_config {
    enable_private_endpoint = "${var.enable_private_endpoint}"
    enable_private_nodes    = "${var.enable_private_nodes}"
    master_ipv4_cidr_block  = "${var.master_ipv4_cidr_block}"
  }
{% endif %}

  remove_default_node_pool = "${var.remove_default_node_pool}"
}

/******************************************
  Create zonal node pools
 *****************************************/
resource "google_container_node_pool" "zonal_pools" {
  provider           = "google-beta"
  count              = "${var.regional ? 0 : length(var.node_pools)}"
  name               = "${lookup(var.node_pools[count.index], "name")}"
  project            = "${var.project_id}"
  zone               = "${var.zones[0]}"
  cluster            = "${google_container_cluster.zonal_primary.name}"
  version            = "${lookup(var.node_pools[count.index], "auto_upgrade", false) ? "" : lookup(var.node_pools[count.index], "version", local.node_version_zonal)}"
  initial_node_count = "${lookup(var.node_pools[count.index], "initial_node_count", lookup(var.node_pools[count.index], "min_count", 1))}"

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
    metadata     = "${merge(map("cluster_name", var.name), map("node_pool", lookup(var.node_pools[count.index], "name")), var.node_pools_metadata["all"], var.node_pools_metadata[lookup(var.node_pools[count.index], "name")], map("disable-legacy-endpoints", var.disable_legacy_metadata_endpoints))}"
    taint        = "${concat(var.node_pools_taints["all"], var.node_pools_taints[lookup(var.node_pools[count.index], "name")])}"
    tags         = ["${concat(list("gke-${var.name}"), list("gke-${var.name}-${lookup(var.node_pools[count.index], "name")}"), var.node_pools_tags["all"], var.node_pools_tags[lookup(var.node_pools[count.index], "name")])}"]

    disk_size_gb    = "${lookup(var.node_pools[count.index], "disk_size_gb", 100)}"
    disk_type       = "${lookup(var.node_pools[count.index], "disk_type", "pd-standard")}"
    service_account = "${lookup(var.node_pools[count.index], "service_account", local.service_account)}"
    preemptible     = "${lookup(var.node_pools[count.index], "preemptible", false)}"

    oauth_scopes = [
      "${concat(var.node_pools_oauth_scopes["all"],
      var.node_pools_oauth_scopes[lookup(var.node_pools[count.index], "name")])}",
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
}

resource "null_resource" "wait_for_zonal_cluster" {
  count = "${var.regional ? 0 : 1}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-cluster.sh ${var.project_id} ${var.name}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/wait-for-cluster.sh ${var.project_id} ${var.name}"
  }

  depends_on = ["google_container_cluster.zonal_primary", "google_container_node_pool.zonal_pools"]
}
