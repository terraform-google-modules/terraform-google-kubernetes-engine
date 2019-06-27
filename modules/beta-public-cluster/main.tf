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

// This file was automatically generated from a template in ./autogen

/******************************************
  Get available zones in region
 *****************************************/
data "google_compute_zones" "available" {
  provider = "google-beta"
  project  = "${var.project_id}"
  region   = "${var.region}"
}

resource "random_shuffle" "available_zones" {
  input        = ["${data.google_compute_zones.available.names}"]
  result_count = 3
}

locals {
  kubernetes_version_regional = "${var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version}"
  kubernetes_version_zonal    = "${var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version}"
  node_version_regional       = "${var.node_version != "" && var.regional ? var.node_version : local.kubernetes_version_regional}"
  node_version_zonal          = "${var.node_version != "" && !var.regional ? var.node_version : local.kubernetes_version_zonal}"
  custom_kube_dns_config      = "${length(keys(var.stub_domains)) > 0 ? true : false}"
  network_project_id          = "${var.network_project_id != "" ? var.network_project_id : var.project_id}"

  cluster_type = "${var.regional ? "regional" : "zonal"}"

  cluster_type_output_name = {
    regional = "${element(concat(google_container_cluster.primary.*.name, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.name, list("")), 0)}"
  }

  cluster_type_output_location = {
    regional = "${element(concat(google_container_cluster.primary.*.region, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.zone, list("")), 0)}"
  }

  cluster_type_output_region = {
    regional = "${element(concat(google_container_cluster.primary.*.region, list("")), 0)}"
    zonal    = "${var.region}"
  }

  cluster_type_output_regional_zones = "${flatten(google_container_cluster.primary.*.node_locations)}"
  cluster_type_output_zonal_zones    = "${slice(var.zones, 1, length(var.zones))}"

  cluster_type_output_zones = {
    regional = "${local.cluster_type_output_regional_zones}"
    zonal    = "${concat(google_container_cluster.zonal_primary.*.zone, local.cluster_type_output_zonal_zones)}"
  }

  cluster_type_output_endpoint = {
    regional = "${element(concat(google_container_cluster.primary.*.endpoint, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.endpoint, list("")), 0)}"
  }

  cluster_type_output_master_auth = {
    regional = "${concat(google_container_cluster.primary.*.master_auth, list())}"
    zonal    = "${concat(google_container_cluster.zonal_primary.*.master_auth, list())}"
  }

  cluster_type_output_master_version = {
    regional = "${element(concat(google_container_cluster.primary.*.master_version, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.master_version, list("")), 0)}"
  }

  cluster_type_output_min_master_version = {
    regional = "${element(concat(google_container_cluster.primary.*.min_master_version, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.min_master_version, list("")), 0)}"
  }

  cluster_type_output_logging_service = {
    regional = "${element(concat(google_container_cluster.primary.*.logging_service, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.logging_service, list("")), 0)}"
  }

  cluster_type_output_monitoring_service = {
    regional = "${element(concat(google_container_cluster.primary.*.monitoring_service, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.monitoring_service, list("")), 0)}"
  }

  cluster_type_output_network_policy_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.addons_config.0.network_policy_config.0.disabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.addons_config.0.network_policy_config.0.disabled, list("")), 0)}"
  }

  cluster_type_output_http_load_balancing_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.addons_config.0.http_load_balancing.0.disabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.addons_config.0.http_load_balancing.0.disabled, list("")), 0)}"
  }

  cluster_type_output_horizontal_pod_autoscaling_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.addons_config.0.horizontal_pod_autoscaling.0.disabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.addons_config.0.horizontal_pod_autoscaling.0.disabled, list("")), 0)}"
  }

  cluster_type_output_kubernetes_dashboard_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.addons_config.0.kubernetes_dashboard.0.disabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.addons_config.0.kubernetes_dashboard.0.disabled, list("")), 0)}"
  }

  # BETA features
  cluster_type_output_istio_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.addons_config.0.istio_config.0.disabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.addons_config.0.istio_config.0.disabled, list("")), 0)}"
  }

  cluster_type_output_cloudrun_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.addons_config.0.cloudrun_config.0.disabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.addons_config.0.cloudrun_config.0.disabled, list("")), 0)}"
  }

  cluster_type_output_pod_security_policy_enabled = {
    regional = "${element(concat(google_container_cluster.primary.*.pod_security_policy_config.0.enabled, list("")), 0)}"
    zonal    = "${element(concat(google_container_cluster.zonal_primary.*.pod_security_policy_config.0.enabled, list("")), 0)}"
  }

  # /BETA features

  cluster_type_output_node_pools_names = {
    regional = "${concat(google_container_node_pool.pools.*.name, list(""))}"
    zonal    = "${concat(google_container_node_pool.zonal_pools.*.name, list(""))}"
  }
  cluster_type_output_node_pools_versions = {
    regional = "${concat(google_container_node_pool.pools.*.version, list(""))}"
    zonal    = "${concat(google_container_node_pool.zonal_pools.*.version, list(""))}"
  }
  cluster_master_auth_list_layer1 = "${local.cluster_type_output_master_auth[local.cluster_type]}"
  cluster_master_auth_list_layer2 = "${local.cluster_master_auth_list_layer1[0]}"
  cluster_master_auth_map         = "${local.cluster_master_auth_list_layer2[0]}"
  # cluster locals
  cluster_name                               = "${local.cluster_type_output_name[local.cluster_type]}"
  cluster_location                           = "${local.cluster_type_output_location[local.cluster_type]}"
  cluster_region                             = "${local.cluster_type_output_region[local.cluster_type]}"
  cluster_zones                              = "${sort(local.cluster_type_output_zones[local.cluster_type])}"
  cluster_endpoint                           = "${local.cluster_type_output_endpoint[local.cluster_type]}"
  cluster_ca_certificate                     = "${lookup(local.cluster_master_auth_map, "cluster_ca_certificate")}"
  cluster_master_version                     = "${local.cluster_type_output_master_version[local.cluster_type]}"
  cluster_min_master_version                 = "${local.cluster_type_output_min_master_version[local.cluster_type]}"
  cluster_logging_service                    = "${local.cluster_type_output_logging_service[local.cluster_type]}"
  cluster_monitoring_service                 = "${local.cluster_type_output_monitoring_service[local.cluster_type]}"
  cluster_node_pools_names                   = "${local.cluster_type_output_node_pools_names[local.cluster_type]}"
  cluster_node_pools_versions                = "${local.cluster_type_output_node_pools_versions[local.cluster_type]}"
  cluster_network_policy_enabled             = "${local.cluster_type_output_network_policy_enabled[local.cluster_type] ? false : true}"
  cluster_http_load_balancing_enabled        = "${local.cluster_type_output_http_load_balancing_enabled[local.cluster_type] ? false : true}"
  cluster_horizontal_pod_autoscaling_enabled = "${local.cluster_type_output_horizontal_pod_autoscaling_enabled[local.cluster_type] ? false : true}"
  cluster_kubernetes_dashboard_enabled       = "${local.cluster_type_output_kubernetes_dashboard_enabled[local.cluster_type] ? false : true}"
  # BETA features
  cluster_istio_enabled    = "${local.cluster_type_output_istio_enabled[local.cluster_type] ? false : true}"
  cluster_cloudrun_enabled = "${local.cluster_type_output_cloudrun_enabled[local.cluster_type] ? false : true}"
  cluster_pod_security_policy_enabled = "${local.cluster_type_output_pod_security_policy_enabled[local.cluster_type] ? true : false}"

  # /BETA features
}

/******************************************
  Get available container engine versions
 *****************************************/
data "google_container_engine_versions" "region" {
  provider = "google-beta"
  region   = "${var.region}"
  project  = "${var.project_id}"
}

data "google_container_engine_versions" "zone" {
  // Work around to prevent a lack of zone declaration from causing regional cluster creation from erroring out due to error
  //
  //     data.google_container_engine_versions.zone: Cannot determine zone: set in this resource, or set provider-level zone.
  //
  zone = "${var.zones[0] == "" ? data.google_compute_zones.available.names[0] : var.zones[0]}"

  project = "${var.project_id}"
}
