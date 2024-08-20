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

variable "fleet_project_id" {
  description = "The project to which the Fleet belongs."
  type        = string
}

variable "scope_id" {
  description = "The scope for which IAM and RBAC role bindings are created."
  type        = string
}

variable "users" {
  description = "The list of app operator user principals, e.g., `person@google.com`, `principal://iam.googleapis.com/locations/global/workforcePools/my-pool/subject/person`, `serviceAccount:my-service-account@my-project.iam.gserviceaccount.com`."
  type        = list(string)
  default     = []
}

variable "groups" {
  description = "The list of app operator group principals, e.g., `people@google.com`, `principalSet://iam.googleapis.com/locations/global/workforcePools/my-pool/group/people`."
  type        = list(string)
  default     = []
}

variable "role" {
  description = "The principals role for the Fleet Scope (`VIEW`/`EDIT`/`ADMIN`)."
  type        = string
  validation {
    condition     = contains(["VIEW", "EDIT", "ADMIN"], var.role)
    error_message = "Allowed values for role are VIEW, EDIT, or ADMIN."
  }
}

