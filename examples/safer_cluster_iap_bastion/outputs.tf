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
  value       = module.gke.name
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke.location
}

output "region" {
  description = "Subnet/Router/Bastion Host region"
  value       = var.region
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}

output "endpoint_dns" {
  sensitive   = true
  description = "Cluster endpoint DNS"
  value       = module.gke.endpoint_dns
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.gke.master_authorized_networks_config
}

output "router_name" {
  description = "Name of the router that was created"
  value       = module.cloud-nat.router_name
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "subnet_name" {
  value       = module.vpc.subnets_names[0]
  description = "The name of the VPC subnet being created"
}

output "get_credentials_command" {
  description = "gcloud get-credentials command to generate kubeconfig for the private cluster"
  value       = format("gcloud container clusters get-credentials --project %s --zone %s --internal-ip %s", var.project_id, module.gke.location, module.gke.name)
}

output "bastion_name" {
  description = "Name of the bastion host"
  value       = module.bastion.hostname
}

output "bastion_zone" {
  description = "Location of bastion host"
  value       = local.bastion_zone
}

output "bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = format("gcloud beta compute ssh %s --tunnel-through-iap --project %s --zone %s -- -L8888:127.0.0.1:8888", module.bastion.hostname, var.project_id, local.bastion_zone)
}

output "bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces"
}

output "keyring" {
  description = "The name of the keyring."
  value       = module.kms.keyring
}

output "keyring_resource" {
  description = "The location of the keyring."
  value       = module.kms.keyring_resource
}

output "keys" {
  description = "Map of key name => key self link."
  value       = module.kms.keys
}
