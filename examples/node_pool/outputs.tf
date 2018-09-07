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

output "name_example" {
  description = "Cluster name"
  value       = "${module.gke.name}"
}

output "endpoint_example" {
  description = "Cluster endpoint"
  value       = "${module.gke.endpoint}"
}

output "location_example" {
  description = "Cluster location"
  value       = "${module.gke.location}"
}

output "zones_example" {
  description = "List of zones in which the cluster resides"
  value       = "${module.gke.zones}"
}

output "node_pools_names_example" {
  value = "${module.gke.node_pools_names}"
}

output "node_pools_versions_example" {
  value = "${module.gke.node_pools_versions}"
}
