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

locals {
  credentials_file_path = "${path.module}/sa-key.json"
}

provider "google" {
  credentials = "${file(local.credentials_file_path)}"
}

module "gke" {
  source            = "../../"
  project_id        = "${var.project_id}"
  name              = "stub-domains-cluster"
  region            = "${var.region}"
  network           = "${var.network}"
  subnetwork        = "${var.subnetwork}"
  ip_range_pods     = "${var.ip_range_pods}"
  ip_range_services = "${var.ip_range_services}"
  kubernetes_version = "1.9.7-gke.11"
  node_version = "1.9.7-gke.11"

  stub_domains {
    "example.com" = [
      "10.254.154.11",
      "10.254.154.12",
    ]

    "example.net" = [
      "10.254.154.11",
      "10.254.154.12",
    ]
  }
}
