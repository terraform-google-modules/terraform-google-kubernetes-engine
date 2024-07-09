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

# Create a Service Account, which can be used as an app operator.
resource "google_service_account" "service_account" {
  account_id   = "app-operator-id"
  display_name = "Test App Operator Service Account"
}

# Create a Fleet Scope for the app operator's team.
resource "google_gke_hub_scope" "scope" {
  scope_id = "app-operator-team"
}

# Grant permissions to the app operator to work with the Fleet Scope.
module "permissions" {
  source = "../../modules/fleet-app-operator-permissions"

  project_id = var.project_id
  scope_id   = google_gke_hub_scope.scope.scope_id
  users      = [google_service_account.service_account.email]
  groups     = []
  role       = "VIEW"
}

