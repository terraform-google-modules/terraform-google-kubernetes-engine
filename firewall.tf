/**
 * Copyright 2022 Google LLC
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
locals {
  rule_name_base = (
    var.add_firewall_rule_name_unique_suffix ?
    "${substr(var.name, 0, min(31, length(var.name)))}-${random_string.google_compute_firewall_suffix[0].result}" :
    substr(var.name, 0, min(36, length(var.name)))
  )
}

resource "random_string" "google_compute_firewall_suffix" {
  count   = var.add_firewall_rule_name_unique_suffix ? 1 : 0
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_compute_firewall" "intra_egress" {
  count       = var.add_cluster_firewall_rules ? 1 : 0
  name        = "gke-${local.rule_name_base}-intra-cluster-egress"
  description = "Managed by terraform gke module: Allow pods to communicate with each other and the master"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "EGRESS"

  target_tags = [local.cluster_network_tag]
  destination_ranges = concat([
    local.cluster_endpoint_for_nodes,
    local.cluster_subnet_cidr,
    ],
    local.pod_all_ip_ranges
  )

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  depends_on = [
    google_container_cluster.primary,
  ]
}


/******************************************
  Allow GKE master to hit non 443 ports for
  Webhooks/Admission Controllers

  https://github.com/kubernetes/kubernetes/issues/79739
 *****************************************/
resource "google_compute_firewall" "master_webhooks" {
  count       = var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules ? 1 : 0
  name        = "gke-${local.rule_name_base}-webhooks"
  description = "Managed by terraform gke module: Allow master to hit pods for admission controllers/webhooks"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  source_tags   = []
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = var.firewall_inbound_ports
  }

  depends_on = [
    google_container_cluster.primary,
  ]

}


/******************************************
  Create shadow firewall rules to capture the
  traffic flow between the managed firewall rules
 *****************************************/
resource "google_compute_firewall" "shadow_allow_pods" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${local.rule_name_base}-all"
  description = "Managed by terraform gke module: A shadow firewall rule to match the default rule allowing pod communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = local.pod_all_ip_ranges
  target_tags   = [local.cluster_network_tag]

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_allow_master" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${local.rule_name_base}-master"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["10250", "443"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_allow_nodes" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${local.rule_name_base}-vms"
  description = "Managed by Terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_subnet_cidr]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_allow_inkubelet" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${local.rule_name_base}-inkubelet"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes & pods communication to kubelet."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority - 1 # rule created by GKE robot have prio 999
  direction   = "INGRESS"

  source_ranges = local.pod_all_ip_ranges
  source_tags   = [local.cluster_network_tag]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["10255"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_deny_exkubelet" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${local.rule_name_base}-exkubelet"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default deny rule to kubelet."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority # rule created by GKE robot have prio 1000
  direction   = "INGRESS"

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.cluster_network_tag]

  deny {
    protocol = "tcp"
    ports    = ["10255"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}
