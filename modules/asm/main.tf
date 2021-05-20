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

data "google_project" "asm_project" {
  project_id = var.project_id
}

locals {
  options_string         = length(var.options) > 0 ? join(",", var.options) : "none"
  custom_overlays_string = length(var.custom_overlays) > 0 ? join(",", var.custom_overlays) : "none"
  asm_git_tag_string     = (var.asm_git_tag == "" ? "none" : var.asm_git_tag)
  service_account_string = (var.service_account == "" ? "none" : var.service_account)
  key_file_string        = (var.key_file == "" ? "none" : var.key_file)
  ca_cert                = lookup(var.ca_certs, "ca_cert", "none")
  ca_key                 = lookup(var.ca_certs, "ca_key", "none")
  root_cert              = lookup(var.ca_certs, "root_cert", "none")
  cert_chain             = lookup(var.ca_certs, "cert_chain", "none")
}

module "asm_install" {
  source            = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version           = "~> 2.0.2"
  module_depends_on = [var.cluster_endpoint]

  gcloud_sdk_version       = var.gcloud_sdk_version
  upgrade                  = true
  additional_components    = ["kubectl", "kpt", "beta", "kustomize"]
  cluster_name             = var.cluster_name
  cluster_location         = var.location
  project_id               = var.project_id
  service_account_key_file = var.service_account_key_file

  kubectl_create_command  = "${path.module}/scripts/install_asm.sh ${var.project_id} ${var.cluster_name} ${var.location} ${var.asm_version} ${var.mode} ${var.managed_control_plane} ${var.skip_validation} ${local.options_string} ${local.custom_overlays_string} ${var.enable_all} ${var.enable_cluster_roles} ${var.enable_cluster_labels} ${var.enable_gcp_apis} ${var.enable_gcp_iam_roles} ${var.enable_gcp_components} ${var.enable_registration} ${var.outdir} ${var.ca} ${local.ca_cert} ${local.ca_key} ${local.root_cert} ${local.cert_chain} ${local.service_account_string} ${local.key_file_string} ${local.asm_git_tag_string}"
  kubectl_destroy_command = "kubectl delete ns istio-system"
}
