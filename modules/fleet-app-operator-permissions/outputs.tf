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

output "fleet_project_id" {
  description = "The project to which the Fleet belongs."
  value       = var.fleet_project_id
}

output "wait" {
  description = "An output to use when you want to depend on Scope RBAC Role Binding creation finishing."
  value = {
    for k, v in merge(google_gke_hub_scope_rbac_role_binding.scope_rbac_user_role_bindings, google_gke_hub_scope_rbac_role_binding.scope_rbac_group_role_bindings) : k => v.scope_rbac_role_binding_id
  }
}

