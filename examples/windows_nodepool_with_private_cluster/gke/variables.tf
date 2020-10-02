variable "project" {}

variable "region" {}

variable "network" {}

variable "cluster_name" {
   default= ""
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "subnetwork" {
  default = ""
}

variable "gke_cluster_min_master_version" {
  default = "1.16.8-gke.15"
}
variable "master_ipv4_cidr_block" {
  default= ""
}
variable "regional"{
  default=false
}

# variable "image_type" {
#   default = "COS"
# }

variable "machine_type" {
  default = "n1-standard-1"
}

variable "node_count" {
  default = 1
}

# variable "preemptible" {
#   default = false
# }

# variable "enable_autoscaling" {
#   default = false
# }
# variable "auto_repair" {
#   default = true
# }
# variable "auto_upgrade" {
#   default = false
# }
# variable "min_node_count" {
#   default = 1
# }

# variable "max_node_count" {
#   default = 3
# }

variable "service_account" {
  default = ""
}

# variable "kubernetes_labels" {
#   default = ""
# }

variable "gce_labels" {
  default = ""
}

# variable "disk_type" {
#   default = ""
# }

# variable "disk_size_gb" {
#   default = ""
# }

variable "gke_cluster_master_version" {
  default= ""
}

variable "master_authorized_networks" {
  default = []
}
variable "node_pool_01" {
  description = "The configuration for Node pool 1"
}
variable "node_pool_02" {
  description = "The configuration for Node pool 2"
}