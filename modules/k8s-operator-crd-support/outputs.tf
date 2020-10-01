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
  description = "Public key of SSH keypair to allow the Anthos Operator to authenticate to your Git repository."
  value       = var.create_ssh_key ? tls_private_key.k8sop_creds.*.public_key_openssh : null
}

output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = var.enable_policy_controller ? module.wait_for_gatekeeper.wait : module.k8sop_config.wait
}



