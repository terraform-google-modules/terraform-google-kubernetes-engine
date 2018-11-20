/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
