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
  type        = string
  description = "The project ID to host the cluster in."
}

variable "region" {
  type        = string
  description = "The region to host the cluster in."
  default     = "us-central1"
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the nodes in. The nodes must be in a zone that supports NVIDIA Confidential Computing. For more information, [view supported zones](https://cloud.google.com/confidential-computing/confidential-vm/docs/supported-configurations#nvidia-confidential-computing_1)."
  default     = ["us-central1-a"]
}
