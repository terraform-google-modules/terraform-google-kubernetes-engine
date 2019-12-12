
/* Create Shared VPC host and service projects to test shared-vpc-helper submodule.
Only compute.googleapis.com is enabled. All others needed resourcess will provided by the submodule.
*/
module "gke_svpc_host_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name              = "ci-gke-svpc-host"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_gke_folder.id
  billing_account   = var.billing_account

  auto_create_network = false

  activate_apis = [
    "compute.googleapis.com"
  ]
}


// Enables the Shared VPC feature for a created project, assigning it as a Shared VPC host project.

//resource "google_compute_shared_vpc_host_project" "gke_svpc_host_project" {
//  depends_on = [
//    module.gke_svpc_host_project
//  ]
//  project = module.gke_svpc_host_project.project_id
//}


// Just to enable shared vpc host feature for the project instead of "google_compute_shared_vpc_host_project"
module "gke_cluster_svpc_network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 1.5.0"
  project_id   = module.gke_svpc_host_project.project_id
  network_name = "dummy-svpc-network"
  shared_vpc_host = true

  subnets = [
    {
      subnet_name   = "gke-svpc-dummy-${random_id.folder_rand.hex}"
      subnet_ip     = "10.200.0.0/24"
      subnet_region = "us-west1"
    },
  ]

  secondary_ranges = {}
}

module "service_project" {
  source  = "terraform-google-modules/project-factory/google//modules/shared_vpc"
  name              = "svpc-service"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_gke_folder.id
  billing_account   = var.billing_account
  shared_vpc        = module.gke_cluster_svpc_network.svpc_host_project_id
  auto_create_network = false

  activate_apis = [
    "compute.googleapis.com"
  ]
}