/**
 * Copyright 2025 Google LLC
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

output "cluster_id" {
  description = "Cluster ID"
  value       = google_container_cluster.main.id
}

output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.main.name
  depends_on = [
    google_container_cluster.main
  ]
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = google_container_cluster.main.location
}

output "node_locations" {
  description = "The list of zones in which the cluster's nodes are located."
  value       = google_container_cluster.main.node_locations
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.main.private_cluster_config[0].private_endpoint
  depends_on = [
    google_container_cluster.main
  ]
}

output "endpoint_dns" {
  description = "Cluster endpoint DNS"
  value       = google_container_cluster.main.control_plane_endpoints_config[0].dns_endpoint_config[0].endpoint
  depends_on = [
    google_container_cluster.main
  ]
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = google_container_cluster.main.min_master_version
  depends_on = [
    google_container_cluster.main
  ]
}

output "logging_service" {
  description = "Logging service used"
  value       = google_container_cluster.main.logging_service
  depends_on = [
    google_container_cluster.main
  ]
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = google_container_cluster.main.monitoring_service
  depends_on = [
    google_container_cluster.main
  ]
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = google_container_cluster.main.master_version
  depends_on = [
    google_container_cluster.main
  ]
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = google_container_cluster.main.master_authorized_networks_config
  depends_on = [
    google_container_cluster.main
  ]
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = google_container_cluster.main.master_auth[0].cluster_ca_certificate
  depends_on = [
    google_container_cluster.main
  ]
}

output "addons_config" {
  description = "The configuration for addons supported by GKE Autopilot."
  value       = google_container_cluster.main.addons_config
}


output "vertical_pod_autoscaling_enabled" {
  description = "Whether vertical pod autoscaling enabled"
  value       = google_container_cluster.main.vertical_pod_autoscaling != null && length(google_container_cluster.main.vertical_pod_autoscaling) == 1 ? google_container_cluster.main.vertical_pod_autoscaling[0].enabled : false
}

output "identity_service_enabled" {
  description = "Whether Identity Service is enabled"
  value       = google_container_cluster.main.identity_service_config != null && length(google_container_cluster.main.identity_service_config) == 1 ? google_container_cluster.main.identity_service_config[0].enabled : false
}

output "intranode_visibility_enabled" {
  description = "Whether intra-node visibility is enabled"
  value       = google_container_cluster.main.enable_intranode_visibility
}

output "secret_manager_addon_enabled" {
  description = "Whether Secret Manager add-on is enabled"
  value       = google_container_cluster.main.secret_manager_config[0].enabled
}
