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

variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "pentagon-324205"
}

variable "region" {
  description = "The region the cluster in"
  default     = "us-central1"
}

variable "user_permissions" {
  description = "Configure RBAC role for the user"
  type = list(object({
    user      = string
    rbac_role = string
  }))
  default = [{
    user      = "user:exampleuser@example.com"
    rbac_role = "cluster-admin"
    }, {
    user      = "serviceAccount:EXAMPLE_SA@GCP_PROJECT_ID.iam.gserviceaccount.com"
    rbac_role = "cluster-viewer"
  }]
}
