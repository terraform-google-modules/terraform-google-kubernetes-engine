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
  value       = var.svpc_service_project_id
  description = "The project ID the cluster is created in"
}

output "project_number" {
  value       = data.google_project.svpc_service_project.number
  description = "The project number the cluster is created in"
}

output "host_project_id" {
  value       = var.svpc_host_project_id
  description = "The project ID of the shared VPC's host"
}

output "host_project_number" {
  value       = data.google_project.svpc_host_project.number
  description = "The project number of the shared VPC's host"
}

output "region" {
  value       = module.gke.region
  description = "The region the cluster is hosted in"
}

output "network" {
  value       = module.gke_cluster_svpc_network.network_name
  description = "The Shared VPC host project network the cluster is hosted in"

}

output "subnetwork" {
  value       = module.gke_cluster_svpc_network.subnets_names[0]
  description = "The subnet the cluster is hosted in"
}

output "location" {
  value       = module.gke.location
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
}

output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = local.pods_gke_subnet
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = local.services_gke_subnet
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}

output "master_kubernetes_version" {
  description = "The master Kubernetes version"
  value       = module.gke.master_version
}




