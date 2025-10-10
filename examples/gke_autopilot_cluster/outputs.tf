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

output "endpoint" {
  sensitive   = true
  description = "The cluster endpoint"
  value       = module.gke.endpoint
}

output "ca_certificate" {
  sensitive   = true
  description = "The cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}

output "project_id" {
  description = "The project ID the cluster is in"
  value       = var.project_id
}

output "location" {
  description = "Cluster location"
  value       = module.gke.location
}

output "node_locations" {
  description = "Cluster node locations"
  value       = module.gke.node_locations
}

output "addons_config" {
  description = "The configuration for addons supported by GKE Autopilot."
  value       = module.gke.addons_config
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.cluster_name
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.gcp-network.network_name
}

output "subnets_names" {
  description = "The names of the subnet being created"
  value       = module.gcp-network.subnets_names
}

output "master_version" {
  description = "The master Kubernetes version"
  value       = module.gke.master_version
}
