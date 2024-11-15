/**
 * Copyright 2020 Google LLC
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
  test_command = "gcloud beta compute ssh ${module.example.bastion_name} --tunnel-through-iap --verbosity=error --project ${var.project_ids[1]} --zone ${module.example.bastion_zone} -q --command='curl -H \"Authorization: Bearer $(gcloud auth print-access-token)\" -H \"Content-Type: application/json\" -sS https://${module.example.endpoint_dns}/version -k'"
}

module "example" {
  source = "../../../examples/safer_cluster_iap_bastion"

  project_id = var.project_ids[1]
}

resource "google_project_iam_member" "member" {
  project = var.project_ids[1]
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${var.int_sa}"
}

data "google_container_cluster" "safer" {
  project    = var.project_ids[1]
  name       = module.example.cluster_name
  location   = module.example.location
  depends_on = [module.example]
}
