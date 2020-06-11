/**
 * Copyright 2020 Google LLC
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
  type        = string
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "safer-cluster-iap-bastion"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"

}

variable "network_name" {
  type        = string
  description = "The name of the network being created to host the cluster in"
  default     = "safer-cluster-network"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet being created to host the cluster in"
  default     = "safer-cluster-subnet"
}

variable "subnet_ip" {
  type        = string
  description = "The cidr range of the subnet"
  default     = "10.10.10.0/24"
}

variable "ip_range_pods_name" {
  type        = string
  description = "The secondary ip range to use for pods"

  default = "ip-range-pods"
}

variable "ip_range_services_name" {
  type        = string
  description = "The secondary ip range to use for pods"

  default = "ip-range-svc"
}

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}

variable "ip_source_ranges_ssh" {
  type        = list(string)
  description = "Additional source ranges to allow for ssh to bastion host. 35.235.240.0/20 allowed by default for IAP tunnel."
  default     = []
}
