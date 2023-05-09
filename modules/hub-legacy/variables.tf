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

variable "hub_project_id" {
  description = "The project in which the GKE Hub belongs."
  type        = string
  default     = ""
}

variable "location" {
  description = "The location (zone or region) this cluster has been created in."
  type        = string
}

variable "use_tf_google_credentials_env_var" {
  description = "Optional GOOGLE_CREDENTIALS environment variable to be activated."
  type        = bool
  default     = false
}

variable "gcloud_sdk_version" {
  description = "The gcloud sdk version to use. Minimum required version is 293.0.0"
  type        = string
  default     = "296.0.1"
}

variable "gke_hub_sa_name" {
  description = "Name for the GKE Hub SA stored as a secret `creds-gcp` in the `gke-connect` namespace."
  type        = string
  default     = "gke-hub-sa"
}

variable "gke_hub_membership_name" {
  description = "Membership name that uniquely represents the cluster being registered on the Hub"
  type        = string
  default     = "gke-hub-membership"
}

variable "use_existing_sa" {
  description = "Uses an existing service account to register membership. Requires sa_private_key"
  type        = bool
  default     = false
}

variable "sa_private_key" {
  description = "Private key for service account base64 encoded. Required only if `use_existing_sa` is set to `true`."
  type        = string
  default     = null
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "use_kubeconfig" {
  description = "Use existing kubeconfig to register membership. Set this to true for non GKE clusters. Assumes kubectl context is set to cluster to register."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Comma separated labels in the format name=value to apply to cluster in the GCP Console."
  type        = string
  default     = ""
}
