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

# variable "asm_dir" {
#   description = "Name of directory to keep ASM resource config files."
#   type        = string
#   default     = "asm-dir"
# }

variable "service_account_key_file" {
  description = "Path to service account key file to auth as for running `gcloud container clusters get-credentials`."
  default     = ""
}

variable "asm_version" {
  description = "ASM version to deploy. This module supports versions `1.8`, `1.9` and `1.10`. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages"
  type        = string
  default     = "1.9"
}

variable "asm_git_tag" {
  description = "ASM git tag to deploy. This module supports versions `1.8`, `1.9` and `1.10`. You can get the exact `asm_git_tag` by running the command `install_asm --version`. The ASM git tab should be of the form `1.9.3-asm.2+config5`. You can also see all ASM git tags by running `curl https://storage.googleapis.com/csm-artifacts/asm/STABLE_VERSIONS`. You must provide the full and exact git tag. This variable is optional. Leaving it empty (default) will download the latest `install_asm` script for the version provided by the `asm_version` variable."
  type        = string
  default     = ""
}

variable "mode" {
  description = "ASM mode for deployment. Supported modes are `install` and `upgrade`."
  type        = string
  default     = "install"
}

variable "service_account" {
  description = "The GCP Service Account email address used to deploy ASM."
  type        = string
  default     = ""
}

variable "key_file" {
  description = "The GCP Service Account credentials file path used to deploy ASM."
  type        = string
  default     = ""
}

variable "managed_control_plane" {
  description = "ASM managed control plane boolean. Determines whether to install ASM managed control plane. Installing ASM managed control plane does not install gateways. Documentation on how to install gateways with ASM MCP can be found at https://cloud.google.com/service-mesh/docs/managed-control-plane#install_istio_gateways_optional."
  type        = bool
  default     = false
}

variable "impersonate_service_account" {
  type        = string
  description = "An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials."
  default     = ""
}

variable "options" {
  description = "Comma separated list of options. Works with in-cluster control plane only. Supported options are documented in https://cloud.google.com/service-mesh/docs/enable-optional-features."
  type        = list(any)
  default     = []
}

variable "custom_overlays" {
  description = "Comma separated list of custom_overlay file paths. Works with in-cluster control plane only. Additional documentation available at https://cloud.google.com/service-mesh/docs/scripted-install/gke-install#installation_with_an_overlay_file"
  type        = list(any)
  default     = []
}

variable "skip_validation" {
  description = "Sets `_CI_NO_VALIDATE` variable. Determines whether the script should perform validation checks for prerequisites such as IAM roles, Google APIs etc."
  type        = bool
  default     = false
}

variable "enable_all" {
  description = "Sets `--enable_all` option if true."
  type        = bool
  default     = false
}

variable "enable_cluster_roles" {
  description = "Sets `--enable_cluster_roles` option if true."
  type        = bool
  default     = false
}

variable "enable_cluster_labels" {
  description = "Sets `--enable_cluster_labels` option if true."
  type        = bool
  default     = false
}

variable "enable_gcp_apis" {
  description = "Sets `--enable_gcp_apis` option if true."
  type        = bool
  default     = false
}

variable "enable_gcp_iam_roles" {
  description = "Grants IAM roles required for ASM if true. If enable_gcp_iam_roles, one of impersonate_service_account, service_account, or iam_member must be set."
  type        = bool
  default     = false
}

variable "enable_gcp_components" {
  description = "Sets --enable_gcp_components option if true. Can be true or false. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages"
  type        = bool
  default     = false
}

variable "enable_registration" {
  description = "Sets `--enable_registration` option if true."
  type        = bool
  default     = false
}

variable "enable_namespace_creation" {
  description = "Sets `--enable_namespace_creation` option if true."
  type        = bool
  default     = false
}

variable "outdir" {
  description = "Sets `--outdir` option."
  type        = string
  default     = "none"
}

variable "ca" {
  description = "Sets CA option. Possible values are `meshca` or `citadel`. Additional documentation on Citadel is available at https://cloud.google.com/service-mesh/docs/scripted-install/gke-install#installation_with_citadel_as_the_ca."
  type        = string
  default     = "meshca"
}

variable "ca_certs" {
  description = "Sets CA certificate file paths when `ca` is set to `citadel`. These values must be provided when using Citadel as CA. Additional documentation on Citadel is available at https://cloud.google.com/service-mesh/docs/scripted-install/gke-install#installation_with_citadel_as_the_ca."
  type        = map(any)
  default     = {}
  # default = {
  #   "ca_cert"    = "none"
  #   "ca_key"     = "none"
  #   "root_cert"  = "none"
  #   "cert_chain" = "none"
  # }
  validation {
    condition     = contains([4, 0], length(compact([for k in ["ca_cert", "ca_key", "root_cert", "cert_chain"] : lookup(var.ca_certs, k, "")])))
    error_message = "One or more required keys for ca_certs are missing. If you plan to use the self-signed certificate, do not declare the ca_certs variable."
  }
}

variable "iam_member" {
  description = "The GCP member email address to grant IAM roles to. If impersonate_service_account or service_account is set, roles are granted to that SA."
  type        = string
  default     = ""
}

variable "revision_name" {
  description = "Sets `--revision-name` option."
  type        = string
  default     = "none"
}
