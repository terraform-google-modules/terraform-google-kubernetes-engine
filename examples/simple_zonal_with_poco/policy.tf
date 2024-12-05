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

resource "google_gke_hub_feature" "poco_feature" {
  name     = "policycontroller"
  project  = var.project_id
  location = "global"

  count = var.enable_fleet_feature ? 1 : 0
}

resource "google_gke_hub_feature_membership" "poco_feature_member" {
  project  = var.project_id
  location = "global"

  feature             = "policycontroller"
  membership          = module.gke.fleet_membership
  membership_location = module.gke.region

  policycontroller {
    policy_controller_hub_config {
      install_spec = "INSTALL_SPEC_ENABLED"
      policy_content {
        template_library {
          installation = "ALL"
        }
        bundles {
          bundle_name = "pss-baseline-v2022"
        }
      }
      referential_rules_enabled = true
    }
  }

  depends_on = [
    google_gke_hub_feature.poco_feature
  ]
}
