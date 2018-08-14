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

variable "region" {
  description = "The region to host the cluster in"
}

variable "credentials_path" {
  description = "Path to a Service Account credentials file with permissions documented in the readme"
}

variable "cluster_name" {
  description = "The name of the cluster"
}

variable "cluster_description" {
  description = "The description of the cluster"
  default     = ""
}

variable "network" {
  description = "The VPC network to host the cluster in"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "1.10.5-gke.0"
}

variable "node_version" {
  description = "The Kubernetes version of the node pools. Defaults kubernetes version (master) variable. Must set the same as master at initial creation."
  default     = ""
}

variable "horizontal_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "http_load_balancing" {
  description = "Enable httpload balancer addon"
  default     = false
}

variable "kubernetes_dashboard" {
  description = "Enable kubernetes dashboard addon"
  default     = true
}

variable "network_policy" {
  description = "Enable network policy addon"
  default     = false
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  default     = "05:00"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for pods"
}

variable "node_service_account" {
  description = "Service account to associate to the nodes. Defaults to the compute default service account on the project.)"
  default     = ""
}

variable "node_pools" {
  type        = "list"
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "node_pools_labels" {
  type        = "map"
  description = "Map of maps containing node labels by node-pool name"

  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "node_pools_taints" {
  type        = "map"
  description = "Map of lists containing node taints by node-pool name"

  default = {
    all               = []
    default-node-pool = []
  }
}

variable "node_pools_tags" {
  type        = "map"
  description = "Map of lists containing node network tags by node-pool name"

  default = {
    all               = []
    default-node-pool = []
  }
}

variable "stub_domains" {
  type        = "map"
  description = "Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server"
  default     = {}
}

variable "ip_masq_config_enabled" {
  description = "Enable IP Masquerade Agent Configmap. Automatically enables if network_policy enabled."
  default     = false
}

variable "ip_masq_non_masquerade_cidrs" {
  type        = "list"
  description = "List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading."
  default     = ["10.0.0.0/8"]
}

variable "ip_masq_resync_interval" {
  description = "The interval at which the agent attempts to sync its ConfigMap file from the disk."
  default     = "60s"
}

variable "ip_masq_link_local" {
  description = "Whether to masquerade traffic to the link-local prefix (169.254.0.0/16)."
  default     = "false"
}
