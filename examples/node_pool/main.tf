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
  cluster_type = "node-pool"
}

provider "google" {
  credentials = "${file(var.credentials_path)}"
  region      = "${var.region}"
}

module "gke" {
  source             = "../../"
  project_id         = "${var.project_id}"
  name               = "${local.cluster_type}-cluster"
  region             = "${var.region}"
  network            = "${var.network}"
  subnetwork         = "${var.subnetwork}"
  ip_range_pods      = "${var.ip_range_pods}"
  ip_range_services  = "${var.ip_range_services}"
  kubernetes_version = "1.11.5-gke.4"
  node_version       = "1.11.5-gke.4"

  node_pools = [
    {
      name            = "pool-01"
      min_count       = 1
      service_account = "${var.compute_engine_service_account}"
    },
    {
      name            = "pool-02"
      machine_type    = "n1-standard-2"
      min_count       = 1
      max_count       = 2
      disk_size_gb    = 30
      disk_type       = "pd-standard"
      image_type      = "COS"
      auto_repair     = false
      auto_upgrade    = false
      service_account = "${var.compute_engine_service_account}"
    },
  ]

  node_pools_labels = {
    all = {
      all-pools-example = "true"
    }

    pool-01 = {
      pool-01-example = "true"
    }

    pool-02 = {}
  }

  node_pools_taints = {
    all = [
      {
        key    = "all-pools-example"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    pool-01 = [
      {
        key    = "pool-01-example"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    pool-02 = []
  }

  node_pools_tags = {
    all = [
      "all-node-example",
    ]

    pool-01 = [
      "pool-01-example",
    ]

    pool-02 = []
  }
}

data "google_client_config" "default" {}
