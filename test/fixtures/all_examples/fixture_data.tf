data "terraform_remote_state" "fixtures" {
  backend = "local"

  config {
    path = "${path.module}/../../test/fixtures/all_examples/terraform.tfstate"
  }
}

locals {
  project_id = "${data.terraform_remote_state.fixtures.project_id}"
  credentials_path = "${data.terraform_remote_state.fixtures.credentials_path}"
  region = "${data.terraform_remote_state.fixtures.region}"
  network = "${data.terraform_remote_state.fixtures.network}"
  subnetwork = "${data.terraform_remote_state.fixtures.deploy_service-subnetwork}"
  ip_range_pods = "${data.terraform_remote_state.fixtures.deploy_service-ip_range_pods}"
  ip_range_services = "${data.terraform_remote_state.fixtures.deploy_service-ip_range_services}"
}
