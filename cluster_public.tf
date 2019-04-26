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

resource "google_container_cluster" "public" {
  provider                          = "google-beta"
  count                             = "${local.cluster_type == "public" ? 1 : 0}"
  name                              = "${var.name}"
  description                       = "${var.description}"
  project                           = "${var.project_id}"
  location                          = "${local.location}"
  node_locations                    = ["${local.node_locations}"]
  network                           = "${local.cluster_network}"
  subnetwork                        = "${local.cluster_subnetwork}"
  min_master_version                = "${local.kubernetes_version}"
  logging_service                   = "${var.logging_service}"
  monitoring_service                = "${var.monitoring_service}"
  master_authorized_networks_config = ["${var.master_authorized_networks_config}"]
  remove_default_node_pool          = "${var.remove_default_node_pool}"
  initial_node_count                = "${var.initial_node_count}"

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
    ignore_changes = ["initial_node_count"]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
