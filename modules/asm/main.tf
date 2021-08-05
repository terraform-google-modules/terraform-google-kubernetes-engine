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
  revision_name_string   = (var.revision_name == "" ? "none" : var.revision_name)
  asm_minor_version      = tonumber(split(".", var.asm_version)[1])
  # https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages/blob/1cf61b679cd369f42a0e735f8e201de1a6a6433b/scripts/asm-installer/install_asm#L1970
  iam_roles = [
    "roles/container.admin",
    "roles/meshconfig.admin",
    "roles/gkehub.admin",
  ]
  # https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages/blob/1cf61b679cd369f42a0e735f8e201de1a6a6433b/scripts/asm-installer/install_asm#L1958
  mcp_iam_roles = [
    "roles/serviceusage.serviceUsageConsumer",
    "roles/container.admin",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/gkehub.viewer",
    "roles/gkehub.gatewayAdmin",
  ]
  # if enable_gcp_iam_roles is set, grant IAM roles to first non null principal in the order below
  asm_iam_member = var.enable_gcp_iam_roles ? coalesce(var.impersonate_service_account, var.service_account, var.iam_member) : ""
  # compute any additonal resources that ASM provisioner should depend on
  additional_depends_on = concat(var.enable_gcp_apis ? [module.asm-services[0].project_id] : [], local.asm_iam_member != "" ? [for k, v in google_project_iam_member.asm_iam : v.etag] : [])
  # base command template for ASM installation
  kubectl_create_command_base = "${path.module}/scripts/install_asm.sh ${var.project_id} ${var.cluster_name} ${var.location} ${var.asm_version} ${var.mode} ${var.managed_control_plane} ${var.skip_validation} ${local.options_string} ${local.custom_overlays_string} ${var.enable_all} ${var.enable_cluster_roles} ${var.enable_cluster_labels} ${var.enable_gcp_components} ${var.enable_registration} ${var.outdir} ${var.ca} ${local.ca_cert} ${local.ca_key} ${local.root_cert} ${local.cert_chain} ${local.service_account_string} ${local.key_file_string} ${local.asm_git_tag_string} ${local.revision_name_string}"
}

resource "google_project_iam_member" "asm_iam" {
  for_each = toset(local.asm_iam_member != "" ? (var.managed_control_plane ? local.mcp_iam_roles : local.iam_roles) : [])
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${local.asm_iam_member}"
}

module "asm-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"
  count   = var.enable_gcp_apis ? 1 : 0

  project_id                  = var.project_id
  disable_services_on_destroy = false
  disable_dependent_services  = false

  # https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages/blob/1cf61b679cd369f42a0e735f8e201de1a6a6433b/scripts/asm-installer/install_asm#L2005
  activate_apis = [
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudtrace.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "meshca.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "stackdriver.googleapis.com",
  ]
}

module "asm_install" {
  source            = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version           = "~> 2.1.0"
  module_depends_on = concat([var.cluster_endpoint], local.additional_depends_on)

  gcloud_sdk_version          = var.gcloud_sdk_version
  upgrade                     = true
  additional_components       = ["kubectl", "kpt", "beta"]
  cluster_name                = var.cluster_name
  cluster_location            = var.location
  project_id                  = var.project_id
  service_account_key_file    = var.service_account_key_file
  impersonate_service_account = var.impersonate_service_account

  # enable_namespace_creation flag is only available starting 1.10
  kubectl_create_command  = (local.asm_minor_version > 9 ? "${local.kubectl_create_command_base} ${var.enable_namespace_creation}" : local.kubectl_create_command_base)
  kubectl_destroy_command = "${path.module}/scripts/destroy_asm.sh"
}
