data "terraform_remote_state" "fixtures" {
  backend = "local"

  config {
    path = "${path.module}/../../test/fixtures/networks/terraform.tfstate"
  }
}

data "google_compute_zones" "fixtures-available" {
  project = "${data.terraform_remote_state.fixtures.project_id}"
  region = "${data.terraform_remote_state.fixtures.region}"
}

locals {
  project_id = "${data.terraform_remote_state.fixtures.project_id}"
  credentials_path = "${data.terraform_remote_state.fixtures.credentials_path}"
  region = "${data.terraform_remote_state.fixtures.region}"
  network = "${data.terraform_remote_state.fixtures.network}"
  subnetwork = "${data.terraform_remote_state.fixtures.subnetwork[local.cluster_type]}"
  ip_range_pods = "${data.terraform_remote_state.fixtures.ip_range_pods[local.cluster_type]}"
  ip_range_services = "${data.terraform_remote_state.fixtures.ip_range_services[local.cluster_type]}"
  zones = ["${data.google_compute_zones.fixtures-available.names}"]
  pool_01_service_account = ""
}
