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

module "policy_bundles" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  for_each                = toset(var.policy_bundles)
  project_id              = var.project_id
  cluster_name            = var.cluster_name
  cluster_location        = var.location
  
  use_existing_context = var.use_existing_k8s_context
  
  kubectl_create_command  = "kubectl apply -k ${each.key}"
  kubectl_destroy_command = "kubectl delete -k ${each.key}"

  module_depends_on = [time_sleep.wait_acm]
}
