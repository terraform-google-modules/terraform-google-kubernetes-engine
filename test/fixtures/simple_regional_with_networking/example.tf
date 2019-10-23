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

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "example" {
  source = "../../../examples/simple_regional_with_networking"

  project_id          = var.project_id
  cluster_name_suffix = "-${random_string.suffix.result}"
  region              = var.region
  network             = "${var.network}-${random_string.suffix.result}"
  subnetwork          = "${var.subnetwork}-${random_string.suffix.result}"
  ip_range_pods       = "${var.ip_range_pods}-${random_string.suffix.result}"
  ip_range_services   = "${var.ip_range_services}-${random_string.suffix.result}"
}
