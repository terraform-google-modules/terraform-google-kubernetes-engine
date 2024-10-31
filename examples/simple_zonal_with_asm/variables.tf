/**
 * Copyright 2018-2024 Google LLC
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
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to host the cluster in (required if is a zonal cluster)"
  type        = string
  default     = "us-central1-a"
}

variable "enable_fleet_feature" {
  description = "Whether to enable the Mesh feature on the fleet."
  type        = bool
  default     = true
}

variable "mesh_management" {
  default     = "MANAGEMENT_AUTOMATIC"
  description = "ASM Management mode. For more information, see the [gke_hub_feature_membership resource documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#nested_mesh)"
  type        = string
  validation {
    condition = anytrue([
      var.mesh_management == null,
      var.mesh_management == "",
      var.mesh_management == "MANAGEMENT_AUTOMATIC",
      var.mesh_management == "MANAGEMENT_MANUAL",
    ])
    error_message = "Must be null, empty, or one of MANAGEMENT_AUTOMATIC or MANAGEMENT_MANUAL."
  }
}
