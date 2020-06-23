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

variable "project_ids" {
  type        = list(string)
  description = "The GCP projects to use for integration tests"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  default     = "us-central1"
}

variable "zones" {
  type        = list(string)
  description = "The GCP zones to create and test resources in, for applicable tests"
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}
