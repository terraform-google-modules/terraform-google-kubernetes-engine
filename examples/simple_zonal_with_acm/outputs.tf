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

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

output "client_token" {
  sensitive = true
  value     = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  value     = module.gke.ca_certificate
  sensitive = true
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "acm_git_creds_public" {
  description = "Public key of SSH keypair to allow the Anthos Operator to authenticate to your Git repository."
  value       = module.acm.git_creds_public
}

# Standard test outputs
output "project_id" {
  value = var.project_id
}

output "region" {
  value = module.gke.region
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "network" {
  value = google_compute_network.main.name
}

output "subnetwork" {
  value = google_compute_subnetwork.main.name
}

output "location" {
  value = module.gke.location
}

output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = google_compute_subnetwork.main.secondary_ip_range[0].range_name
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = google_compute_subnetwork.main.secondary_ip_range[1].range_name
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}

output "master_kubernetes_version" {
  description = "The master Kubernetes version"
  value       = module.gke.master_version
}
