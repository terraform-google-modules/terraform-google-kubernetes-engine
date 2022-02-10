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

output "project_id" {
  value = module.example.project_id
}

output "region" {
  value = module.example.region
}

output "network" {
  value = google_compute_network.main.name
}

output "subnetwork" {
  value = google_compute_subnetwork.main.name
}

output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = google_compute_subnetwork.main.secondary_ip_range[0].range_name
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = google_compute_subnetwork.main.secondary_ip_range[1].range_name
}

output "location" {
  description = "Cluster location (zones)"
  value       = module.example.location
}

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.example.kubernetes_endpoint
}

output "client_token" {
  sensitive = true
  value     = module.example.client_token
}

output "ca_certificate" {
  description = "The cluster CA certificate"
  value       = module.example.ca_certificate
  sensitive   = true
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.example.service_account
}

output "registry_project_ids" {
  value = var.registry_project_ids
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.example.cluster_name
}

# Default instantiation of WI module
output "default_wi_email" {
  description = "GCP service account."
  value       = module.example.default_wi_email
}

output "default_wi_ksa_name" {
  description = "K8S GCP service account name."
  value       = module.example.default_wi_ksa_name
}

# Existing KSA instantiation of WI module
output "existing_ksa_email" {
  description = "GCP service account."
  value       = module.example.existing_ksa_email
}

output "existing_ksa_name" {
  description = "K8S GCP service name"
  value       = module.example.existing_ksa_name
}

# Existing GSA instantiation of WI module
output "existing_gsa_email" {
  description = "GCP service account."
  value       = module.example.existing_gsa_email
}

output "existing_gsa_name" {
  description = "K8S GCP service name"
  value       = module.example.existing_gsa_name
}

