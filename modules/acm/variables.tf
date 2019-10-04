variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
}

variable "project_id" {
  description = "The project in which the resource belongs."
  type        = string
}

variable "location" {
  description = "The location (zone or region) this cluster has been created in. One of location, region, zone, or a provider-level zone must be specified."
  type        = string
}

variable "sync_repo" {
  description = "Anthos config management Git repo"
  type        = string
}

variable "sync_branch" {
  description = "Anthos config management Git branch"
  type        = string
  default     = "master"
}

variable "policy_dir" {
  description = "Subfolder containing configs in Ahtons config management Git repo"
  type        = string
}