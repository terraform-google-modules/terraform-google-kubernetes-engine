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


module "example" {
  source                  = "../../../examples/shared_vpc_with_helper"
  folder_id               = var.folder_id
  region                  = var.region
  billing_account         = var.billing_account
  org_id                  = var.org_id
  gke_shared_host_project = var.gke_shared_host_project
  gke_service_project     = var.gke_service_project
}
