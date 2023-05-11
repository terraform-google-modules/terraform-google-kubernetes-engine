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

output "git_creds_public" {
  description = "Public key of SSH keypair to allow the Anthos Config Management Operator to authenticate to your Git repository."
  value       = var.create_ssh_key ? coalesce(tls_private_key.k8sop_creds[*].public_key_openssh...) : null
}

output "configmanagement_version" {
  description = "Version of ACM installed."
  value       = google_gke_hub_feature_membership.main.configmanagement[0].version
}

output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = google_gke_hub_feature_membership.main.membership
  depends_on = [
    google_gke_hub_feature_membership.main
  ]
}

output "acm_metrics_writer_sa" {
  description = "The ACM metrics writer Service Account"
  value       = var.create_metrics_gcp_sa ? google_service_account.acm_metrics_writer_sa[0].email : null
}
