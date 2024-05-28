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

provider "google" {
  project = var.project_id
}

locals {
  principal = var.user != "" ? "user:${var.user}" : "group:${var.group}"
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

resource "google_project_iam_binding" "log_view_permissions" {
  project   = var.project_id
  role      = "roles/logging.viewAccessor"
  members   = [
    local.principal,
  ]
  condition {
    title       = "conditional log view access"
    description = "log view access for scope ${var.scope_id}"
    expression  = "resource.name == \"projects/${var.project_id}/locations/global/buckets/fleet-o11y-scope-${var.scope_id}/views/fleet-o11y-scope-${var.scope_id}-k8s_container\" || resource.name == \"projects/${var.project_id}/locations/global/buckets/fleet-o11y-scope-${var.scope_id}/views/fleet-o11y-scope-${var.scope_id}-k8s_pod\""
  }
}

resource "google_project_iam_binding" "project_level_scope_permissions" {
  project  = var.project_id
  role     = local.project_level_scope_role[var.role]
  members  = [
    local.principal,
  ]
}

resource "google_gke_hub_scope_iam_binding" "resource_level_scope_permissions" {
  project  = var.project_id
  scope_id = var.scope_id
  role     = local.resource_level_scope_role[var.role]
  members  = [
    local.principal,
  ]
}

resource "random_id" "rand" {
  byte_length = 8
}

resource "google_gke_hub_scope_rbac_role_binding" "scope_rbac_user_role_binding" {
  lifecycle {
    precondition {
      condition     = (var.user != "" && var.group == "") || (var.user == "" && var.group != "")
      error_message = "Only one of user or group must be specified."
    }
  }
  count                      = var.user == "" ? 0 : 1
  scope_rbac_role_binding_id = "tf-${random_id.rand.hex}"
  scope_id                   = var.scope_id
  user                       = var.user
  role {
    predefined_role = var.role
  }
}

resource "google_gke_hub_scope_rbac_role_binding" "scope_rbac_group_role_binding" {
  lifecycle {
    precondition {
      condition     = (var.user != "" && var.group == "") || (var.user == "" && var.group != "")
      error_message = "Only one of user or group must be specified."
    }
  }
  count                      = var.group == "" ? 0 : 1
  scope_rbac_role_binding_id = "tf-${random_id.rand.hex}"
  scope_id                   = var.scope_id
  group                      = var.group
  role {
    predefined_role = var.role
  }
}

