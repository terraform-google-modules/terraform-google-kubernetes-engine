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

variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
}

variable "project_id" {
  description = "The project in which the resource belongs."
  type        = string
}

variable "location" {
  description = "The location (zone or region) this cluster has been created in. One of location, region, zone, or a provider-level zone must be specified."
  type        = string
}

variable "sync_repo" {
  description = "Anthos config management Git repo"
  type        = string
}

variable "sync_branch" {
  description = "Anthos config management Git branch"
  type        = string
  default     = "master"
}

variable "policy_dir" {
  description = "Subfolder containing configs in Ahtons config management Git repo"
  type        = string
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint."
  type        = string
}

