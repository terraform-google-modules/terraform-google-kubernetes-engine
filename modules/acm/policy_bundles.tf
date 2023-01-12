/**
 * Copyright 2023 Google LLC
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
  policy_bundles = var.policy_bundles != null ? var.policy_bundles : ""
}

module "policy_bundles" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  project_id              = var.project_id
  cluster_name            = var.cluster_name
  cluster_location        = var.location
  enabled                 = (var.policy_bundles != null) && var.enable_policy_controller ? true : false
  kubectl_create_command  = "kubectl apply -k ${local.policy_bundles}"
  kubectl_destroy_command = "kubectl delete -k ${local.policy_bundles}"

  module_depends_on = [time_sleep.wait_acm]
}
