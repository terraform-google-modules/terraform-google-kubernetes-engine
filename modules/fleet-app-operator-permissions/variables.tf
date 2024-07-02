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

variable "project_id" {
  description = "The project to which the Fleet belongs."
  type        = string
}

variable "scope_id" {
  description = "The scope for which IAM and RBAC role bindings are created."
  type        = string
}

variable "app_operator_name" {
  description = "The name of the app operator principal for the Fleet Scope, e.g., `person@google.com` (user), `people@google.com` (group), `principal://iam.googleapis.com/locations/global/workforcePools/my-pool/subject/person` (user), `principalSet://iam.googleapis.com/locations/global/workforcePools/my-pool/group/people` (group), `serviceAccount:my-service-account@my-project.iam.gserviceaccount.com` (user)."
  type = string
}

variable "is_user_app_operator" {
  description = "Whether the app operator is a user (`true`), or a group (`false`)."
  type = bool
}

variable "role" {
  description = "The principal role for the Fleet Scope (`VIEW`/`EDIT`/`ADMIN`)."
  type        = string
  validation {
    condition     = var.role == "VIEW" || var.role == "EDIT" || var.role == "ADMIN"
    error_message = "Allowed values for role are VIEW, EDIT, or ADMIN."
  }
}

