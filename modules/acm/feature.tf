/**
 * Copyright 2022 Google LLC
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

resource "google_gke_hub_feature" "acm" {
  count    = var.enable_fleet_feature ? 1 : 0
  provider = google-beta

  name     = "configmanagement"
  project  = coalesce(var.fleet_project_id, var.project_id)
  location = "global"
}

resource "google_gke_hub_feature_membership" "main" {
  provider = google-beta
  depends_on = [
    google_gke_hub_feature.acm
  ]

  location = "global"
  feature  = "configmanagement"

  membership = module.registration.cluster_membership_id
  project    = coalesce(var.fleet_project_id, var.project_id)

  configmanagement {
    version = var.configmanagement_version

    dynamic "config_sync" {
      for_each = var.enable_config_sync ? [{ enabled = true }] : []

      content {
        enabled       = var.enable_config_sync
        source_format = var.source_format != "" ? var.source_format : null

        git {
          sync_repo                 = var.sync_repo
          policy_dir                = var.policy_dir != "" ? var.policy_dir : null
          sync_branch               = var.sync_branch != "" ? var.sync_branch : null
          sync_rev                  = var.sync_revision != "" ? var.sync_revision : null
          secret_type               = var.secret_type
          https_proxy               = var.https_proxy
          gcp_service_account_email = var.gcp_service_account_email
        }
      }
    }

    dynamic "policy_controller" {
      for_each = var.enable_policy_controller ? [{ enabled = true }] : []

      content {
        enabled                    = true
        mutation_enabled           = var.enable_mutation
        referential_rules_enabled  = var.enable_referential_rules
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
}
