/**
 * Copyright 2018-2024 Google LLC
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

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 35.0"

  project_id      = var.project_id
  fleet_project   = var.project_id
  name            = "test-prefix-cluster-test-suffix"
  regional        = false
  region          = var.region
  zones           = [var.zone]
  release_channel = "REGULAR"

  network           = google_compute_network.main.name
  subnetwork        = google_compute_subnetwork.main.name
  ip_range_pods     = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services = google_compute_subnetwork.main.secondary_ip_range[1].range_name

  deletion_protection = false
  node_pools = [
    {
      name         = "asm-node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 3
      machine_type = "e2-standard-8"
    },
  ]
}
