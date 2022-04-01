module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 12.0"

  project_id = var.project_id

  activate_apis = [
    "container.googleapis.com",
    "anthos.googleapis.com",
    "connectgateway.googleapis.com"
  ]
}
