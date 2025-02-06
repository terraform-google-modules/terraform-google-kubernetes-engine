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
  app_operator_id   = "app-operator-id"
  app_operator_team = "app-operator-team"
  app_operator_role = "VIEW"
}

# Create a Service Account, which can be used as an app operator.
resource "google_service_account" "service_account" {
  project      = var.fleet_project_id
  account_id   = local.app_operator_id
  display_name = "Test App Operator Service Account"
}

# Create a Fleet Scope for the app operator's team.
resource "google_gke_hub_scope" "scope" {
  project  = var.fleet_project_id
  scope_id = local.app_operator_team
}

# Grant permissions to the app operator to work with the Fleet Scope.
module "permissions" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/fleet-app-operator-permissions"
  version = "~> 36.0"

  fleet_project_id = var.fleet_project_id
  scope_id         = google_gke_hub_scope.scope.scope_id
  users            = ["${local.app_operator_id}@${var.fleet_project_id}.iam.gserviceaccount.com"]
  role             = local.app_operator_role

  depends_on = [
    google_service_account.service_account
  ]
}

