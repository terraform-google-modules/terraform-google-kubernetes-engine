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
  private_key            = var.create_ssh_key && var.ssh_auth_key == null ? tls_private_key.k8sop_creds[0].private_key_pem : var.ssh_auth_key
  k8sop_creds_secret_key = var.secret_type == "cookiefile" ? "cookie_file" : var.secret_type
}

module "registration" {
  source = "../hub-gke"

  cluster_name                = var.cluster_name
  project_id                  = var.project_id
  location                    = var.location
  enable_gke_hub_registration = var.cluster_membership_id == "" ? true : false
}

resource "google_gke_hub_feature_membership" "main" {
  provider = google-beta

  location = "global"
  feature  = "configmanagement"

  membership = var.cluster_membership_id != "" ? var.cluster_membership_id : module.registration.membership_id
  project    = var.project_id

  configmanagement {
    version = "1.8.0"
    config_sync {
      source_format = var.source_format != "" ? var.source_format : null

      git {
        sync_repo   = var.sync_repo
        policy_dir  = var.policy_dir != "" ? var.policy_dir : null
        sync_branch = var.sync_branch != "" ? var.sync_branch : null
        sync_rev    = var.sync_revision != "" ? var.sync_revision : null
        secret_type = var.secret_type
      }
    }

    dynamic "policy_controller" {
      for_each = var.enable_policy_controller ? [{ enabled = true }] : []

      content {
        enabled                    = true
        template_library_installed = var.install_template_library
        log_denies_enabled         = var.enable_log_denies
      }
    }

    dynamic "hierarchy_controller" {
      for_each = var.hierarchy_controller == null ? [] : [var.hierarchy_controller]

      content {
        enabled                            = true
        enable_hierarchical_resource_quota = each.value.enable_hierarchical_resource_quota
        enable_pod_tree_labels             = each.value.enable_pod_tree_labels
      }
    }
  }

  depends_on = [
    module.k8sop_creds_secret.wait
  ]
}
