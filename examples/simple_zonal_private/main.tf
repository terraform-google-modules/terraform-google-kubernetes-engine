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

provider "google-beta" {
  credentials = "${file(var.credentials_path)}"
  region      = "${var.region}"
}

module "gke" {
  source            = "../../"
  project_id        = "${var.project_id}"
  name              = "simple-zonal-cluster-private"
  regional          = false
  region            = "${var.region}"
  zones             = "${var.zones}"
  network           = "${var.network}"
  subnetwork        = "${var.subnetwork}"
  ip_range_pods     = "${var.ip_range_pods}"
  ip_range_services = "${var.ip_range_services}"
  private           = true
  private_cluster_config_enable_private_endpoint = true
  private_cluster_config_enable_private_nodes = true
  private_cluster_config_master_ipv4_cidr_block  = "172.16.0.16/28"
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block = "10.0.0.0/8"
      display_name = "VPC"
    }]
  }]
}

data "google_client_config" "default" {
  provider = "google-beta"
}
