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

{{ autogeneration_note }}

variable "project_id" {
  description = "The project ID to host the cluster in (required)"
}

variable "name" {
  description = "The name of the cluster (required)"
}

variable "description" {
  description = "The description of the cluster"
  default     = ""
}

variable "regional" {
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "region" {
  description = "The region to host the cluster in (required)"
}

variable "zones" {
  type        = "list"
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = [""]
}

variable "network" {
  description = "The VPC network to host the cluster in (required)"
}

variable "network_project_id" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = ""
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in (required)"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "node_version" {
  description = "The Kubernetes version of the node pools. Defaults kubernetes_version (master) variable and can be overridden for individual node pools by setting the `version` key on them. Must be empyty or set the same as master at cluster creation."
  default     = ""
}

variable "master_authorized_networks_config" {
  type = "list"

  description = <<EOF
  The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)

  ### example format ###
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "example_network"
    }],
  }]

  EOF

  default = []
}

variable "horizontal_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "http_load_balancing" {
  description = "Enable httpload balancer addon"
  default     = true
}

variable "kubernetes_dashboard" {
  description = "Enable kubernetes dashboard addon"
  default     = false
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
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "remove_default_node_pool" {
  description = "Remove default node pool while setting up the cluster"
  default     = false
}

variable "disable_legacy_metadata_endpoints" {
  description = "Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated."
  default     = "true"
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

variable "node_pools_metadata" {
  type        = "map"
  description = "Map of maps containing node metadata by node-pool name"

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

variable "node_pools_oauth_scopes" {
  type        = "map"
  description = "Map of lists containing node oauth scopes by node-pool name"

  default = {
    all               = ["https://www.googleapis.com/auth/cloud-platform"]
    default-node-pool = []
  }
}

variable "stub_domains" {
  type        = "map"
  description = "Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server"
  default     = {}
}

variable "non_masquerade_cidrs" {
  type        = "list"
  description = "List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading."
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "ip_masq_resync_interval" {
  description = "The interval at which the agent attempts to sync its ConfigMap file from the disk."
  default     = "60s"
}

variable "ip_masq_link_local" {
  description = "Whether to masquerade traffic to the link-local prefix (169.254.0.0/16)."
  default     = "false"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com"
}

variable "service_account" {
  description = "The service account to run nodes as if not overridden in `node_pools`. The default value will cause a cluster-specific service account to be created."
  default     = "create"
}
{% if private_cluster %}

variable "deploy_using_private_endpoint" {
  description = "(Beta) A toggle for Terraform and kubectl to connect to the master's internal IP address during deployment."
  default     = "false"
}

variable "enable_private_endpoint" {
  description = "(Beta) Whether the master's internal IP address is used as the cluster endpoint"
  default     = false
}

variable "enable_private_nodes" {
  description = "(Beta) Whether nodes have internal IP addresses only"
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "(Beta) The IP range in CIDR notation to use for the hosted master network"
  default     = "10.0.0.0/28"
}
{% endif %}

variable "basic_auth_username" {
  description = "The username to be used with Basic Authentication. An empty value will disable Basic Authentication, which is the recommended configuration."
  default     = ""
}

variable "basic_auth_password" {
  description = "The password to be used with Basic Authentication."
  default     = ""
}

variable "issue_client_certificate" {
  description = "Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive!"
  default     = "false"
}
