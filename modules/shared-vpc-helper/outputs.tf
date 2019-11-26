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

output "gke_service_project_id" {
  value       = var.gke_svpc_service_project
  description = "The project ID of the service account (to host the GKE cluster in)"

}

output "gke_host_project_id" {
  value       = var.gke_svpc_host_project
  description = "The project ID of the shared VPC's host"
}

output "gke_subnetwork" {
  value       = var.gke_subnetwork
  description = "The host account subnetwork to share with service account (to host the GKE cluster in)"
}

output "gke_service_account" {
  value       = var.gke_sa
  description = "The service account in a service project to run GKE cluster nodes"
}
