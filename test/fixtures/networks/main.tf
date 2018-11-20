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

locals {
  credentials_path = "${path.module}/${var.credentials_path_relative}"
}

resource "random_string" "suffix" {
  length = 4
  special = false
  upper = false
}

provider "google" {
  credentials = "${file(local.credentials_path)}"
  project = "${var.project_id}"
}

resource "google_compute_network" "main" {
  name = "cft-gke-test-${random_string.suffix.result}"
  auto_create_subnetworks = "false"
}

// TODO clean up CIDRs

resource "google_compute_subnetwork" "example-deploy_service" {
  name = "cft-gke-test-deploy-service-${random_string.suffix.result}"
  ip_cidr_range = "10.0.32.0/20"
  region = "${var.region}"
  network = "${google_compute_network.main.self_link}"
  secondary_ip_range {
    range_name = "cft-gke-test-deploy-service-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.32.0/22"
  }
  secondary_ip_range {
    range_name = "cft-gke-test-deploy-service-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.36.0/22"
  }
}

resource "google_compute_subnetwork" "example-node_pool" {
  name = "cft-gke-test-node-pool-${random_string.suffix.result}"
  ip_cidr_range = "10.0.128.0/17"
  region = "${var.region}"
  network = "${google_compute_network.main.self_link}"
  secondary_ip_range {
    range_name = "cft-gke-test-node-pool-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.128.0/18"
  }
  secondary_ip_range {
    range_name = "cft-gke-test-node-pool-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.192.0/18"
  }
}

resource "google_compute_subnetwork" "example-simple_regional" {
  name = "cft-gke-test-simple-regional-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/20"
  region = "${var.region}"
  network = "${google_compute_network.main.self_link}"
  secondary_ip_range {
    range_name = "cft-gke-test-simple-regional-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.8.0/22"
  }
  secondary_ip_range {
    range_name = "cft-gke-test-simple-regional-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.12.0/22"
  }
}

resource "google_compute_subnetwork" "example-simple_zonal" {
  name = "cft-gke-test-simple-zonal-${random_string.suffix.result}"
  ip_cidr_range = "10.0.48.0/20"
  region = "${var.region}"
  network = "${google_compute_network.main.self_link}"
  secondary_ip_range {
    range_name = "cft-gke-test-simple-zonal-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.48.0/22"
  }
  secondary_ip_range {
    range_name = "cft-gke-test-simple-zonal-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.52.0/22"
  }
}

resource "google_compute_subnetwork" "example-stub_domains" {
  name = "cft-gke-test-stub-domains-${random_string.suffix.result}"
  ip_cidr_range = "10.0.16.0/20"
  region = "${var.region}"
  network = "${google_compute_network.main.self_link}"
  secondary_ip_range {
    range_name = "cft-gke-test-stub-domains-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.24.0/22"
  }
  secondary_ip_range {
    range_name = "cft-gke-test-stub-domains-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.28.0/22"
  }
}
