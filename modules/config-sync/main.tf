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

module "configsync_operator" {

  source = "../k8s-operator-crd-support"

  cluster_name         = var.cluster_name
  project_id           = var.project_id
  location             = var.location
  operator_path        = var.operator_path
  enable_multi_repo    = var.enable_multi_repo
  sync_repo            = var.sync_repo
  sync_branch          = var.sync_branch
  sync_revision        = var.sync_revision
  policy_dir           = var.policy_dir
  cluster_endpoint     = var.cluster_endpoint
  create_ssh_key       = var.create_ssh_key
  secret_type          = var.secret_type
  ssh_auth_key         = var.ssh_auth_key
  source_format        = var.source_format
  hierarchy_controller = var.hierarchy_controller

  operator_latest_manifest_url  = "gs://config-management-release/released/latest/config-sync-operator.yaml"
  operator_cr_template_path     = "${path.module}/templates/config-sync-config.yml.tpl"
  operator_credential_namespace = "config-management-system"
  operator_credential_name      = "git-creds"

  rootsync_cr_template_path = "${path.module}/templates/root-sync.yml.tpl"
}
