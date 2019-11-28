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

// This file was automatically generated from a template in ./autogen

/******************************************
  Create Container Cluster
 *****************************************/
resource "google_container_cluster" "primary" {
  provider = google-beta

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.cluster_resource_labels

  location          = local.location
  node_locations    = local.node_locations
  cluster_ipv4_cidr = var.cluster_ipv4_cidr
  network           = data.google_compute_network.gke_network.self_link

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  dynamic "release_channel" {
    for_each = local.release_channel

    content {
      channel = release_channel.value.channel
    }
  }

  subnetwork         = data.google_compute_subnetwork.gke_subnetwork.self_link
  min_master_version = local.master_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  cluster_autoscaling {
    enabled = var.cluster_autoscaling.enabled
    dynamic "resource_limits" {
      for_each = local.autoscalling_resource_limits
      content {
        resource_type = lookup(resource_limits.value, "resource_type")
        minimum       = lookup(resource_limits.value, "minimum")
        maximum       = lookup(resource_limits.value, "maximum")
      }
    }
  }

  enable_binary_authorization = var.enable_binary_authorization
  enable_intranode_visibility = var.enable_intranode_visibility
  default_max_pods_per_node   = var.default_max_pods_per_node
  enable_shielded_nodes       = var.enable_shielded_nodes

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  dynamic "pod_security_policy_config" {
    for_each = var.pod_security_policy_config
    content {
      enabled = pod_security_policy_config.value.enabled
    }
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_dataset_id != "" ? [var.resource_usage_export_dataset_id] : []
    content {
      enable_network_egress_metering = true
      bigquery_destination {
        dataset_id = resource_usage_export_config.value
      }
    }
  }
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

    istio_config {
      disabled = ! var.istio
    }

    dynamic "cloudrun_config" {
      for_each = local.cluster_cloudrun_config

      content {
        disabled = cloudrun_config.value.disabled
      }
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
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    node_config {
      service_account = lookup(var.node_pools[0], "service_account", local.service_account)

      dynamic "workload_metadata_config" {
        for_each = local.cluster_node_metadata_config

        content {
          node_metadata = workload_metadata_config.value.node_metadata
        }
      }
    }
  }


  remove_default_node_pool = var.remove_default_node_pool

  dynamic "database_encryption" {
    for_each = var.database_encryption

    content {
      key_name = database_encryption.value.key_name
      state    = database_encryption.value.state
    }
  }

  dynamic "workload_identity_config" {
    for_each = local.cluster_workload_identity_config

    content {
      identity_namespace = workload_identity_config.value.identity_namespace
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = local.cluster_authenticator_security_group
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }
}

/******************************************
  Create Container Cluster node pools
 *****************************************/
resource "google_container_node_pool" "pools" {
  provider = google-beta
  count    = length(var.node_pools)
  name     = var.node_pools[count.index]["name"]
  project  = var.project_id
  location = local.location
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(var.node_pools[count.index], "node_locations", "") != "" ? split(",", var.node_pools[count.index]["node_locations"]) : null

  cluster = google_container_cluster.primary.name

  version = lookup(var.node_pools[count.index], "auto_upgrade", false) ? "" : lookup(
    var.node_pools[count.index],
    "version",
    local.node_version,
  )

  initial_node_count = lookup(var.node_pools[count.index], "autoscaling", true) ? lookup(
    var.node_pools[count.index],
    "initial_node_count",
    lookup(var.node_pools[count.index], "min_count", 1)
  ) : null

  max_pods_per_node = lookup(var.node_pools[count.index], "max_pods_per_node", null)

  node_count = lookup(var.node_pools[count.index], "autoscaling", true) ? null : lookup(var.node_pools[count.index], "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(var.node_pools[count.index], "autoscaling", true) ? [var.node_pools[count.index]] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 100)
    }
  }

  management {
    auto_repair  = lookup(var.node_pools[count.index], "auto_repair", true)
    auto_upgrade = lookup(var.node_pools[count.index], "auto_upgrade", local.default_auto_upgrade)
  }

  node_config {
    image_type   = lookup(var.node_pools[count.index], "image_type", "COS")
    machine_type = lookup(var.node_pools[count.index], "machine_type", "n1-standard-2")
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = var.node_pools[count.index]["name"] } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[var.node_pools[count.index]["name"]],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", true) ? { "node_pool" = var.node_pools[count.index]["name"] } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[var.node_pools[count.index]["name"]],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[var.node_pools[count.index]["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    tags = concat(
      lookup(local.node_pools_tags, "default_values", [true, true])[0] ? ["gke-${var.name}"] : [],
      lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["gke-${var.name}-${var.node_pools[count.index]["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[var.node_pools[count.index]["name"]],
    )

    local_ssd_count = lookup(var.node_pools[count.index], "local_ssd_count", 0)
    disk_size_gb    = lookup(var.node_pools[count.index], "disk_size_gb", 100)
    disk_type       = lookup(var.node_pools[count.index], "disk_type", "pd-standard")

    service_account = lookup(
      var.node_pools[count.index],
      "service_account",
      local.service_account,
    )
    preemptible = lookup(var.node_pools[count.index], "preemptible", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[var.node_pools[count.index]["name"]],
    )

    guest_accelerator = [
      for guest_accelerator in lookup(var.node_pools[count.index], "accelerator_count", 0) > 0 ? [{
        type  = lookup(var.node_pools[count.index], "accelerator_type", "")
        count = lookup(var.node_pools[count.index], "accelerator_count", 0)
        }] : [] : {
        type  = guest_accelerator["type"]
        count = guest_accelerator["count"]
      }
    ]

    dynamic "workload_metadata_config" {
      for_each = local.cluster_node_metadata_config

      content {
        node_metadata = workload_metadata_config.value.node_metadata
      }
    }

    dynamic "sandbox_config" {
      for_each = local.cluster_sandbox_enabled

      content {
        sandbox_type = sandbox_config.value
      }
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]

  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "null_resource" "wait_for_cluster" {
  count = var.skip_provisioners ? 0 : 1

  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-cluster.sh ${var.project_id} ${var.name}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/wait-for-cluster.sh ${var.project_id} ${var.name}"
  }

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.pools,
  ]
}
