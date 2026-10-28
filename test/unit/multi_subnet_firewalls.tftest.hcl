# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# All providers are mocked; these tests do not create cloud resources.
mock_provider "google" {
  mock_data "google_compute_subnetwork" {
    defaults = {
      ip_cidr_range = "10.0.0.0/24"
      secondary_ip_range = [
        { range_name = "pods", ip_cidr_range = "10.1.0.0/20" },
        { range_name = "extra-pods", ip_cidr_range = "10.2.0.0/20" },
        { range_name = "services", ip_cidr_range = "10.3.0.0/24" },
      ]
    }
  }

  mock_resource "google_container_cluster" {
    defaults = {
      endpoint = "192.0.2.1"
    }
  }
}

mock_provider "kubernetes" {}
mock_provider "random" {}
mock_provider "google-beta" {
  mock_resource "google_container_cluster" {
    defaults = {
      endpoint = "192.0.2.1"
    }
  }
}

variables {
  project_id                 = "test-project"
  name                       = "multi-subnet-test"
  region                     = "europe-west1"
  zones                      = ["europe-west1-b"]
  network                    = "test-network"
  subnetwork                 = "default-subnet"
  ip_range_pods              = "pods"
  ip_range_services          = "services"
  kubernetes_version         = "1.35.0-gke.1"
  dns_allow_external_traffic = false
  create_service_account     = false
  service_account            = "nodes@test-project.iam.gserviceaccount.com"
  add_cluster_firewall_rules = true
  add_shadow_firewall_rules  = true
}

run "default_subnet_is_unchanged" {
  command = apply

  variables {
    additional_ip_range_pods = ["extra-pods"]
    node_pools               = [{ name = "default-pool", pod_range = "pods" }]
  }

  assert {
    condition     = toset(google_compute_firewall.intra_egress[0].destination_ranges) == toset(["192.0.2.1/32", "10.0.0.0/24", "10.1.0.0/20", "10.2.0.0/20"])
    error_message = "Existing node and Pod firewall ranges must be preserved without additional subnets."
  }

  assert {
    condition     = toset(google_compute_firewall.shadow_allow_nodes[0].source_ranges) == toset(["10.0.0.0/24"])
    error_message = "The default node subnet must remain the only node source range."
  }
}

run "additional_subnet_pod_range" {
  command = apply

  variables {
    additional_ip_ranges_config = [{ subnetwork = "ci-subnet", pod_ipv4_range_names = ["ci-pods"] }]
    node_pools                  = [{ name = "ci-pool", subnetwork = "ci-subnet", pod_range = "ci-pods" }]
  }

  override_data {
    target = data.google_compute_subnetwork.additional_gke_subnetwork["0"]
    values = {
      ip_cidr_range = "10.4.0.0/24"
      secondary_ip_range = [
        { range_name = "ci-pods", ip_cidr_range = "10.5.0.0/20" },
        { range_name = "unused-pods", ip_cidr_range = "10.6.0.0/20" },
      ]
    }
  }

  assert {
    condition     = toset(google_compute_firewall.intra_egress[0].destination_ranges) == toset(["192.0.2.1/32", "10.0.0.0/24", "10.4.0.0/24", "10.1.0.0/20", "10.5.0.0/20"])
    error_message = "Egress must include additional node and registered Pod ranges, but not unrelated secondary ranges."
  }

  assert {
    condition     = toset(google_compute_firewall.shadow_allow_nodes[0].source_ranges) == toset(["10.0.0.0/24", "10.4.0.0/24"])
    error_message = "Shadow node rules must include additional primary ranges."
  }

  assert {
    condition     = toset(google_compute_firewall.shadow_allow_pods[0].source_ranges) == toset(["10.1.0.0/20", "10.5.0.0/20"]) && toset(google_compute_firewall.shadow_allow_inkubelet[0].source_ranges) == toset(["10.1.0.0/20", "10.5.0.0/20"])
    error_message = "Both shadow Pod rules must include the additional Pod range."
  }
}

run "full_subnet_path_and_duplicate_range_names" {
  command = apply

  variables {
    network_project_id          = "host-project"
    additional_ip_ranges_config = [{ subnetwork = "projects/host-project/regions/europe-west1/subnetworks/ci-subnet", pod_ipv4_range_names = ["pods", "ci-extra-pods"] }]
    node_pools                  = [{ name = "ci-pool", subnetwork = "projects/host-project/regions/europe-west1/subnetworks/ci-subnet", pod_range = "pods" }]
    windows_node_pools          = [{ name = "windows-pool", subnetwork = "ci-subnet", pod_range = "ci-extra-pods" }]
  }

  override_data {
    target = data.google_compute_subnetwork.additional_gke_subnetwork["0"]
    values = {
      ip_cidr_range = "10.4.0.0/24"
      secondary_ip_range = [
        { range_name = "pods", ip_cidr_range = "10.5.0.0/20" },
        { range_name = "ci-extra-pods", ip_cidr_range = "10.6.0.0/20" },
      ]
    }
  }

  assert {
    condition     = data.google_compute_subnetwork.additional_gke_subnetwork["0"].name == "ci-subnet" && data.google_compute_subnetwork.additional_gke_subnetwork["0"].project == "host-project" && data.google_compute_subnetwork.additional_gke_subnetwork["0"].region == "europe-west1"
    error_message = "Additional subnet lookup must accept full paths and use the Shared VPC host project."
  }

  assert {
    condition     = local.pod_all_ip_ranges == tolist(["10.1.0.0/20", "10.5.0.0/20", "10.6.0.0/20", "10.5.0.0/20", "10.6.0.0/20"])
    error_message = "Node-pool Pod ranges must resolve within their subnet, even when secondary range names are reused."
  }
}

run "private_cluster_additional_ranges_without_pool_override" {
  command = apply

  module {
    source = "./modules/private-cluster"
  }

  variables {
    additional_ip_ranges_config = [{ subnetwork = "ci-subnet", pod_ipv4_range_names = ["ci-pods"] }]
    master_ipv4_cidr_block      = "172.16.0.0/28"
    enable_private_nodes        = true
  }

  override_data {
    target = data.google_compute_subnetwork.additional_gke_subnetwork["0"]
    values = {
      ip_cidr_range      = "10.4.0.0/24"
      secondary_ip_range = [{ range_name = "ci-pods", ip_cidr_range = "10.5.0.0/20" }]
    }
  }

  assert {
    condition     = toset(google_compute_firewall.intra_egress[0].destination_ranges) == toset(["172.16.0.0/28", "10.0.0.0/24", "10.4.0.0/24", "10.1.0.0/20", "10.5.0.0/20"])
    error_message = "Private clusters must include registered additional ranges even when GKE selects the node-pool subnet automatically."
  }
}

run "shadow_rules_only" {
  command = apply

  variables {
    add_cluster_firewall_rules  = false
    additional_ip_ranges_config = [{ subnetwork = "ci-subnet", pod_ipv4_range_names = ["ci-pods"] }]
  }

  override_data {
    target = data.google_compute_subnetwork.additional_gke_subnetwork["0"]
    values = {
      ip_cidr_range      = "10.4.0.0/24"
      secondary_ip_range = [{ range_name = "ci-pods", ip_cidr_range = "10.5.0.0/20" }]
    }
  }

  assert {
    condition     = length(google_compute_firewall.intra_egress) == 0 && toset(google_compute_firewall.shadow_allow_nodes[0].source_ranges) == toset(["10.0.0.0/24", "10.4.0.0/24"]) && toset(google_compute_firewall.shadow_allow_pods[0].source_ranges) == toset(["10.1.0.0/20", "10.5.0.0/20"])
    error_message = "Additional ranges must be resolved when only shadow firewall rules are enabled."
  }
}

run "beta_update_variant_egress_only" {
  command = apply

  module {
    source = "./modules/beta-public-cluster-update-variant"
  }

  variables {
    add_shadow_firewall_rules   = false
    additional_ip_ranges_config = [{ subnetwork = "ci-subnet", pod_ipv4_range_names = ["ci-pods"] }]
    node_pools                  = [{ name = "ci-pool", subnetwork = "ci-subnet", pod_range = "ci-pods" }]
  }

  override_data {
    target = data.google_compute_subnetwork.additional_gke_subnetwork["0"]
    values = {
      ip_cidr_range      = "10.4.0.0/24"
      secondary_ip_range = [{ range_name = "ci-pods", ip_cidr_range = "10.5.0.0/20" }]
    }
  }

  assert {
    condition     = length(google_compute_firewall.shadow_allow_nodes) == 0 && toset(google_compute_firewall.intra_egress[0].destination_ranges) == toset(["192.0.2.1/32", "10.0.0.0/24", "10.4.0.0/24", "10.1.0.0/20", "10.5.0.0/20"])
    error_message = "Beta update variants must include additional ranges when only cluster firewall rules are enabled."
  }
}

run "autopilot_registered_ranges" {
  command = apply

  module {
    source = "./modules/beta-autopilot-public-cluster"
  }

  variables {
    additional_ip_ranges_config = [{ subnetwork = "https://www.googleapis.com/compute/v1/projects/host-project/regions/europe-west1/subnetworks/ci-subnet", pod_ipv4_range_names = ["ci-pods"] }]
  }

  override_data {
    target = data.google_compute_subnetwork.additional_gke_subnetwork["0"]
    values = {
      ip_cidr_range      = "10.4.0.0/24"
      secondary_ip_range = [{ range_name = "ci-pods", ip_cidr_range = "10.5.0.0/20" }]
    }
  }

  assert {
    condition     = data.google_compute_subnetwork.additional_gke_subnetwork["0"].name == "ci-subnet" && data.google_compute_subnetwork.additional_gke_subnetwork["0"].project == "host-project" && toset(google_compute_firewall.intra_egress[0].destination_ranges) == toset(["192.0.2.1/32", "10.0.0.0/24", "10.4.0.0/24", "10.1.0.0/20", "10.5.0.0/20"])
    error_message = "Autopilot clusters must resolve registered subnet self-links and include their node and Pod CIDRs."
  }
}

run "firewalls_disabled" {
  command = apply

  variables {
    add_cluster_firewall_rules  = false
    add_shadow_firewall_rules   = false
    additional_ip_ranges_config = [{ subnetwork = "ci-subnet", pod_ipv4_range_names = ["ci-pods"] }]
    node_pools                  = [{ name = "ci-pool", subnetwork = "ci-subnet", pod_range = "ci-pods" }]
  }

  assert {
    condition     = length(data.google_compute_subnetwork.additional_gke_subnetwork) == 0 && length(google_compute_firewall.intra_egress) == 0 && length(google_compute_firewall.shadow_allow_nodes) == 0
    error_message = "Disabling firewall management must not read additional subnets or create firewall rules."
  }
}
