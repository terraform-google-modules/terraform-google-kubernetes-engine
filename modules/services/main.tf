module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "2.1.3"

  project_id                  = "morgantep-gke-test-project"

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com"
  ]
}
