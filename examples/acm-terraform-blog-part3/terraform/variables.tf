/**
 * Copyright 2021 Google LLC
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

variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
}

variable "region" {
  type        = string
  description = "the GCP region where the cluster will be created"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "the GCP zone in the region where the cluster will be created"
  default     = "us-central1-c"
}

variable "sync_repo" {
  type        = string
  description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
  default     = "https://github.com/AlexBulankou/terraform-google-kubernetes-engine.git"
}

variable "sync_branch" {
  type        = string
  description = "the git branch in the repo to sync"
  default     = "master"
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default     = "examples/acm-terraform-blog-part3/config-root"
}
