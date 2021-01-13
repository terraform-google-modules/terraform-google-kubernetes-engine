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

locals {
  cluster_endpoint                               = "https://${var.cluster_endpoint}"
  private_key                                    = var.create_ssh_key && var.ssh_auth_key == null ? tls_private_key.k8sop_creds[0].private_key_pem : var.ssh_auth_key
  k8sop_creds_secret_key                         = var.secret_type == "cookiefile" ? "cookie_file" : var.secret_type
  should_download_manifest                       = var.operator_path == null ? true : false
  manifest_path                                  = local.should_download_manifest ? "${path.root}/.terraform/tmp/${var.project_id}-${var.cluster_name}/config-management-operator.yaml" : var.operator_path
  sync_branch_node                               = var.sync_branch != "" ? format("syncBranch: %s", var.sync_branch) : ""
  policy_dir_node                                = var.policy_dir != "" ? format("policyDir: %s", var.policy_dir) : ""
  hierarchy_controller_map_node                  = var.hierarchy_controller == null ? "" : format("hierarchy_controller:\n    %s", yamlencode(var.hierarchy_controller))
  source_format_node                             = var.source_format != "" ? format("sourceFormat: %s", var.source_format) : ""
  append_arg_use_existing_context_for_gatekeeper = var.use_existing_context ? "USE_EXISTING_CONTEXT_ARG" : ""
}

module "k8sop_manifest" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 2.0.2"
  enabled = local.should_download_manifest

  create_cmd_entrypoint  = "gsutil"
  create_cmd_body        = "cp ${var.operator_latest_manifest_url} ${local.manifest_path}"
  destroy_cmd_entrypoint = "rm"
  destroy_cmd_body       = "-f ${local.manifest_path}"
}


module "k8s_operator" {
  source                   = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version                  = "~> 2.0.2"
  module_depends_on        = [module.k8sop_manifest.wait, var.cluster_endpoint]
  cluster_name             = var.cluster_name
  cluster_location         = var.location
  project_id               = var.project_id
  service_account_key_file = var.service_account_key_file
  use_existing_context     = var.use_existing_context

  kubectl_create_command  = "kubectl apply -f ${local.manifest_path}"
  kubectl_destroy_command = "kubectl delete -f ${local.manifest_path}"
}


resource "tls_private_key" "k8sop_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "k8sop_creds_secret" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.0.2"

  enabled                  = var.create_ssh_key == true || var.ssh_auth_key != null ? "true" : "false"
  module_depends_on        = [module.k8s_operator.wait]
  cluster_name             = var.cluster_name
  cluster_location         = var.location
  project_id               = var.project_id
  service_account_key_file = var.service_account_key_file
  use_existing_context     = var.use_existing_context

  kubectl_create_command  = local.private_key != null ? "kubectl create secret generic ${var.operator_credential_name} -n=${var.operator_credential_namespace} --from-literal=${local.k8sop_creds_secret_key}='${local.private_key}'" : ""
  kubectl_destroy_command = "kubectl delete secret ${var.operator_credential_name} -n=${var.operator_credential_namespace}"
}


data "template_file" "k8sop_config" {

  template = file(var.operator_cr_template_path)
  vars = {
    cluster_name                  = var.cluster_name
    sync_repo                     = var.sync_repo
    sync_branch_node              = local.sync_branch_node
    policy_dir_node               = local.policy_dir_node
    secret_type                   = var.create_ssh_key ? "ssh" : var.secret_type
    enable_policy_controller      = var.enable_policy_controller ? "true" : "false"
    install_template_library      = var.install_template_library ? "true" : "false"
    source_format_node            = local.source_format_node
    hierarchy_controller_map_node = local.hierarchy_controller_map_node
    enable_log_denies             = var.enable_log_denies
  }
}

module "k8sop_config" {
  source                   = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version                  = "~> 2.0.2"
  module_depends_on        = [module.k8s_operator.wait, module.k8sop_creds_secret.wait]
  cluster_name             = var.cluster_name
  cluster_location         = var.location
  project_id               = var.project_id
  create_cmd_triggers      = { configmanagement = data.template_file.k8sop_config.rendered }
  service_account_key_file = var.service_account_key_file
  use_existing_context     = var.use_existing_context

  kubectl_create_command  = "kubectl apply -f - <<EOF\n${data.template_file.k8sop_config.rendered}EOF"
  kubectl_destroy_command = "kubectl delete -f - <<EOF\n${data.template_file.k8sop_config.rendered}EOF"
}

module "wait_for_gatekeeper" {
  source                   = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version                  = "~> 2.0.2"
  enabled                  = var.enable_policy_controller ? true : false
  module_depends_on        = [module.k8sop_config.wait]
  cluster_name             = var.cluster_name
  cluster_location         = var.location
  project_id               = var.project_id
  create_cmd_triggers      = { script_sha1 = sha1(file("${path.module}/scripts/wait_for_gatekeeper.sh")) }
  service_account_key_file = var.service_account_key_file
  use_existing_context     = var.use_existing_context

  kubectl_create_command  = "${path.module}/scripts/wait_for_gatekeeper.sh ${var.project_id} ${var.cluster_name} ${var.location} ${local.append_arg_use_existing_context_for_gatekeeper}"
  kubectl_destroy_command = ""
}
