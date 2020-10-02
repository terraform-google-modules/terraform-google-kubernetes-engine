variable "project_id" {}
variable "node_pool_name" {}
variable "region" {}
variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}
variable "gke_cluster_name" {}
variable "gke_cluster_min_master_version" {
  default = "1.16.8-gke.15"
}

variable "regional" {
  default = "false"
}
variable "auto_repair" {
  default = "true"
}

variable "auto_upgrade" {
  default = "false"
}
variable "enable_autoscaling" {
  default = "false"
}
variable "max_pods_per_node" {
  default = "100"
}

variable "node_count" {
  default = "1"
}
variable "initial_node_count" {
  default = "1"
}

variable "min_node_count" {
  default = "1"
}
variable "max_node_count" {
  default = "3"
}

variable "image_type" {
  default = "COS"
}

variable "machine_type" {
  default = "n1-standard-1"
}
variable "local_ssd_count" {
  default = "0"
}

variable "disk_size_gb" {
  default = "100"
}

variable "disk_type" {
  default = "pd-standard"
}

variable "preemptible" {
  default = "false"
}

####
variable "enable_secure_boot" {
  default = "false"
}

variable "enable_integrity_monitoring" {
  default = "false"
}

variable "labels" {
  default = ""
}

variable "service_account" {
  default = ""
}
