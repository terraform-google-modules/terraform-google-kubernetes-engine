module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.project
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com"
  ]
}

resource "random_id" "rand" {
  byte_length = 4
}

module "gke" {
  source                = "terraform-google-modules/kubernetes-engine/google"
  project_id            = var.project
  name                  = "sfl-acm-${random_id.rand.hex}"
  region                = var.region
  zones                 = [var.zone]
  initial_node_count    = 4
  network               = "default"
  subnetwork            = "default"
  ip_range_pods         = ""
  ip_range_services     = ""
  depends_on = [module.enabled_google_apis]
}