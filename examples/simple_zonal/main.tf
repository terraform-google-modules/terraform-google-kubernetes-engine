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
  cluster_type = "simple-zonal"
}

provider "google" {
  credentials = "${file(local.credentials_path)}"
  region      = "${local.region}"
}

module "gke" {
  source            = "../../"
  project_id        = "${local.project_id}"
  name              = "${local.cluster_type}-cluster"
  regional          = false
  region            = "${local.region}"
  zones             = "${local.zones}"
  network           = "${local.network}"
  subnetwork        = "${local.subnetwork}"
  ip_range_pods     = "${local.ip_range_pods}"
  ip_range_services = "${local.ip_range_services}"
  kubernetes_version = "1.9.7-gke.11"
  node_version = "1.9.7-gke.11"
}
