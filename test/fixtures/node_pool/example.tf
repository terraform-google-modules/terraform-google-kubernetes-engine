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
  compute_engine_service_account = var.compute_engine_service_accounts[0]
}

module "example" {
  source = "../../../examples/node_pool"

  project_id                     = var.project_ids[0]
  cluster_name_suffix            = "-${random_string.suffix.result}"
  region                         = "europe-west4"
  zones                          = ["europe-west4-b"]
  network                        = google_compute_network.main.name
  subnetwork                     = google_compute_subnetwork.main.name
  ip_range_pods                  = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services              = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  compute_engine_service_account = local.compute_engine_service_account

  cluster_autoscaling = {
    enabled             = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
    max_cpu_cores       = 20
    min_cpu_cores       = 5
    max_memory_gb       = 30
    min_memory_gb       = 10
    gpu_resources       = []
    auto_repair         = true
    auto_upgrade        = true
  }
}

