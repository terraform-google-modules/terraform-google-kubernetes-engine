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

output "cluster_name" {
  description = "Cluster name"
  value       = module.example.cluster_name
}

output "location" {
  value = module.example.location
}

output "master_kubernetes_version" {
  description = "The master Kubernetes version"
  value       = module.example.master_kubernetes_version
}

output "kubernetes_endpoint" {
  value = module.example.kubernetes_endpoint
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
