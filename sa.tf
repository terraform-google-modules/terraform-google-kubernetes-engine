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

// This file was automatically generated from a template in ./autogen

locals {
  service_account_list = "${compact(concat(google_service_account.cluster_service_account.*.email, list("dummy")))}"
  service_account = "${var.service_account == "create" ? element(local.service_account_list, 0) : var.service_account}"
}

resource "google_service_account" "cluster_service_account" {
  count        = "${var.service_account == "create" ? 1 : 0}"
  project      = "${var.project_id}"
  account_id   = "tf-gke-${substr(var.name, 0, 20)}"
  display_name = "Terraform-managed service account for cluster ${var.name}"
}