/*
Copyright 2018 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

variable "cluster_name" {
  description = ""
  default     = "test-cluster"
}

variable "project_id" {
  description = ""
}

variable "members" {
  // https://www.terraform.io/docs/configuration/variables.html#declaring-an-input-variable
  type = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
}

variable "region" {
  description = ""
  default     = "us-west1"
}
variable "zones" {
  description = ""
  default     = ["us-west1-c", "us-west1-b"]
}
