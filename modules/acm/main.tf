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

resource "null_resource" "acm_operator_config" {
  count = local.download_operator ? 1 : 0

  provisioner "local-exec" {
    command = "gsutil cp gs://config-management-release/released/latest/config-management-operator.yaml ${path.module}/config-management-operator.yaml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/config-management-operator.yaml"
  }
}

resource "null_resource" "acm_operator" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl apply -f ${local.operator_path}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete -f ${local.operator_path}"
  }

  depends_on = [
    null_resource.acm_operator_config,
    data.google_client_config.default,
    data.google_container_cluster.primary,
  ]
}

resource "null_resource" "git_creds_secret" {
  count = var.create_ssh_key ? 1 : 0

  provisioner "local-exec" {
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl create secret generic git-creds -n=config-management-system --from-literal=ssh='${local.private_key}'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete secret git-creds -n=config-management-system"
  }

  depends_on = [
    null_resource.acm_operator
  ]
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

resource "null_resource" "acm_config" {
  triggers = {
    config = data.template_file.acm_config.rendered
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.acm_config.rendered}' | ${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl apply -f -"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo '${data.template_file.acm_config.rendered}' | ${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete -f -"
  }

  depends_on = [
    null_resource.acm_operator,
    null_resource.git_creds_secret,
  ]
}

