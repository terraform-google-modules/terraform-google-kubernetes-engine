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
  cluster_endpoint       = "https://${var.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  private_key            = var.create_ssh_key && var.ssh_auth_key == null ? tls_private_key.git_creds[0].private_key_pem : var.ssh_auth_key
  download_operator      = var.operator_path == null ? true : false
  operator_path          = local.download_operator ? "${path.module}/config-management-operator.yaml" : var.operator_path
}

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location
}

data "google_client_config" "default" {
}

resource "tls_private_key" "git_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "acm_operator_config" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 0.5"
  enabled = local.download_operator

  create_cmd_entrypoint  = "gsutil"
  create_cmd_body        = "cp gs://config-management-release/released/latest/config-management-operator.yaml ${path.module}/config-management-operator.yaml"
  destroy_cmd_entrypoint = "rm"
  destroy_cmd_body       = "-f ${path.module}/config-management-operator.yaml"
}

module "acm_operator" {
  source                = "terraform-google-modules/gcloud/google"
  version               = "~> 0.5"
  module_depends_on     = [module.acm_operator_config.wait, data.google_client_config.default.project, data.google_container_cluster.primary.name]
  additional_components = ["kubectl"]

  create_cmd_entrypoint  = "${path.module}/scripts/kubectl_wrapper.sh"
  create_cmd_body        = "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl apply -f ${local.operator_path}"
  destroy_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  destroy_cmd_body       = "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete -f ${local.operator_path}"
}

module "git_creds_secret" {
  source                = "terraform-google-modules/gcloud/google"
  version               = "~> 0.5"
  module_depends_on     = [module.acm_operator.wait]
  additional_components = ["kubectl"]

  create_cmd_entrypoint  = "${path.module}/scripts/kubectl_wrapper.sh"
  create_cmd_body        = "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl create secret generic git-creds -n=config-management-system --from-literal=ssh='${local.private_key}'"
  destroy_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  destroy_cmd_body       = "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete secret git-creds -n=config-management-system"
}

data "template_file" "acm_config" {
  template = file("${path.module}/templates/acm-config.yml.tpl")

  vars = {
    cluster_name             = var.cluster_name
    sync_repo                = var.sync_repo
    sync_branch              = var.sync_branch
    policy_dir               = var.policy_dir
    secret_type              = var.create_ssh_key ? "ssh" : "none"
    enable_policy_controller = var.enable_policy_controller ? "true" : "false"
    install_template_library = var.install_template_library ? "true" : "false"
  }
}

module "acm_config" {
  source                = "terraform-google-modules/gcloud/google"
  version               = "~> 0.5"
  module_depends_on     = [module.acm_operator.wait, module.git_creds_secret.wait]
  additional_components = ["kubectl"]

  create_cmd_entrypoint  = "echo"
  create_cmd_body        = "'${data.template_file.acm_config.rendered}' | ${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl apply -f -"
  destroy_cmd_entrypoint = "echo"
  destroy_cmd_body       = "'${data.template_file.acm_config.rendered}' | ${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete -f -"
}
