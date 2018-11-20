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
  value = "${local.project_id}"
}

output "credentials_path" {
  value = "${local.credentials_path}"
}

output "region" {
  value = "${module.gke.region}"
}

output "cluster_name" {
  description = "Cluster name"
  value       = "${module.gke.name}"
}

output "network" {
  value = "${local.network}"
}

output "subnetwork" {
  value = "${local.subnetwork}"
}

output "kubernetes_endpoint" {
  sensitive = true
  value     = "${module.gke.endpoint}"
}

output "client_token" {
  sensitive = true
  value     = "${base64encode(data.google_client_config.default.access_token)}"
}

output "ca_certificate" {
  sensitive = true
  value     = "${module.gke.ca_certificate}"
}

output "location" {
  description = "Cluster location"
  value       = "${module.gke.location}"
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = "${module.gke.zones}"
}

output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = "${local.ip_range_pods}"
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = "${local.ip_range_services}"
}
