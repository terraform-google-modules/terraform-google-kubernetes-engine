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

output "name" {
  description = "Cluster name"
  value       = "${local.cluster_name}"
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = "${local.cluster_type}"
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = "${local.cluster_location}"
}

output "region" {
  description = "Cluster region"
  value       = "${local.cluster_region}"
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = "${local.cluster_zones}"
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = "${local.cluster_endpoint}"
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = "${local.cluster_min_master_version}"
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = "${local.cluster_master_version}"
}

output "ca_certificate" {
  description = "Cluster ca certificate (base64 encoded)"
  value       = "${local.cluster_ca_certificate}"
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = "${local.cluster_network_policy_enabled}"
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = "${local.cluster_http_load_balancing_enabled}"
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = "${local.cluster_horizontal_pod_autoscaling_enabled}"
}

output "kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = "${local.cluster_kubernetes_dashboard_enabled}"
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = "${local.cluster_node_pools_names}"
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = "${local.cluster_node_pools_versions}"
}
