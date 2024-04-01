variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_locations" {
  type = list(string)
}

variable "subnet_cidr" {
  type = string
}

variable "psc_subnet_cidr" {
  type = string
}

variable "proxy_subnet_cidr" {
  type = string
}

variable "secondary_ranges" {
  type = map(string)
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
}

variable "primary_subnet" {
  type = string
}

variable "primary_net_cidrs" {
  type = list(string)
}

variable "router_machine_type" {
  type = string
}
