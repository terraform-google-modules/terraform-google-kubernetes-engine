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

output "id" {
  description = "an identifier for the resource with format {{project_id}}/{{location}}/{{cluster}}/{{name}}"
  value       = google_container_node_pool.main.id
}

output "instance_group_urls" {
  description = "The resource URLs of the managed instance groups associated with this node pool."
  value       = google_container_node_pool.main.instance_group_urls
}

output "managed_instance_group_urls" {
  description = "List of instance group URLs which have been assigned to this node pool."
  value       = google_container_node_pool.main.managed_instance_group_urls
}

output "name" {
  description = "The name of the node pool."
  value       = google_container_node_pool.main.name
}
