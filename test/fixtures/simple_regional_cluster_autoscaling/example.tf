/**
 * Copyright 2024 Google LLC
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

module "example" {
  source = "../../../examples/simple_regional_cluster_autoscaling"

  project_id                     = var.project_ids[0]
  cluster_name_suffix            = "-${random_string.suffix.result}"
  region                         = "us-west1"
  network                        = google_compute_network.main.name
  subnetwork                     = google_compute_subnetwork.main.name
  ip_range_pods                  = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services              = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  compute_engine_service_account = var.compute_engine_service_accounts[0]
}
