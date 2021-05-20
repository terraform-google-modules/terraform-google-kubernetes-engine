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
  description = "GCP cluster name used to reach cluster and which becomes the cluster name in the Config Sync kubernetes custom resource."
  type        = string
}

variable "project_id" {
  description = "GCP project_id used to reach cluster."
  type        = string
}

variable "location" {
  description = "GCP location used to reach cluster."
  type        = string
}

variable "operator_path" {
  description = "Path to the operator yaml config. If unset, will download from `var.operator_latest_manifest_url`."
  type        = string
  default     = null
}

variable "operator_latest_manifest_url" {
  description = "Url to the latest downloadable manifest for the operator. To be supplied by operator module providers, not end users."
  type        = string
}

variable "enable_multi_repo" {
  description = "Whether to use Config Sync [multi-repo mode](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/multi-repo)."
  type        = bool
  default     = false
}

variable "sync_repo" {
  description = "ACM Git repo address"
  type        = string
}

variable "secret_type" {
  description = "git authentication secret type, is passed through to ConfigManagement spec.git.secretType. Overriden to value 'ssh' if `create_ssh_key` is true"
  type        = string
}

variable "secret_ref_name" {
  description = "Name of Secret to use for authentication (Config Sync multi-repo setup only). If un-set, uses Config Management default."
  type        = string
  default     = ""
}

variable "sync_branch" {
  description = "ACM repo Git branch. If un-set, uses Config Management default."
  type        = string
  default     = ""
}

variable "sync_revision" {
  description = "ACM repo Git revision. If un-set, uses Config Management default."
  type        = string
  default     = ""
}

variable "policy_dir" {
  description = "Subfolder containing configs in ACM Git repo. If un-set, uses Config Management default."
  type        = string
  default     = ""
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint."
  type        = string
}

variable "operator_credential_name" {
  description = "Allows calling modules to specify the name of operator credentials to match what is expected."
  type        = string
}
variable "operator_credential_namespace" {
  description = "Allows calling modules to specify the namespace for the operator credential to match what is expected."
  type        = string
}

variable "create_ssh_key" {
  description = "Controls whether a key will be generated for Git authentication"
  type        = bool
  default     = true
}

variable "ssh_auth_key" {
  description = "Key for Git authentication. Overrides 'create_ssh_key' variable. Can be set using 'file(path/to/file)'-function."
  type        = string
  default     = null
}

variable "enable_policy_controller" {
  description = "Whether to enable the ACM Policy Controller on the cluster"
  type        = bool
  default     = false
}

variable "install_template_library" {
  description = "Whether to install the default Policy Controller template library"
  type        = bool
  default     = false
}

variable "operator_cr_template_path" {
  description = "path to template file to use for the operator"
  type        = string
}

variable "rootsync_cr_template_path" {
  description = "path to template file to use for the root sync definition (Config Sync multi-repo setup only)"
  type        = string
}

variable "source_format" {
  description = <<EOF
    Configures a non-hierarchical repo if set to 'unstructured'. Uses [Config Sync defaults](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/installing#configuring-config-management-operator)
    when unset.
  EOF
  type        = string
  default     = ""
}

variable "hierarchy_controller" {
  description = <<EOF
    Configurations for Hierarchy Controller. See [Hierarchy Controller docs](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/installing-hierarchy-controller)
    for more details
  EOF
  type        = map(any)
  default     = null
}

variable "enable_log_denies" {
  description = "Whether to enable logging of all denies and dryrun failures for ACM Policy Controller."
  type        = bool
  default     = false
}

variable "service_account_key_file" {
  description = "Path to service account key file to auth as for running `gcloud container clusters get-credentials`."
  default     = ""
}

variable "use_existing_context" {
  description = "Use existing kubecontext to auth kube-api. Useful when working with to non GKE clusters"
  type        = bool
  default     = false
}

variable "impersonate_service_account" {
  type        = string
  description = "An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials."
  default     = ""
}
