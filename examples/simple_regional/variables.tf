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

variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "network" {
  description = "The VPC network to host the cluster in"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
}

variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
}

variable "containerd_registry_hosts" {
  type = list(object({
    server = string
    hosts = optional(list(object({
      host          = string
      capabilities  = optional(list(string))
      override_path = optional(bool)
      dial_timeout  = optional(string)
      header = optional(list(object({
        key   = string
        value = list(string)
      })), [])
      ca = optional(list(object({
        gcp_secret_manager_secret_uri = string
      })), [])
      client = optional(list(object({
        cert = object({
          gcp_secret_manager_secret_uri = string
        })
        key = optional(object({
          gcp_secret_manager_secret_uri = string
        }))
      })), [])
    })), [])
  }))
  description = "Cluster-level containerd registry hosts inherited by node pools without overrides. Requires GKE 1.34.1-gke.2980000 or later. Updating this configuration can recreate managed nodes."
  default     = null
}

variable "enable_binary_authorization" {
  description = "Enable BinAuthZ Admission controller"
  default     = false
}
