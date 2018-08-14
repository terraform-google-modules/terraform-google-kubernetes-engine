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

output "cluster_name" {
  description = "Cluster name"
  value       = "${google_container_cluster.primary.name}"
}

output "region" {
  description = "Cluster region"
  value       = "${google_container_cluster.primary.region}"
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = "${google_container_cluster.primary.endpoint}"
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = "${google_container_cluster.primary.min_master_version}"
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = "${google_container_cluster.primary.master_version}"
}

output "node_version" {
  description = "Current node kubernetes version"
  value       = "${google_container_cluster.primary.node_version}"
}

output "ca_certificate" {
  description = "Cluster ca certificate (base64 encoded)"
  value       = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = "${google_container_cluster.primary.addons_config.0.http_load_balancing.0.disabled ? false : true}"
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = "${google_container_cluster.primary.addons_config.0.horizontal_pod_autoscaling.0.disabled ? false : true}"
}

output "kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = "${google_container_cluster.primary.addons_config.0.kubernetes_dashboard.0.disabled ? false : true}"
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = "${google_container_node_pool.pools.*.name}"
}
