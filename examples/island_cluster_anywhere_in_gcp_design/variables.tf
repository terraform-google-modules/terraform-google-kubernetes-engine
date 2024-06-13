/**
 * Copyright 2024 Google LLC
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

variable "region" {
  type = string
}

variable "node_locations" {
  type = list(string)
}

variable "subnet_cidr" {
  type        = string
  description = "Primary subnet CIDR used by the cluster."
}

variable "net_attachment_subnet_cidr" {
  type        = string
  description = "Subnet for the router PSC interface network attachment in island network."
}

variable "ingress_ip_addrs_subnet_cidr" {
  type        = string
  description = "Subnet to use for reserving internal ip addresses for the ILBs."
}

variable "proxy_subnet_cidr" {
  type        = string
  description = "CIDR for the regional managed proxy subnet."
}

variable "secondary_ranges" {
  type = map(string)
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
}

variable "primary_net_name" {
  type        = string
  description = "Primary VPC network name."
}

variable "ncc_hub_project_id" {
  type = string
}

variable "ncc_hub_name" {
  type = string
}

variable "router_machine_type" {
  type = string
}

variable "primary_subnet" {
  type        = string
  description = "Subnet to use in primary network to deploy the router."
}

variable "gke_spokes" {
  type = any
}
