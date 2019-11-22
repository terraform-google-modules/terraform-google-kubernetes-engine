variable "region" {
}
//
//variable "billing_account" {}
//
//variable "org_id" {}

variable "gke_shared_host_project" {}
variable "gke_service_project" {}
variable "enable_shared_vpc_helper" {
}

variable "gke_subnetwork" {}
variable "gke_sa" {
  description = "sa for gke cluster"
}