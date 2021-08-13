/**
 * Copyright 2019 Google LLC
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

output "location" {
  value = module.example.location
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.example.cluster_name
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
  value     = module.example.ca_certificate
  sensitive = true
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.example.service_account
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.example.network
}

output "subnet_name" {
  description = "The name of the subnet being created"
  value       = module.example.subnetwork
}

output "region" {
  description = "The region the cluster is hosted in"
  value       = module.example.region
}

output "ip_range_pods_name" {
  description = "The secondary range name for pods"
  value       = module.example.ip_range_pods_name
}

output "ip_range_services_name" {
  description = "The secondary range name for services"
  value       = module.example.ip_range_services_name
}
