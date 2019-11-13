/*
Copyright 2019 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

output "cluster_name" {
  description = "Cluster name"
  value       = "${module.gke.name}"
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = "${module.gke.type}"
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = "${module.gke.location}"
}

output "region" {
  description = "Cluster region"
  value       = "${module.gke.region}"
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = "${module.gke.zones}"
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = "${module.gke.endpoint}"
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = "${module.gke.min_master_version}"
}

output "logging_service" {
  description = "Logging service used"
  value       = "${module.gke.logging_service}"
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = "${module.gke.monitoring_service}"
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = "${module.gke.master_authorized_networks_config}"
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = "${module.gke.master_version}"
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = "${module.gke.ca_certificate}"
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = "${module.gke.network_policy_enabled}"
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = "${module.gke.http_load_balancing_enabled}"
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = "${module.gke.horizontal_pod_autoscaling_enabled}"
}

output "kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = "${module.gke.kubernetes_dashboard_enabled}"
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = "${module.gke.node_pools_names}"
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = "${module.gke.node_pools_versions}"
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = "${module.gke.service_account}"
}

output "network_name" {
  value       = "${module.gke-network.network_name}"
  description = "The name of the VPC being created"
}

output "get_credentials" {
  description = "Gcloud get-credentials command"
  value       = format("gcloud container clusters get-credentials --project %s --zone %s --internal-ip %s", var.project_id, module.gke.location, var.cluster_name)
}

output "bastion_ssh" {
  description = "Gcloud compute ssh to the bastion host command"
  value       = format("gcloud beta compute ssh %s --tunnel-through-iap --project %s --zone %s -- -L8888:127.0.0.1:8888", module.bastion.hostname, var.project_id, local.bastion_zone)
}

output "bastion_kubectl" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces"
}