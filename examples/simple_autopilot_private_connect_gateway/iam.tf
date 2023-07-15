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

resource "google_project_iam_member" "viewer" {
  for_each = {
    for index, user_perm in var.user_permissions :
    user_perm.user => user_perm
  }
  project = var.project_id
  role    = "roles/gkehub.admin"
  member  = each.value.user

}

resource "google_project_iam_member" "gatewayadmin" {
  for_each = {
    for index, user_perm in var.user_permissions :
    user_perm.user => user_perm
  }
  project = var.project_id
  role    = "roles/gkehub.gatewayAdmin"
  member  = each.value.user
}

resource "google_project_iam_member" "container_viewer" {
  for_each = {
    for index, user_perm in var.user_permissions :
    user_perm.user => user_perm
  }
  project = var.project_id
  role    = "roles/container.viewer"
  member  = each.value.user
}
