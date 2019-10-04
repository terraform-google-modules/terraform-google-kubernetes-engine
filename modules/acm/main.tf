locals {
  cluster_endpoint       = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location
}

data "google_client_config" "default" {
}

resource "tls_private_key" "git_creds" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "null_resource" "acm_operator_config" {
  provisioner "local-exec" {
    command = "gsutil cp gs://config-management-release/released/latest/config-management-operator.yaml ${path.module}/config-management-operator.yaml"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "rm -f ${path.module}/config-management-operator.yaml"
  }
}

resource "null_resource" "acm_operator" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl apply -f ${path.module}/config-management-operator.yaml"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete -f ${path.module}/config-management-operator.yaml"
  }

  depends_on = [
    null_resource.acm_operator_config,
    data.google_client_config.default,
    data.google_container_cluster.primary,
  ]
}

resource "null_resource" "git_creds_secret" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl create secret generic git-creds -n=config-management-system --from-literal=ssh='${tls_private_key.git_creds.private_key_pem}'"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete secret git-creds -n=config-management-system"
  }

  depends_on = [
    null_resource.acm_operator
  ]
}

data "template_file" "acm_config" {
  template = file("${path.module}/templates/acm-config.yml.tpl")

  vars = {
    cluster_name = var.cluster_name
    sync_repo    = var.sync_repo
    sync_branch  = var.sync_branch
    policy_dir   = var.policy_dir
    secret_type  = "ssh"
  }
}

resource "null_resource" "acm_config" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.acm_config.rendered}' | ${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl apply -f -"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "echo '${data.template_file.acm_config.rendered}' | ${path.module}/scripts/kubectl_wrapper.sh ${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} kubectl delete -f -"
  }

  depends_on = [
    null_resource.acm_operator,
    null_resource.git_creds_secret,
  ]
}