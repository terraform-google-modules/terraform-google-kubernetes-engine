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
  value = module.gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "region" {
  description = "Cluster region"
  value       = module.gke.region
}

output "location" {
  description = "Cluster location (zones)"
  value       = module.gke.location
}

output "project_id" {
  description = "Project id where GKE cluster is created."
  value       = var.project_id
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "k8s_service_account_email" {
  description = "K8S GCP service account."
  value       = module.workload_identity.gcp_service_account_email
}

output "k8s_service_account_name" {
  description = "K8S GCP service name"
  value       = module.workload_identity.gcp_service_account_name
}
