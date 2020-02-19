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
  Create Container Cluster
 *****************************************/
resource "google_container_cluster" "primary" {
  provider = google

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.cluster_resource_labels

  location          = local.location
  node_locations    = local.node_locations
  cluster_ipv4_cidr = var.cluster_ipv4_cidr
  network           = "projects/${local.network_project_id}/global/networks/${var.network}"

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }


  subnetwork = "projects/${local.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"

  min_master_version = local.master_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  master_auth {
    username = var.basic_auth_username
    password = var.basic_auth_password

    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = ! var.horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = ! var.network_policy
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  lifecycle {
    ignore_changes = [node_pool, initial_node_count]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    node_config {
      service_account = lookup(var.node_pools[0], "service_account", local.service_account)
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes    = var.enable_private_nodes,
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }] : []

    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  remove_default_node_pool = var.remove_default_node_pool
}

/******************************************
  Create Container Cluster node pools
 *****************************************/
locals {
  force_node_pool_recreation_resources = [
    "disk_size_gb",
    "disk_type",
    "accelerator_count",
    "accelerator_type",
    "local_ssd_count",
    "machine_type",
    "preemptible",
    "service_account",
  ]
}

# This keepers list is based on the terraform google provider schemaNodeConfig
# resources where "ForceNew" is "true". schemaNodeConfig can be found in node_config.go at
# https://github.com/terraform-providers/terraform-provider-google/blob/master/google/node_config.go#L22
resource "random_id" "name" {
  for_each    = local.node_pools
  byte_length = 2
  prefix      = format("%s-", lookup(each.value, "name"))
  keepers = merge(
    zipmap(
      local.force_node_pool_recreation_resources,
      [for keeper in local.force_node_pool_recreation_resources : lookup(each.value, keeper, "")]
    ),
    {
      labels = join(",",
        sort(
          concat(
            keys(local.node_pools_labels["all"]),
            values(local.node_pools_labels["all"]),
            keys(local.node_pools_labels[each.value["name"]]),
            values(local.node_pools_labels[each.value["name"]])
          )
        )
      )
    },
    {
      metadata = join(",",
        sort(
          concat(
            keys(local.node_pools_metadata["all"]),
            values(local.node_pools_metadata["all"]),
            keys(local.node_pools_metadata[each.value["name"]]),
            values(local.node_pools_metadata[each.value["name"]])
          )
        )
      )
    },
    {
      oauth_scopes = join(",",
        sort(
          concat(
            local.node_pools_oauth_scopes["all"],
            local.node_pools_oauth_scopes[each.value["name"]]
          )
        )
      )
    },
    {
      tags = join(",",
        sort(
          concat(
            local.node_pools_tags["all"],
            local.node_pools_tags[each.value["name"]]
          )
        )
      )
    }
  )
}

resource "google_container_node_pool" "pools" {
  provider = google
  for_each = local.node_pools
  name     = { for k, v in random_id.name : k => v.hex }[each.key]
  project  = var.project_id
  location = local.location

  cluster = google_container_cluster.primary.name

  version = lookup(each.value, "auto_upgrade", false) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.primary.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null


  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 100)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", local.default_auto_upgrade)
  }


  node_config {
    image_type   = lookup(each.value, "image_type", "COS")
    machine_type = lookup(each.value, "machine_type", "n1-standard-2")
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[each.value["name"]],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[each.value["name"]],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    tags = concat(
      lookup(local.node_pools_tags, "default_values", [true, true])[0] ? ["gke-${var.name}"] : [],
      lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["gke-${var.name}-${each.value["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[each.value["name"]],
    )

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")

    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )
    preemptible = lookup(each.value, "preemptible", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.value["name"]],
    )

    guest_accelerator = [
      for guest_accelerator in lookup(each.value, "accelerator_count", 0) > 0 ? [{
        type  = lookup(each.value, "accelerator_type", "")
        count = lookup(each.value, "accelerator_count", 0)
        }] : [] : {
        type  = guest_accelerator["type"]
        count = guest_accelerator["count"]
      }
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]

    create_before_destroy = true
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

resource "null_resource" "wait_for_cluster" {
  count = var.skip_provisioners ? 0 : 1

  triggers = {
    project_id = var.project_id
    name       = var.name
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-cluster.sh ${self.triggers.project_id} ${self.triggers.name}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/wait-for-cluster.sh ${self.triggers.project_id} ${self.triggers.name}"
  }

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.pools,
  ]
}
