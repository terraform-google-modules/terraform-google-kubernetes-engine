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
  cluster_endpoint                = "https://${var.cluster_endpoint}"
  private_key                     = var.create_ssh_key && var.ssh_auth_key == null ? tls_private_key.k8sop_creds[0].private_key_pem : var.ssh_auth_key
  k8sop_creds_secret_key          = var.secret_type == "cookiefile" ? "cookie_file" : var.secret_type
  should_download_manifest        = var.operator_path == null ? true : false
  manifest_path                   = local.should_download_manifest ? "${path.root}/.terraform/tmp/${var.project_id}-${var.cluster_name}/config-management-operator.yaml" : var.operator_path
  sync_branch_property            = var.enable_multi_repo ? "branch" : "syncBranch"
  sync_branch_node                = var.sync_branch != "" ? format("%s: %s", local.sync_branch_property, var.sync_branch) : ""
  sync_revision_property          = var.enable_multi_repo ? "revision" : "syncRev"
  sync_revision_node              = var.sync_revision != "" ? format("%s: %s", local.sync_revision_property, var.sync_revision) : ""
  policy_dir_property             = var.enable_multi_repo ? "dir" : "policyDir"
  policy_dir_node                 = var.policy_dir != "" ? format("%s: %s", local.policy_dir_property, var.policy_dir) : ""
  secret_ref_node                 = var.create_ssh_key == true || var.ssh_auth_key != null ? format("secretRef:\n      name: %s", var.operator_credential_name) : ""
  hierarchy_controller_map_node   = var.hierarchy_controller == null ? "" : format("hierarchyController:\n    %s", indent(4, replace(yamlencode(var.hierarchy_controller), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")))
  source_format_node              = var.source_format != "" ? format("sourceFormat: %s", var.source_format) : ""
  append_arg_use_existing_context = var.use_existing_context ? "USE_EXISTING_CONTEXT_ARG" : ""
}

module "k8sop_manifest" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 2.1.0"
  enabled = local.should_download_manifest

  create_cmd_entrypoint  = "gsutil"
  create_cmd_body        = "cp ${var.operator_latest_manifest_url} ${local.manifest_path}"
  destroy_cmd_entrypoint = "rm"
  destroy_cmd_body       = "-f ${local.manifest_path}"
}


module "k8s_operator" {
  source                      = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version                     = "~> 2.1.0"
  module_depends_on           = [module.k8sop_manifest.wait, var.cluster_endpoint]
  cluster_name                = var.cluster_name
  cluster_location            = var.location
  project_id                  = var.project_id
  service_account_key_file    = var.service_account_key_file
  use_existing_context        = var.use_existing_context
  impersonate_service_account = var.impersonate_service_account

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
  version = "~> 2.1.0"

  enabled                     = var.create_ssh_key == true || var.ssh_auth_key != null ? "true" : "false"
  module_depends_on           = [module.k8s_operator.wait]
  cluster_name                = var.cluster_name
  cluster_location            = var.location
  project_id                  = var.project_id
  service_account_key_file    = var.service_account_key_file
  use_existing_context        = var.use_existing_context
  impersonate_service_account = var.impersonate_service_account

  kubectl_create_command  = local.private_key != null ? "kubectl create secret generic ${var.operator_credential_name} -n=${var.operator_credential_namespace} --from-literal=${local.k8sop_creds_secret_key}='${local.private_key}'" : ""
  kubectl_destroy_command = "kubectl delete secret ${var.operator_credential_name} -n=${var.operator_credential_namespace}"
}


data "template_file" "k8sop_config" {

  template = file(var.operator_cr_template_path)
  vars = {
    cluster_name                  = var.cluster_name
    enable_multi_repo             = var.enable_multi_repo
    sync_repo                     = var.sync_repo
    sync_branch_node              = local.sync_branch_node
    sync_revision_node            = local.sync_revision_node
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
  source                      = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version                     = "~> 2.1.0"
  module_depends_on           = [module.k8s_operator.wait, module.k8sop_creds_secret.wait]
  cluster_name                = var.cluster_name
  cluster_location            = var.location
  project_id                  = var.project_id
  create_cmd_triggers         = { configmanagement = data.template_file.k8sop_config.rendered }
  service_account_key_file    = var.service_account_key_file
  use_existing_context        = var.use_existing_context
  impersonate_service_account = var.impersonate_service_account

  kubectl_create_command  = "kubectl apply -f - <<EOF\n${data.template_file.k8sop_config.rendered}EOF"
  kubectl_destroy_command = "kubectl delete -f - <<EOF\n${data.template_file.k8sop_config.rendered}EOF"
}


data "template_file" "rootsync_config" {

  template = file(var.rootsync_cr_template_path)
  vars = {
    sync_repo          = var.sync_repo
    sync_branch_node   = local.sync_branch_node
    sync_revision_node = local.sync_revision_node
    policy_dir_node    = local.policy_dir_node
    secret_ref_node    = local.secret_ref_node
    secret_type        = var.create_ssh_key ? "ssh" : var.secret_type
    source_format_node = local.source_format_node
  }
}

module "wait_for_configsync_api" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.1.0"
  enabled = var.enable_multi_repo

  module_depends_on = [module.k8sop_config.wait]
  cluster_name      = var.cluster_name
  project_id        = var.project_id
  cluster_location  = var.location
  create_cmd_triggers = {
    rootsync    = data.template_file.rootsync_config.rendered,
    script_sha1 = sha1(file("${path.module}/scripts/wait_for_configsync.sh"))
  }
  service_account_key_file = var.service_account_key_file
  use_existing_context     = var.use_existing_context

  kubectl_create_command  = "${path.module}/scripts/wait_for_configsync.sh ${var.project_id} ${var.cluster_name} ${var.location} ${local.append_arg_use_existing_context}"
  kubectl_destroy_command = ""
}

module "rootsync_config" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.1.0"
  enabled = var.enable_multi_repo

  module_depends_on           = [module.wait_for_configsync_api.wait]
  cluster_name                = var.cluster_name
  project_id                  = var.project_id
  cluster_location            = var.location
  create_cmd_triggers         = { rootsync = data.template_file.rootsync_config.rendered }
  service_account_key_file    = var.service_account_key_file
  use_existing_context        = var.use_existing_context
  impersonate_service_account = var.impersonate_service_account

  kubectl_create_command  = "kubectl apply -f - <<EOF\n${data.template_file.rootsync_config.rendered}EOF"
  kubectl_destroy_command = "kubectl delete -f - <<EOF\n${data.template_file.rootsync_config.rendered}EOF"
}

module "wait_for_gatekeeper" {
  source                      = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version                     = "~> 2.1.0"
  enabled                     = var.enable_policy_controller ? true : false
  module_depends_on           = [module.k8sop_config.wait]
  cluster_name                = var.cluster_name
  cluster_location            = var.location
  project_id                  = var.project_id
  create_cmd_triggers         = { script_sha1 = sha1(file("${path.module}/scripts/wait_for_gatekeeper.sh")) }
  service_account_key_file    = var.service_account_key_file
  use_existing_context        = var.use_existing_context
  impersonate_service_account = var.impersonate_service_account

  kubectl_create_command  = "${path.module}/scripts/wait_for_gatekeeper.sh ${var.project_id} ${var.cluster_name} ${var.location} ${local.append_arg_use_existing_context}"
  kubectl_destroy_command = ""
}
