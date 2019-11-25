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

variable "gke_svpc_host_project" {
  type        = string
  description = "The project ID of the shared VPC's host"
}

variable "gke_svpc_service_project" {
  type        = string
  description = "The project ID of the service account (to host the GKE cluster in)"
}

variable "enable_shared_vpc_helper" {
  type        = bool
  description = "Trigger if this submofule should be enabled. If false all resourcess creation will be skipped"
}

variable "gke_subnetwork" {
  type        = string
  description = "The host account subnetwork to share with service account (to host the GKE cluster in)"
}

variable "region" {
  type        = string
  description = "The region of subnets to share (to host the cluster in)"
}

variable "gke_sa" {
  type        = string
  description = "The service account in a service project to run GKE cluster nodes"
}
