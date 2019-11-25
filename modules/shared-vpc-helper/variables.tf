
variable "gke_svpc_host_project" {
  type        = string
  description = "The project ID of the shared VPC's host"
}

variable "gke_svpc_service_project" {
  type        = string
  description = "The project ID of the service account (to host the GKE cluster in)"
}

variable "enable_shared_vpc_helper" {
  type        = bool
  description = "Trigger if this submofule should be enabled. If false all resourcess creation will be skipped"
}

variable "gke_subnetwork" {
  type        = string
  description = "The host account subnetwork to share with service account (to host the GKE cluster in)"
}

variable "region" {
  type        = string
  description = "The region of subnets to share (to host the cluster in)"
}

variable "gke_sa" {
  type        = string
  description = "The service account in a service project to run GKE cluster nodes"
}