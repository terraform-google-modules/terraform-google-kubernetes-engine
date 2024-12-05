/**
 * Copyright 2019 Google LLC
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

variable "name" {
  description = "Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary."
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_sa_name" {
  description = "Name for the Google service account; overrides `var.name`."
  type        = string
  default     = null
}

variable "use_existing_gcp_sa" {
  description = "Use an existing Google service account instead of creating one"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Cluster name. Required if using existing KSA."
  type        = string
  default     = ""
}

variable "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster). Required if using existing KSA."
  type        = string
  default     = ""
}

variable "k8s_sa_name" {
  description = "Name for the Kubernetes service account; overrides `var.name`. `cluster_name` and `location` must be set when this input is specified."
  type        = string
  default     = null
}

variable "k8s_sa_project_id" {
  description = "GCP project ID of the k8s service account; overrides `var.project_id`."
  type        = string
  default     = null
}

variable "namespace" {
  description = "Namespace for the Kubernetes service account"
  type        = string
  default     = "default"
}

variable "use_existing_k8s_sa" {
  description = "Use an existing kubernetes service account instead of creating one"
  type        = bool
  default     = false
}

variable "annotate_k8s_sa" {
  description = "Annotate the kubernetes service account with 'iam.gke.io/gcp-service-account' annotation. Valid in cases when an existing SA is used."
  type        = bool
  default     = true
}

variable "automount_service_account_token" {
  description = "Enable automatic mounting of the service account token"
  type        = bool
  default     = false
}

variable "roles" {
  description = "A list of roles to be added to the created service account"
  type        = list(string)
  default     = []
}

variable "impersonate_service_account" {
  description = "An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials."
  type        = string
  default     = ""
}

variable "use_existing_context" {
  description = "An optional flag to use local kubectl config context."
  type        = bool
  default     = false
}

variable "module_depends_on" {
  description = "List of modules or resources to depend on before annotating KSA. If multiple, all items must be the same type."
  type        = list(any)
  default     = []
}

variable "additional_projects" {
  description = "A list of roles to be added to the created service account for additional projects"
  type        = map(list(string))
  default     = {}
}

variable "gcp_sa_display_name" {
  description = "The Google service account display name; if null, a default string will be used"
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.gcp_sa_display_name == null ? true : length(var.gcp_sa_display_name) <= 100
    error_message = "The Google service account display name must be at most 100 characters"
  }
}

variable "gcp_sa_description" {
  description = "The Service Google service account desciption; if null, will be left out"
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.gcp_sa_description == null ? true : length(var.gcp_sa_description) <= 256
    error_message = "The Google service account description must be at most 256 characters"
  }
}

variable "gcp_sa_create_ignore_already_exists" {
  description = "If set to true, skip service account creation if a service account with the same email already exists."
  type        = bool
  default     = null
}
