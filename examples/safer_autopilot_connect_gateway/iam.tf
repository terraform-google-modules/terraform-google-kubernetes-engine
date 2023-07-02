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

resource "google_project_iam_binding" "viewer" {
  project = var.project_id
  role    = "roles/gkehub.admin"
  members = [
    for user_perm in var.user_permissions :
    user_perm.user
  ]
}

resource "google_project_iam_binding" "gatewayadmin" {
  project = var.project_id
  role    = "roles/gkehub.gatewayAdmin"
  members = [
    for user_perm in var.user_permissions :
    user_perm.user
  ]
}

resource "google_project_iam_binding" "container_viewer" {
  project = var.project_id
  role    = "roles/container.viewer"
  members = [
    for user_perm in var.user_permissions :
    user_perm.user
  ]
}
