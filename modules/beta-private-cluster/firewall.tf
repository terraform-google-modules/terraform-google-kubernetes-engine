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

// This file was automatically generated from a template in ./autogen/main


/******************************************
  Match the gke-<CLUSTER>-<ID>-all INGRESS
  firewall rule created by GKE but for EGRESS

  Required for clusters when VPCs enforce
  a default-deny egress rule
 *****************************************/
resource "google_compute_firewall" "intra_egress" {
  count       = var.add_cluster_firewall_rules ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(25, length(var.name)))}-intra-cluster-egress"
  description = "Managed by terraform gke module: Allow pods to communicate with each other and the master"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "EGRESS"

  target_tags = [local.cluster_network_tag]
  destination_ranges = compact([
    local.cluster_endpoint_for_nodes,
    local.cluster_subnet_cidr,
    local.cluster_alias_ranges_cidr[var.ip_range_pods],
    google_container_cluster.primary.tpu_ipv4_cidr_block,
  ])

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

}


/******************************************
  Allow GKE master to hit non 443 ports for
  Webhooks/Admission Controllers

  https://github.com/kubernetes/kubernetes/issues/79739
 *****************************************/
resource "google_compute_firewall" "master_webhooks" {
  count       = var.add_cluster_firewall_rules ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(25, length(var.name)))}-webhooks"
  description = "Managed by terraform gke module: Allow master to hit pods for admission controllers/webhooks"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = var.firewall_inbound_ports
  }


}
