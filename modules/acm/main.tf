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
  source = "../fleet-membership"

  cluster_name              = var.cluster_name
  project_id                = var.project_id
  hub_project_id            = var.hub_project_id
  location                  = var.location
  enable_fleet_registration = var.enable_fleet_registration
  membership_name           = var.cluster_membership_id
}
