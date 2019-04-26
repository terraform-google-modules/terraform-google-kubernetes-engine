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
  description = "Cluster name."
  value       = "${var.name}"
}

output "cluster_type" {
  description = "Type of cluster created (public/private)."
  value       = "${local.cluster_type}"
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = "${local.location}"
}

output "region" {
  description = "Cluster region."
  value       = "${var.region}"
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = "${local.cluster_zones}"
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = "${local.cluster_endpoint}"
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = "${local.cluster_min_master_version}"
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = "${var.master_authorized_networks_config}"
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = "${local.cluster_master_version}"
}

output "ca_certificate" {
  sensitive   = true
  description = "Base64 encoded public certificate that is the root of trust for the cluster."
  value       = "${local.cluster_ca_certificate}"
}

output "cluster_location" {
  description = "Location of the cluster."
  value       = "${local.cluster_location}"
}

output "client_certificate" {
  sensitive   = true
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster endpoint."
  value       = "${local.cluster_client_certificate}"
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the cluster endpoint."
  value       = "${local.cluster_client_key}"
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

output "logging_service" {
  description = "Logging service used by the cluster."
  value       = "${local.cluster_logging_service}"
}

output "monitoring_service" {
  description = "Monitoring service used by the cluster."
  value       = "${local.cluster_monitoring_service}"
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = "${local.service_account}"
}
