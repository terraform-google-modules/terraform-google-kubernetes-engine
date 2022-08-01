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
  cluster_type = "upstream-nameservers"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                 = "../../"
  project_id             = var.project_id
  name                   = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                 = var.region
  network                = google_compute_network.main.name
  subnetwork             = google_compute_subnetwork.main.name
  ip_range_pods          = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services      = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  create_service_account = false
  service_account        = var.compute_engine_service_account

  configure_ip_masq    = true
  upstream_nameservers = ["8.8.8.8", "8.8.4.4"]
}
