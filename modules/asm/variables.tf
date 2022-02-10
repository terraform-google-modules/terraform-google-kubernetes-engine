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
  description = "The project in which the resource belongs."
  type        = string
}

variable "cluster_name" {
  description = "The unique name to identify the cluster in ASM."
  type        = string
}

variable "cluster_location" {
  description = "The cluster location for this ASM installation."
  type        = string
}

variable "channel" {
  description = "The channel to use for this ASM installation."
  type        = string
  validation {
    condition = anytrue([
      var.channel == "rapid",
      var.channel == "regular",
      var.channel == "stable",
      var.channel == "", // if unset, use GKE data source and use release cluster channel
    ])
    error_message = "Must be one of rapid, regular, or stable."
  }
  default = ""
}

variable "enable_cni" {
  description = "Determines whether to enable CNI for this ASM installation."
  type        = bool
  default     = false
}

// This should be validated so that it cannot be enabled while CNI is disabled
// but validating based on other variables is not possible today (https://github.com/hashicorp/terraform/issues/25609)
variable "enable_mdp" {
  description = "Determines whether to enable Managed Data Plane (MDP) for this ASM installation."
  type        = bool
  default     = false
}

variable "enable_cross_cluster_service_discovery" {
  description = "Determines whether to enable cross-cluster service discovery between this cluster and other clusters in the fleet."
  type        = bool
  default     = false
}

variable "mesh_config" {
  description = "MeshConfig specifies configuration available to the control plane. If unset the module will not attempt to create the MeshConfig (i.e. if managing this configuration elsewhere). The full list of options can be found at https://istio.io/latest/docs/reference/config/istio.mesh.v1alpha1/#MeshConfig"
  type        = map(any)
  default     = {}
}
