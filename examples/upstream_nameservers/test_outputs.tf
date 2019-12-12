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

// These outputs are used to test the module with kitchen-terraform
// They do not need to be included in real-world uses of this module

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
  value = var.network
}

output "subnetwork" {
  value = var.subnetwork
}

output "location" {
  value = module.gke.location
}

output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = var.ip_range_pods
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = var.ip_range_services
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}

output "master_kubernetes_version" {
  description = "The master Kubernetes version"
  value       = module.gke.master_version
}

