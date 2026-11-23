/**
 * Copyright 2019 Google LLC
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

output "project_ids" {
  value = [
    module.gke-project-1.project_id,
    module.gke-project-2.project_id,
    module.gke-project-asm.project_id,
    module.gke-project-fleet.project_id,
    module.gke-project-4.project_id,
    module.gke-project-5.project_id,
    module.gke-project-6.project_id,
  ]
  depends_on = [time_sleep.wait_for_iam_propagation]
}

output "sa_key" {
  value      = google_service_account_key.int_test.private_key
  sensitive  = true
  depends_on = [time_sleep.wait_for_iam_propagation]
}

output "int_sa" {
  value      = google_service_account.int_test.email
  depends_on = [time_sleep.wait_for_iam_propagation]
}

output "compute_engine_service_accounts" {
  value = [
    google_service_account.gke_sa_1.email,
    google_service_account.gke_sa_2.email,
    google_service_account.gke_sa_asm.email,
    google_service_account.gke_sa_fleet.email,
    google_service_account.gke_sa_4.email,
    google_service_account.gke_sa_5.email,
    google_service_account.gke_sa_6.email,
  ]
  depends_on = [time_sleep.wait_for_iam_propagation]
}

output "registry_project_ids" {
  value      = [module.gke-project-1.project_id]
  depends_on = [time_sleep.wait_for_iam_propagation]
}
