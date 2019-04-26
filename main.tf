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

data "google_client_config" "default" {
  provider = "google"
}

/******************************************
  Get available container engine versions
 *****************************************/

data "google_container_engine_versions" "available" {
  location = "${local.location}"
  project  = "${var.project_id}"
}

/******************************************
  Get available zones in region
 *****************************************/
data "google_compute_zones" "available" {
  provider = "google"
  project  = "${var.project_id}"
  region   = "${var.region}"
}

resource "random_shuffle" "available_zones" {
  input        = ["${data.google_compute_zones.available.names}"]
  result_count = 3
}

locals {
  cluster_type                = "${var.enable_private_endpoint || var.enable_private_endpoint == "true" || var.enable_private_nodes || var.enable_private_nodes == "true" ? "private" : "public"}"
  kubernetes_version          = "${var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.available.latest_master_version}"
  node_version                = "${var.node_version != "master" ? var.node_version : local.kubernetes_version}"
  custom_kube_dns_config      = "${length(keys(var.stub_domains)) > 0 ? true : false}"
  network_project_id          = "${var.network_project_id != "" ? var.network_project_id : var.project_id}"
  location                    = "${var.zones[0] == "" && length(var.zones) == 1 ? var.region : var.zones[0]}"
  cluster_node_pools_versions = "${google_container_node_pool.main.*.version}"

  node_locations = "${coalescelist(
    compact(var.zones),
    sort(random_shuffle.available_zones.result)
  )}"

  cluster_location = "${element(
    flatten(
      concat(
        google_container_cluster.public.*.location,
        google_container_cluster.private.*.location,
        list(""),
      )
  ),0)}"

  cluster_zones = "${compact(
    concat(
      local.node_locations,
      google_container_cluster.private.*.zone,
      list(""),
  ))}"

  cluster_endpoint = "${element(
    concat(
      google_container_cluster.public.*.endpoint,
      google_container_cluster.private.*.endpoint,
      list(""),
  ), 0)}"

  cluster_client_certificate = "${element(
    concat(
      google_container_cluster.public.*.master_auth.0.client_certificate,
      google_container_cluster.private.*.master_auth.0.client_certificate,
      list(""),
  ), 0)}"

  cluster_client_key = "${element(
    concat(
      google_container_cluster.private.*.master_auth.0.client_key,
      google_container_cluster.public.*.master_auth.0.client_key,
      list(""),
  ), 0)}"

  cluster_ca_certificate = "${element(
    concat(
      google_container_cluster.private.*.master_auth.0.cluster_ca_certificate,
      google_container_cluster.public.*.master_auth.0.cluster_ca_certificate,
      list(""),
  ), 0)}"

  cluster_master_version = "${element(
    concat(
      google_container_cluster.public.*.master_version,
      google_container_cluster.private.*.master_version,
      list(""),
  ), 0)}"

  cluster_min_master_version = "${element(
    concat(
      google_container_cluster.public.*.min_master_version,
      google_container_cluster.private.*.min_master_version,
      list(""),
  ), 0)}"

  cluster_logging_service = "${element(
    concat(
      google_container_cluster.public.*.logging_service,
      google_container_cluster.private.*.logging_service,
      list(""),
  ), 0)}"

  cluster_monitoring_service = "${element(
    concat(
      google_container_cluster.public.*.monitoring_service,
      google_container_cluster.private.*.monitoring_service,
      list(""),
  ), 0)}"

  cluster_network_policy_enabled = "${element(
    concat(
      google_container_cluster.public.*.addons_config.0.network_policy_config.0.disabled,
      google_container_cluster.private.*.addons_config.0.network_policy_config.0.disabled,
      list(""),
  ), 0)}"

  cluster_http_load_balancing_enabled = "${element(
    concat(
      google_container_cluster.public.*.addons_config.0.http_load_balancing.0.disabled,
      google_container_cluster.private.*.addons_config.0.http_load_balancing.0.disabled,
      list(""),
  ), 0)}"

  cluster_horizontal_pod_autoscaling_enabled = "${element(
    concat(
      google_container_cluster.public.*.addons_config.0.http_load_balancing.0.disabled,
      google_container_cluster.private.*.addons_config.0.horizontal_pod_autoscaling.0.disabled,
      list(""),
  ), 0)}"

  cluster_kubernetes_dashboard_enabled = "${element(
    concat(
      google_container_cluster.public.*.addons_config.0.kubernetes_dashboard.0.disabled,
      google_container_cluster.private.*.addons_config.0.kubernetes_dashboard.0.disabled,
      list(""),
  ), 0)}"

  cluster_node_pools_names = "${element(
    concat(
      google_container_node_pool.main.*.name,
      list(""),
  ), 0)}"

  cluster_network = "${replace(
    data.google_compute_network.gke_network.self_link,
    "https://www.googleapis.com/compute/v1/",
    "")
  }"

  cluster_subnetwork = "${replace(
    data.google_compute_subnetwork.gke_subnetwork.self_link,
    "https://www.googleapis.com/compute/v1/",
    "")
  }"
}

resource "null_resource" "wait_for_cluster" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-cluster.sh ${var.project_id} ${var.name}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/wait-for-cluster.sh ${var.project_id} ${var.name}"
  }

  depends_on = ["google_container_cluster.public", "google_container_cluster.private", "google_container_node_pool.main"]
}
