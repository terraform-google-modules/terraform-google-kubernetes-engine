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

variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "network" {
  description = "The VPC network to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default     = "gke-subnet"
}
variable "subnetwork_cidr" {
  description = "The cidr block for the subnetwork to host the cluster in"
  default     = "10.0.0.0/17"
}
variable "master_auth_subnetwork_cidr" {
  description = "The cidr block for the subnetwork that has access to cluster master"
  default     = "10.60.0.0/17"
}
variable "master_auth_subnetwork" {
  description = "The subnetwork that has access to cluster master"
  default     = "master-auth-subnet"
}
variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-scv"
}
variable "istio" {
  description = "Boolean to enable / disable Istio"
  default     = true
}

variable "cloudrun" {
  description = "Boolean to enable / disable CloudRun"
  default     = true
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network"
  default     = "172.16.0.0/28"
}

variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
}
