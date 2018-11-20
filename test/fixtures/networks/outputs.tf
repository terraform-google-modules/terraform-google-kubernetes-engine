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

output "project_id" {
  value = "${var.project_id}"
}

output "credentials_path" {
  value = "${local.credentials_path}"
}

output "region" {
  value = "${var.region}"
}

output "network" {
  value = "${google_compute_network.main.name}"
}

output "subnetwork" {
  value = {
    deploy-service = "${google_compute_subnetwork.example-deploy_service.name}"
    node-pool = "${google_compute_subnetwork.example-node_pool.name}"
    simple-regional = "${google_compute_subnetwork.example-simple_regional.name}"
    simple-zonal = "${google_compute_subnetwork.example-simple_zonal.name}"
    stub-domains = "${google_compute_subnetwork.example-stub_domains.name}"
  }
}

output "ip_range_pods" {
  value = {
    deploy-service = "${google_compute_subnetwork.example-deploy_service.secondary_ip_range.0.range_name}"
    node-pool = "${google_compute_subnetwork.example-node_pool.secondary_ip_range.0.range_name}"
    simple-regional = "${google_compute_subnetwork.example-simple_regional.secondary_ip_range.0.range_name}"
    simple-zonal = "${google_compute_subnetwork.example-simple_zonal.secondary_ip_range.0.range_name}"
    stub-domains = "${google_compute_subnetwork.example-stub_domains.secondary_ip_range.0.range_name}"
  }
}

output "ip_range_services" {
  value = {
    deploy-service = "${google_compute_subnetwork.example-deploy_service.secondary_ip_range.1.range_name}"
    node-pool = "${google_compute_subnetwork.example-node_pool.secondary_ip_range.1.range_name}"
    simple-regional = "${google_compute_subnetwork.example-simple_regional.secondary_ip_range.1.range_name}"
    simple-zonal = "${google_compute_subnetwork.example-simple_zonal.secondary_ip_range.1.range_name}"
    stub-domains = "${google_compute_subnetwork.example-stub_domains.secondary_ip_range.1.range_name}"
  }
}
