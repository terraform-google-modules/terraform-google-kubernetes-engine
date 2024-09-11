/**
 * Copyright 2024 Google LLC
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
  user_principals = [for name in var.users : (
    startswith(name, "principal://") ? name : (
      endswith(name, "gserviceaccount.com") ? "serviceAccount:${name}" : (
        "user:${name}"
  )))]

  group_principals = [for name in var.groups : (
    startswith(name, "principalSet://") ? name : (
      "group:${name}"
  ))]

  project_level_scope_role = {
    "VIEW"  = "roles/gkehub.scopeViewerProjectLevel"
    "EDIT"  = "roles/gkehub.scopeEditorProjectLevel"
    "ADMIN" = "roles/gkehub.scopeEditorProjectLevel" # Same as EDIT
  }

  resource_level_scope_role = {
    "VIEW"  = "roles/gkehub.scopeViewer"
    "EDIT"  = "roles/gkehub.scopeEditor"
    "ADMIN" = "roles/gkehub.scopeAdmin"
  }
}

resource "google_project_iam_member" "log_view_permissions" {
  project  = var.fleet_project_id
  for_each = toset(concat(local.user_principals, local.group_principals))
  role     = "roles/logging.viewAccessor"
  member   = each.value
  condition {
    title       = "conditional log view access"
    description = "log view access for scope ${var.scope_id}"
    expression  = "resource.name == \"projects/${var.fleet_project_id}/locations/global/buckets/fleet-o11y-scope-${var.scope_id}/views/fleet-o11y-scope-${var.scope_id}-k8s_container\" || resource.name == \"projects/${var.fleet_project_id}/locations/global/buckets/fleet-o11y-scope-${var.scope_id}/views/fleet-o11y-scope-${var.scope_id}-k8s_pod\""
  }
}

resource "google_project_iam_member" "project_level_scope_permissions" {
  project  = var.fleet_project_id
  for_each = toset(concat(local.user_principals, local.group_principals))
  role     = local.project_level_scope_role[var.role]
  member   = each.value
}

resource "google_gke_hub_scope_iam_binding" "resource_level_scope_permissions" {
  project  = var.fleet_project_id
  scope_id = var.scope_id
  role     = local.resource_level_scope_role[var.role]
  members  = concat(local.user_principals, local.group_principals)
}

resource "random_id" "user_rand_suffix" {
  for_each    = toset(var.users)
  byte_length = 4
}

resource "google_gke_hub_scope_rbac_role_binding" "scope_rbac_user_role_bindings" {
  for_each                   = toset(var.users)
  project                    = var.fleet_project_id
  scope_rbac_role_binding_id = "tf-${substr(join("", regexall("[a-z0-9]+", each.key)), 0, 16)}-${random_id.user_rand_suffix[each.key].hex}"
  scope_id                   = var.scope_id
  user                       = each.key
  role {
    predefined_role = var.role
  }
}

resource "random_id" "group_rand_suffix" {
  for_each    = toset(var.groups)
  byte_length = 4
}

resource "google_gke_hub_scope_rbac_role_binding" "scope_rbac_group_role_bindings" {
  for_each                   = toset(var.groups)
  project                    = var.fleet_project_id
  scope_rbac_role_binding_id = "tf-${substr(join("", regexall("[a-z0-9]+", each.key)), 0, 16)}-${random_id.group_rand_suffix[each.key].hex}"
  scope_id                   = var.scope_id
  group                      = each.key
  role {
    predefined_role = var.role
  }
}

