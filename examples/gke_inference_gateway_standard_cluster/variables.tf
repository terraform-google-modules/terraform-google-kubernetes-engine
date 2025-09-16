/**
 * Copyright 2025 Google LLC
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
  description = "The zone to host the cluster in"
  type        = string
  default     = "us-central1-a"
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "ip_range_pods" {
  description = "The secondary ip range for pods"
  type        = string
}

variable "ip_range_services" {
  description = "The secondary ip range for services"
  type        = string
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the cluster name"
  type        = string
  default     = ""
}

variable "service_account" {
  description = "Service account to attach to the node pool."
  type        = string
  default     = null
}

variable "dns_cache" {
  description = "Enable DNS cache for the cluster"
  type        = bool
  default     = false
}

variable "gce_pd_csi_driver" {
  description = "Enable GCE Persistent Disk CSI driver"
  type        = bool
  default     = true
}

variable "hf_token" {
  description = "Hugging Face token"
  type        = string
  sensitive   = true
}