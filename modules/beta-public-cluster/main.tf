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
  provider = google-beta

  project  = var.project_id
  region   = var.region
}

resource "random_shuffle" "available_zones" {
  input        = data.google_compute_zones.available.names
  result_count = 3
}

locals {

  location                    = var.regional ? var.region : var.zones[0]

  latest_kubernetes_version   = var.regional ? data.google_container_engine_versions.region.latest_master_version : data.google_container_engine_versions.zone.latest_master_version
  kubernetes_master_version      = var.kubernetes_version != "latest" ? var.kubernetes_version : local.latest_kubernetes_version
  kubernetes_node_version        = var.node_version != "" ? var.kubernetes_version : local.kubernetes_master_version

  custom_kube_dns_config      = length(keys(var.stub_domains)) > 0
  upstream_nameservers_config = length(var.upstream_nameservers) > 0
  network_project_id          = var.network_project_id != "" ? var.network_project_id : var.project_id
  zone_count                  = length(var.zones)
  cluster_type = var.regional ? "regional" : "zonal"
        
  cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
  }] : [{
    enabled = false
    provider = null
  }]

  cluster_cloudrun_config = var.cloudrun ? [{disabled = false}] : []

  cluster_node_metadata_config = var.node_metadata == "UNSPECIFIED" ? [] : [{
    node_metadata = var.node_metadata
  }]


  cluster_output_name = element(concat(google_container_cluster.primary.*.name, [""]), 0)
  cluster_output_location = element(concat(google_container_cluster.primary.*.location, [""]), 0)
  cluster_output_region = element(concat(google_container_cluster.primary.*.region, [""]), 0)
  cluster_output_regional_zones = flatten(google_container_cluster.primary.*.node_locations)
  cluster_output_zonal_zones    = local.zone_count > 1 ? slice(var.zones, 1, local.zone_count) : []
  cluster_output_zones = local.cluster_output_regional_zones

  cluster_output_endpoint = element(concat(google_container_cluster.primary.*.endpoint, [""]), 0)

  cluster_output_master_auth = concat(google_container_cluster.primary.*.master_auth, [])
  cluster_output_master_version = element(concat(google_container_cluster.primary.*.master_version, [""]), 0,)
  cluster_output_min_master_version = element(concat(google_container_cluster.primary.*.min_master_version, [""]), 0, )
  cluster_output_logging_service = element(concat(google_container_cluster.primary.*.logging_service, [""]), 0, )
  cluster_output_monitoring_service = element(concat(google_container_cluster.primary.*.monitoring_service, [""]), 0, )
  cluster_output_network_policy_enabled = element(concat(google_container_cluster.primary.*.addons_config.0.network_policy_config.0.disabled, [""]), 0, )
  cluster_output_http_load_balancing_enabled = element(concat(google_container_cluster.primary.*.addons_config.0.http_load_balancing.0.disabled, [""], ), 0, )
  cluster_output_horizontal_pod_autoscaling_enabled = element(concat(google_container_cluster.primary.*.addons_config.0.horizontal_pod_autoscaling.0.disabled,[""],),0,)
  cluster_output_kubernetes_dashboard_enabled = element(concat(google_container_cluster.primary.*.addons_config.0.kubernetes_dashboard.0.disabled, [""],),0,)

  # BETA features
  cluster_output_istio_enabled = element(concat(google_container_cluster.primary.*.addons_config.0.istio_config.0.disabled, [""]), 0)
  cluster_output_pod_security_policy_enabled = element(concat(google_container_cluster.primary.*.pod_security_policy_config.0.enabled, [""]), 0)
  cluster_output_intranode_visbility_enabled =  element(concat(google_container_cluster.primary.*.enable_intranode_visibility, [""]), 0)
  cluster_output_vertical_pod_autoscaling_enabled = element(concat(google_container_cluster.primary.*.vertical_pod_autoscaling.0.enabled, [""]), 0)

  # /BETA features

  cluster_output_node_pools_names =  concat(google_container_node_pool.pools.*.name, [""])
  cluster_output_node_pools_versions = concat(google_container_node_pool.pools.*.version, [""])

  cluster_master_auth_list_layer1 = local.cluster_output_master_auth
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]
  # cluster locals
  cluster_name                               = local.cluster_output_name
  cluster_location                           = local.cluster_output_location
  cluster_region                             = local.cluster_output_region
  cluster_zones                              = sort(local.cluster_output_zones)
  cluster_endpoint                           = local.cluster_output_endpoint
  cluster_ca_certificate                     = local.cluster_master_auth_map["cluster_ca_certificate"]
  cluster_master_version                     = local.cluster_output_master_version
  cluster_min_master_version                 = local.cluster_output_min_master_version
  cluster_logging_service                    = local.cluster_output_logging_service
  cluster_monitoring_service                 = local.cluster_output_monitoring_service
  cluster_node_pools_names                   = local.cluster_output_node_pools_names
  cluster_node_pools_versions                = local.cluster_output_node_pools_versions
  cluster_network_policy_enabled             = !local.cluster_output_network_policy_enabled
  cluster_http_load_balancing_enabled        = !local.cluster_output_http_load_balancing_enabled
  cluster_horizontal_pod_autoscaling_enabled = !local.cluster_output_horizontal_pod_autoscaling_enabled
  cluster_kubernetes_dashboard_enabled       = !local.cluster_output_kubernetes_dashboard_enabled
  # BETA features
  cluster_istio_enabled                     = !local.cluster_output_istio_enabled
  cluster_cloudrun_enabled                  = var.cloudrun
  cluster_pod_security_policy_enabled       = local.cluster_output_pod_security_policy_enabled
  cluster_intranode_visibility_enabled      = local.cluster_output_intranode_visbility_enabled
  cluster_vertical_pod_autoscaling_enabled  = local.cluster_output_vertical_pod_autoscaling_enabled
  # /BETA features
}

/******************************************
  Get available container engine versions
 *****************************************/
data "google_container_engine_versions" "region" {
  provider = google-beta
  region   = var.region
  project  = var.project_id
}

data "google_container_engine_versions" "zone" {
  // Work around to prevent a lack of zone declaration from causing regional cluster creation from erroring out due to error
  //
  //     data.google_container_engine_versions.zone: Cannot determine zone: set in this resource, or set provider-level zone.
  //
  zone = local.zone_count == 0 ? data.google_compute_zones.available.names[0] : var.zones[0]

  project = var.project_id
}
