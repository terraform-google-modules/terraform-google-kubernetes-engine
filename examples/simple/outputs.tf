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

output "cluster_name_example" {
  value = "${module.gke.cluster_name}"
}

output "region_example" {
  value = "${module.gke.region}"
}

output "endpoint_example" {
  value = "${module.gke.ca_certificate}"
}

output "ca_certificate_example" {
  value = "${module.gke.ca_certificate}"
}

output "min_master_version_example" {
  value = "${module.gke.min_master_version}"
}

output "master_version_example" {
  value = "${module.gke.master_version}"
}

output "node_version_example" {
  value = "${module.gke.node_version}"
}

output "http_load_balancing_example" {
  value = "${module.gke.http_load_balancing_enabled}"
}

output "horizontal_pod_autoscaling_example" {
  value = "${module.gke.horizontal_pod_autoscaling_enabled}"
}

output "kubernetes_dashboard_example" {
  value = "${module.gke.kubernetes_dashboard_enabled}"
}

output "node_pools_names_example" {
  value = "${module.gke.node_pools_names}"
}
