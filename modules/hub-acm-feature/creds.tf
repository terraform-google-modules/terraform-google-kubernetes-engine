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

resource "tls_private_key" "k8sop_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "k8sop_creds_secret" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.1.0"

  enabled                     = var.create_ssh_key == true || var.ssh_auth_key != null ? "true" : "false"
  cluster_name                = var.cluster_name
  cluster_location            = var.location
  project_id                  = var.project_id
  service_account_key_file    = var.service_account_key_file
  use_existing_context        = var.use_existing_context
  impersonate_service_account = var.impersonate_service_account

  kubectl_create_command  = local.private_key != null ? "kubectl create secret generic ${var.operator_credential_name} -n=${var.operator_credential_namespace} --from-literal=${local.k8sop_creds_secret_key}='${local.private_key}'" : ""
  kubectl_destroy_command = "kubectl delete secret ${var.operator_credential_name} -n=${var.operator_credential_namespace}"
}
