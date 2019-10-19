
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
locals {
  network = "gke-network-${random_string.suffix.result}"
  subnetwork = "gke-subnetwork-${random_string.suffix.result}"
  ip_range_pods="gke-ip-range-pods-${random_string.suffix.result}"
  ip_range_services="gke-ip-range-svc-${random_string.suffix.result}"
}
module "example" {
  source = "../../../examples/simple_regional_with_networking"

  project_id                     = var.project_id
  cluster_name_suffix            = "-${random_string.suffix.result}"
  region                         = var.region
  network                        = local.network
  subnetwork                     = local.subnetwork
  ip_range_pods                  = local.ip_range_pods
  ip_range_services              = local.ip_range_services
  compute_engine_service_account = var.compute_engine_service_account
}