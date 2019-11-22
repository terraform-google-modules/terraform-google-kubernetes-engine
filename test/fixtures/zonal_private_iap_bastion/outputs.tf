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

output "cluster_name" {
  description = "Cluster name"
  value       = module.example.cluster_name
}

output "bastion_name" {
  description = "Name of bastion host"
  value       = module.example.bastion_name
}

output "bastion_zone" {
  description = "Location of bastion host"
  value       = module.example.bastion_zone
}

output "project_id" {
  value = var.project_id
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = module.example.type
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.example.location
}

output "region" {
  description = "Subnet/Router region"
  value       = module.example.region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.example.zones
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.example.endpoint
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = module.example.min_master_version
}

output "logging_service" {
  description = "Logging service used"
  value       = module.example.logging_service
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = module.example.monitoring_service
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.example.master_authorized_networks_config
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.example.master_version
}

output "router_name" {
  description = "Name of the router that was created"
  value       = module.example.router_name
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.example.ca_certificate
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.example.network_policy_enabled
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.example.http_load_balancing_enabled
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.example.horizontal_pod_autoscaling_enabled
}

output "kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = module.example.kubernetes_dashboard_enabled
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = module.example.node_pools_names
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = module.example.node_pools_versions
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.example.service_account
}

output "subnet_name" {
  value       = module.example.subnet_name
  description = "The name of the VPC subnet being created"
}

output "network_name" {
  value       = module.example.network_name
  description = "The name of the VPC being created"
}

output "get_credentials" {
  description = "Gcloud get-credentials command"
  value       = module.example.get_credentials
}

output "bastion_ssh" {
  description = "Gcloud compute ssh to the bastion host command"
  value       = module.example.bastion_ssh
}

output "bastion_kubectl" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = module.example.bastion_kubectl
}
