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
  description = "The unique name to identify the cluster in ASM."
  type        = string
}

variable "cluster_endpoint" {
  description = "The GKE cluster endpoint."
  type        = string
}

variable "project_id" {
  description = "The project in which the resource belongs."
  type        = string
}

variable "location" {
  description = "The location (zone or region) this cluster has been created in."
  type        = string
}

variable "gcloud_sdk_version" {
  description = "The gcloud sdk version to use. Minimum required version is 293.0.0"
  type        = string
  default     = "296.0.1"
}

variable "asm_dir" {
  description = "Name of directory to keep ASM resource config files."
  type        = string
  default     = "asm-dir"
}

variable "service_account_key_file" {
  description = "Path to service account key file to auth as for running `gcloud container clusters get-credentials`."
  default     = ""
}

variable "asm_version" {
  description = "ASM version to deploy. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages"
  type        = string
  default     = "1.8"
}
