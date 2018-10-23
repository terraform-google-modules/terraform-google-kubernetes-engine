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
  value = "${var.project_id}"
}

output "region" {
  value = "${var.region}"
}

output "cluster_name" {
  description = "Cluster name"
  value       = "${module.gke.name}"
}

output "network" {
  description = "Network the cluster is provisioned in"
  value       = "${var.network}"
}

output "subnetwork" {
  description = "Subnetwork the cluster is provisioned in"
  value       = "${var.subnetwork}"
}

output "kubernetes_endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = "${module.gke.endpoint}"
}

output "client_token" {
  sensitive = true
  value     = "${base64encode(data.google_client_config.default.access_token)}"
}

output "location" {
  description = "Cluster location"
  value       = "${module.gke.location}"
}

output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = "${var.ip_range_pods}"
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = "${var.ip_range_services}"
}

output "master_kubernetes_version" {
  description = "The master Kubernetes version"
  value       = "${module.gke.master_version}"
}
