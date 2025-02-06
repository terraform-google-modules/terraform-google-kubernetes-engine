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
  Create Container Cluster
 *****************************************/
resource "google_container_cluster" "primary" {
  provider = google-beta

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.cluster_resource_labels

  location            = local.location
  node_locations      = local.node_locations
  cluster_ipv4_cidr   = var.cluster_ipv4_cidr
  network             = "projects/${local.network_project_id}/global/networks/${var.network}"
  deletion_protection = var.deletion_protection

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

  dynamic "gateway_api_config" {
    for_each = local.gateway_api_config

    content {
      channel = gateway_api_config.value.channel
    }
  }

  dynamic "cost_management_config" {
    for_each = var.enable_cost_allocation ? [1] : []
    content {
      enabled = var.enable_cost_allocation
    }
  }

  dynamic "confidential_nodes" {
    for_each = local.confidential_node_config
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  subnetwork = "projects/${local.network_project_id}/regions/${local.region}/subnetworks/${var.subnetwork}"

  default_snat_status {
    disabled = var.disable_default_snat
  }

  min_master_version = var.release_channel == null || var.release_channel == "UNSPECIFIED" ? local.master_version : var.kubernetes_version == "latest" ? null : var.kubernetes_version

  dynamic "cluster_telemetry" {
    for_each = local.cluster_telemetry_type_is_set ? [1] : []
    content {
      type = var.cluster_telemetry_type
    }
  }
  dynamic "logging_config" {
    for_each = length(var.logging_enabled_components) > 0 ? [1] : []

    content {
      enable_components = var.logging_enabled_components
    }
  }

  dynamic "monitoring_config" {
    for_each = local.cluster_telemetry_type_is_set || local.logmon_config_is_set ? [1] : []
    content {
      enable_components = var.monitoring_enabled_components
      managed_prometheus {
        enabled = var.monitoring_enable_managed_prometheus == null ? false : var.monitoring_enable_managed_prometheus
      }
      advanced_datapath_observability_config {
        enable_metrics = var.monitoring_enable_observability_metrics
        enable_relay   = var.monitoring_enable_observability_relay
      }
    }
  }

  # only one of logging/monitoring_service or logging/monitoring_config can be specified
  logging_service    = local.cluster_telemetry_type_is_set || local.logmon_config_is_set ? null : var.logging_service
  monitoring_service = local.cluster_telemetry_type_is_set || local.logmon_config_is_set ? null : var.monitoring_service

  cluster_autoscaling {
    enabled = var.cluster_autoscaling.enabled
    dynamic "auto_provisioning_defaults" {
      for_each = var.cluster_autoscaling.enabled ? [1] : []

      content {
        service_account = local.service_account
        oauth_scopes    = local.node_pools_oauth_scopes["all"]

        boot_disk_kms_key = var.boot_disk_kms_key

        management {
          auto_repair  = lookup(var.cluster_autoscaling, "auto_repair", true)
          auto_upgrade = lookup(var.cluster_autoscaling, "auto_upgrade", true)
        }

        disk_size = lookup(var.cluster_autoscaling, "disk_size", 100)
        disk_type = lookup(var.cluster_autoscaling, "disk_type", "pd-standard")

        upgrade_settings {
          strategy        = lookup(var.cluster_autoscaling, "strategy", "SURGE")
          max_surge       = lookup(var.cluster_autoscaling, "strategy", "SURGE") == "SURGE" ? lookup(var.cluster_autoscaling, "max_surge", 0) : null
          max_unavailable = lookup(var.cluster_autoscaling, "strategy", "SURGE") == "SURGE" ? lookup(var.cluster_autoscaling, "max_unavailable", 0) : null

          dynamic "blue_green_settings" {
            for_each = lookup(var.cluster_autoscaling, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
            content {
              node_pool_soak_duration = lookup(var.cluster_autoscaling, "node_pool_soak_duration", null)

              standard_rollout_policy {
                batch_soak_duration = lookup(var.cluster_autoscaling, "batch_soak_duration", null)
                batch_percentage    = lookup(var.cluster_autoscaling, "batch_percentage", null)
                batch_node_count    = lookup(var.cluster_autoscaling, "batch_node_count", null)
              }
            }
          }
        }

        shielded_instance_config {
          enable_secure_boot          = lookup(var.cluster_autoscaling, "enable_secure_boot", false)
          enable_integrity_monitoring = lookup(var.cluster_autoscaling, "enable_integrity_monitoring", true)
        }

        min_cpu_platform = lookup(var.cluster_autoscaling, "min_cpu_platform", "")

        image_type = lookup(var.cluster_autoscaling, "image_type", "COS_CONTAINERD")
      }
    }
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile != null ? var.cluster_autoscaling.autoscaling_profile : "BALANCED"
    dynamic "resource_limits" {
      for_each = local.autoscaling_resource_limits
      content {
        resource_type = resource_limits.value["resource_type"]
        minimum       = resource_limits.value["minimum"]
        maximum       = resource_limits.value["maximum"]
      }
    }
  }
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }
  default_max_pods_per_node = var.default_max_pods_per_node
  enable_shielded_nodes     = var.enable_shielded_nodes

  dynamic "binary_authorization" {
    for_each = var.enable_binary_authorization ? [var.enable_binary_authorization] : []
    content {
      evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
    }
  }

  dynamic "identity_service_config" {
    for_each = var.enable_identity_service != null ? [var.enable_identity_service] : []
    content {
      enabled = identity_service_config.value
    }
  }

  enable_kubernetes_alpha     = var.enable_kubernetes_alpha
  enable_tpu                  = var.enable_tpu
  enable_intranode_visibility = var.enable_intranode_visibility

  dynamic "pod_security_policy_config" {
    for_each = var.enable_pod_security_policy ? [var.enable_pod_security_policy] : []
    content {
      enabled = pod_security_policy_config.value
    }
  }

  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting

  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy

  dynamic "secret_manager_config" {
    for_each = var.enable_secret_manager_addon ? [var.enable_secret_manager_addon] : []
    content {
      enabled = secret_manager_config.value
    }
  }

  enable_fqdn_network_policy = var.enable_fqdn_network_policy
  dynamic "master_authorized_networks_config" {
    for_each = var.enable_private_endpoint || var.gcp_public_cidrs_access_enabled != null || length(var.master_authorized_networks) > 0 ? [true] : []
    content {
      gcp_public_cidrs_access_enabled = var.gcp_public_cidrs_access_enabled
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  dynamic "node_pool_auto_config" {
    for_each = var.cluster_autoscaling.enabled && (length(var.network_tags) > 0 || var.add_cluster_firewall_rules) ? [1] : []
    content {
      network_tags {
        tags = var.add_cluster_firewall_rules ? (concat(var.network_tags, [local.cluster_network_tag])) : var.network_tags
      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  dynamic "service_external_ips_config" {
    for_each = var.service_external_ips ? [1] : []
    content {
      enabled = var.service_external_ips
    }
  }

  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling
    }

    gcp_filestore_csi_driver_config {
      enabled = var.filestore_csi_driver
    }

    network_policy_config {
      disabled = !var.network_policy
    }

    dns_cache_config {
      enabled = var.dns_cache
    }

    dynamic "gce_persistent_disk_csi_driver_config" {
      for_each = local.cluster_gce_pd_csi_config

      content {
        enabled = gce_persistent_disk_csi_driver_config.value.enabled
      }
    }

    config_connector_config {
      enabled = var.config_connector
    }

    dynamic "gcs_fuse_csi_driver_config" {
      for_each = local.gcs_fuse_csi_driver_config

      content {
        enabled = gcs_fuse_csi_driver_config.value.enabled
      }
    }

    dynamic "gke_backup_agent_config" {
      for_each = local.gke_backup_agent_config

      content {
        enabled = gke_backup_agent_config.value.enabled
      }
    }

    dynamic "stateful_ha_config" {
      for_each = local.stateful_ha_config

      content {
        enabled = stateful_ha_config.value.enabled
      }
    }

    dynamic "ray_operator_config" {
      for_each = local.ray_operator_config

      content {

        enabled = ray_operator_config.value.enabled

        ray_cluster_logging_config {
          enabled = ray_operator_config.value.logging_enabled
        }
        ray_cluster_monitoring_config {
          enabled = ray_operator_config.value.monitoring_enabled
        }
      }
    }

    istio_config {
      disabled = !var.istio
      auth     = var.istio_auth
    }

    dynamic "cloudrun_config" {
      for_each = local.cluster_cloudrun_config

      content {
        disabled = cloudrun_config.value.disabled
      }
    }

    kalm_config {
      enabled = var.kalm_config
    }
  }

  datapath_provider = var.datapath_provider

  networking_mode = "VPC_NATIVE"

  protect_config {
    workload_config {
      audit_mode = var.workload_config_audit_mode
    }
    workload_vulnerability_mode = var.workload_vulnerability_mode
  }

  security_posture_config {
    mode               = var.security_posture_mode
    vulnerability_mode = var.security_posture_vulnerability_mode
  }

  dynamic "fleet" {
    for_each = var.fleet_project != null ? [1] : []
    content {
      project = var.fleet_project
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
    dynamic "additional_pod_ranges_config" {
      for_each = length(var.additional_ip_range_pods) != 0 ? [1] : []
      content {
        pod_range_names = var.additional_ip_range_pods
      }
    }
    stack_type = var.stack_type
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = local.cluster_maintenance_window_is_recurring
      content {
        start_time = var.maintenance_start_time
        end_time   = var.maintenance_end_time
        recurrence = var.maintenance_recurrence
      }
    }

    dynamic "daily_maintenance_window" {
      for_each = local.cluster_maintenance_window_is_daily
      content {
        start_time = var.maintenance_start_time
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusions
      content {
        exclusion_name = maintenance_exclusion.value.name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time

        dynamic "exclusion_options" {
          for_each = maintenance_exclusion.value.exclusion_scope == null ? [] : [maintenance_exclusion.value.exclusion_scope]
          content {
            scope = exclusion_options.value
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [node_pool, initial_node_count, resource_labels["asmv"]]
  }

  dynamic "dns_config" {
    for_each = !(var.cluster_dns_provider == "PROVIDER_UNSPECIFIED" && var.cluster_dns_scope == "DNS_SCOPE_UNSPECIFIED" && var.cluster_dns_domain == "") ? [1] : []
    content {
      additive_vpc_scope_dns_domain = var.additive_vpc_scope_dns_domain
      cluster_dns                   = var.cluster_dns_provider
      cluster_dns_scope             = var.cluster_dns_scope
      cluster_dns_domain            = var.cluster_dns_domain
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }
  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    management {
      auto_repair  = lookup(var.cluster_autoscaling, "auto_repair", true)
      auto_upgrade = lookup(var.cluster_autoscaling, "auto_upgrade", true)
    }

    node_config {
      image_type                  = lookup(var.node_pools[0], "image_type", "COS_CONTAINERD")
      machine_type                = lookup(var.node_pools[0], "machine_type", "e2-medium")
      min_cpu_platform            = lookup(var.node_pools[0], "min_cpu_platform", "")
      enable_confidential_storage = lookup(var.node_pools[0], "enable_confidential_storage", false)
      dynamic "gcfs_config" {
        for_each = lookup(var.node_pools[0], "enable_gcfs", null) != null ? [var.node_pools[0].enable_gcfs] : []
        content {
          enabled = gcfs_config.value
        }
      }

      dynamic "gvnic" {
        for_each = lookup(var.node_pools[0], "enable_gvnic", false) ? [true] : []
        content {
          enabled = gvnic.value
        }
      }

      dynamic "fast_socket" {
        for_each = lookup(var.node_pools[0], "enable_fast_socket", null) != null ? [var.node_pools[0].enable_fast_socket] : []
        content {
          enabled = fast_socket.value
        }
      }

      dynamic "kubelet_config" {
        for_each = length(setintersection(
          keys(var.node_pools[0]),
          ["cpu_manager_policy", "cpu_cfs_quota", "cpu_cfs_quota_period", "insecure_kubelet_readonly_port_enabled", "pod_pids_limit"]
        )) != 0 || var.insecure_kubelet_readonly_port_enabled != null ? [1] : []

        content {
          cpu_manager_policy                     = lookup(var.node_pools[0], "cpu_manager_policy", "static")
          cpu_cfs_quota                          = lookup(var.node_pools[0], "cpu_cfs_quota", null)
          cpu_cfs_quota_period                   = lookup(var.node_pools[0], "cpu_cfs_quota_period", null)
          insecure_kubelet_readonly_port_enabled = lookup(var.node_pools[0], "insecure_kubelet_readonly_port_enabled", var.insecure_kubelet_readonly_port_enabled) != null ? upper(tostring(lookup(var.node_pools[0], "insecure_kubelet_readonly_port_enabled", var.insecure_kubelet_readonly_port_enabled))) : null
          pod_pids_limit                         = lookup(var.node_pools[0], "pod_pids_limit", null)
        }
      }

      service_account = lookup(var.node_pools[0], "service_account", local.service_account)

      tags = concat(
        lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
        lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-default-pool"] : [],
        lookup(local.node_pools_tags, "all", []),
        lookup(local.node_pools_tags, var.node_pools[0].name, []),
      )

      logging_variant = lookup(var.node_pools[0], "logging_variant", "DEFAULT")

      dynamic "workload_metadata_config" {
        for_each = local.cluster_node_metadata_config

        content {
          mode = workload_metadata_config.value.mode
        }
      }

      metadata = local.node_pools_metadata["all"]

      dynamic "sandbox_config" {
        for_each = tobool((lookup(var.node_pools[0], "sandbox_enabled", var.sandbox_enabled))) ? ["gvisor"] : []
        content {
          sandbox_type = sandbox_config.value
        }
      }

      boot_disk_kms_key = lookup(var.node_pools[0], "boot_disk_kms_key", var.boot_disk_kms_key)

      shielded_instance_config {
        enable_secure_boot          = lookup(var.node_pools[0], "enable_secure_boot", false)
        enable_integrity_monitoring = lookup(var.node_pools[0], "enable_integrity_monitoring", true)
      }
    }
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_dataset_id != "" ? [{
      enable_network_egress_metering       = var.enable_network_egress_export
      enable_resource_consumption_metering = var.enable_resource_consumption_export
      dataset_id                           = var.resource_usage_export_dataset_id
    }] : []

    content {
      enable_network_egress_metering       = resource_usage_export_config.value.enable_network_egress_metering
      enable_resource_consumption_metering = resource_usage_export_config.value.enable_resource_consumption_metering
      bigquery_destination {
        dataset_id = resource_usage_export_config.value.dataset_id
      }
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes        = var.enable_private_nodes,
      enable_private_endpoint     = var.enable_private_endpoint
      master_ipv4_cidr_block      = var.master_ipv4_cidr_block
      private_endpoint_subnetwork = var.private_endpoint_subnetwork
    }] : []

    content {
      enable_private_endpoint     = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes        = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block      = var.private_endpoint_subnetwork == null ? private_cluster_config.value.master_ipv4_cidr_block : null
      private_endpoint_subnetwork = private_cluster_config.value.private_endpoint_subnetwork
      dynamic "master_global_access_config" {
        for_each = var.master_global_access_enabled ? [var.master_global_access_enabled] : []
        content {
          enabled = master_global_access_config.value
        }
      }
    }
  }

  dynamic "control_plane_endpoints_config" {
    for_each = var.enable_private_endpoint && var.deploy_using_private_endpoint ? [1] : []
    content {
      dns_endpoint_config {
        allow_external_traffic = var.deploy_using_private_endpoint
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
      workload_pool = workload_identity_config.value.workload_pool
    }
  }

  dynamic "mesh_certificates" {
    for_each = local.cluster_mesh_certificates_config

    content {
      enable_certificates = mesh_certificates.value.enable_certificates
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = local.cluster_authenticator_security_group
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  notification_config {
    pubsub {
      enabled = var.notification_config_topic != "" ? true : false
      topic   = var.notification_config_topic

      dynamic "filter" {
        for_each = length(var.notification_filter_event_type) > 0 ? [1] : []
        content {
          event_type = var.notification_filter_event_type
        }
      }
    }
  }

  node_pool_defaults {
    node_config_defaults {
      logging_variant = var.logging_variant
      gcfs_config {
        enabled = var.enable_gcfs
      }
      insecure_kubelet_readonly_port_enabled = var.insecure_kubelet_readonly_port_enabled != null ? upper(tostring(var.insecure_kubelet_readonly_port_enabled)) : null
    }
  }

  depends_on = [google_project_iam_member.service_agent]
}
/******************************************
  Create Container Cluster node pools
 *****************************************/
locals {
  force_node_pool_recreation_resources = [
    "accelerator_count",
    "accelerator_type",
    "gpu_partition_size",
    "gpu_driver_version",
    "gpu_sharing_strategy",
    "max_shared_clients_per_gpu",
    "enable_secure_boot",
    "enable_integrity_monitoring",
    "local_ssd_count",
    "local_ssd_ephemeral_count",
    "placement_policy",
    "max_pods_per_node",
    "min_cpu_platform",
    "pod_range",
    "preemptible",
    "spot",
    "service_account",
    "enable_gvnic",
    "boot_disk_kms_key",
    "queued_provisioning",
    "enable_confidential_storage",
    "consume_reservation_type",
    "reservation_affinity_key",
    "reservation_affinity_values",
    "enable_confidential_nodes",
    "secondary_boot_disk",
  ]
}

# This keepers list is based on the terraform google provider schemaNodeConfig
# resources where "ForceNew" is "true". schemaNodeConfig can be found in resource_container_node_pool.go at
# https://github.com/hashicorp/terraform-provider-google/blob/main/google/services/container/resource_container_node_pool.go and node_config.go at
# https://github.com/hashicorp/terraform-provider-google/blob/main/google/services/container/node_config.go
resource "random_id" "name" {
  for_each    = merge(local.node_pools, local.windows_node_pools)
  byte_length = 2
  prefix      = "${each.key}-"
  keepers = merge(
    zipmap(
      local.force_node_pool_recreation_resources,
      [for keeper in local.force_node_pool_recreation_resources : lookup(each.value, keeper, "")]
    ),
    {
      taints = join(",",
        sort(
          flatten(
            concat(
              [for all_taints in local.node_pools_taints["all"] : "all/${all_taints.key}/${all_taints.value}/${all_taints.effect}"],
              [for each_pool_taint in local.node_pools_taints[each.value["name"]] : "${each.value["name"]}/${each_pool_taint.key}/${each_pool_taint.value}/${each_pool_taint.effect}"],
            )
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
    }
  )
}

resource "google_container_node_pool" "pools" {
  provider = google-beta
  for_each = local.node_pools
  name     = { for k, v in random_id.name : k => v.hex }[each.key]
  project  = var.project_id
  location = local.location
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

  cluster = google_container_cluster.primary.name

  version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.primary.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count       = contains(keys(autoscaling.value), "total_min_count") ? null : lookup(autoscaling.value, "min_count", 1)
      max_node_count       = contains(keys(autoscaling.value), "total_max_count") ? null : lookup(autoscaling.value, "max_count", 100)
      location_policy      = lookup(autoscaling.value, "location_policy", null)
      total_min_node_count = lookup(autoscaling.value, "total_min_count", null)
      total_max_node_count = lookup(autoscaling.value, "total_max_count", null)
    }
  }

  dynamic "placement_policy" {
    for_each = length(lookup(each.value, "placement_policy", "")) > 0 ? [each.value] : []
    content {
      type = lookup(placement_policy.value, "placement_policy", null)
    }
  }

  dynamic "network_config" {
    for_each = length(lookup(each.value, "pod_range", "")) > 0 ? [each.value] : []
    content {
      pod_range            = lookup(network_config.value, "pod_range", null)
      enable_private_nodes = var.enable_private_nodes
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", local.default_auto_upgrade)
  }

  upgrade_settings {
    strategy        = lookup(each.value, "strategy", "SURGE")
    max_surge       = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_surge", 1) : null
    max_unavailable = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_unavailable", 0) : null

    dynamic "blue_green_settings" {
      for_each = lookup(each.value, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
      content {
        node_pool_soak_duration = lookup(each.value, "node_pool_soak_duration", null)

        standard_rollout_policy {
          batch_soak_duration = lookup(each.value, "batch_soak_duration", null)
          batch_percentage    = lookup(each.value, "batch_percentage", null)
          batch_node_count    = lookup(each.value, "batch_node_count", null)
        }
      }
    }
  }

  dynamic "queued_provisioning" {
    for_each = lookup(each.value, "queued_provisioning", false) ? [true] : []
    content {
      enabled = lookup(each.value, "queued_provisioning", null)
    }
  }

  node_config {
    image_type                  = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type                = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform            = lookup(each.value, "min_cpu_platform", "")
    enable_confidential_storage = lookup(each.value, "enable_confidential_storage", false)
    dynamic "gcfs_config" {
      for_each = lookup(each.value, "enable_gcfs", null) != null ? [each.value.enable_gcfs] : []
      content {
        enabled = gcfs_config.value
      }
    }
    dynamic "gvnic" {
      for_each = lookup(each.value, "enable_gvnic", false) ? [true] : []
      content {
        enabled = gvnic.value
      }
    }
    dynamic "fast_socket" {
      for_each = lookup(each.value, "enable_fast_socket", null) != null ? [each.value.enable_fast_socket] : []
      content {
        enabled = fast_socket.value
      }
    }
    dynamic "reservation_affinity" {
      for_each = lookup(each.value, "queued_provisioning", false) || lookup(each.value, "consume_reservation_type", "") != "" ? [each.value] : []
      content {
        consume_reservation_type = lookup(reservation_affinity.value, "queued_provisioning", false) ? "NO_RESERVATION" : lookup(reservation_affinity.value, "consume_reservation_type", null)
        key                      = lookup(reservation_affinity.value, "reservation_affinity_key", null)
        values                   = lookup(reservation_affinity.value, "reservation_affinity_values", null) == null ? null : [for s in split(",", lookup(reservation_affinity.value, "reservation_affinity_values", null)) : trimspace(s)]
      }
    }
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[each.value["name"]],
    )
    resource_labels = merge(
      local.node_pools_resource_labels["all"],
      local.node_pools_resource_labels[each.value["name"]],
    )
    resource_manager_tags = merge(
      local.node_pools_resource_manager_tags["all"],
      local.node_pools_resource_manager_tags[each.value["name"]],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", var.enable_default_node_pools_metadata) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", var.enable_default_node_pools_metadata) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[each.value["name"]],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[each.value["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    tags = concat(
      lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
      lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-${each.value["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[each.value["name"]],
    )

    logging_variant = lookup(each.value, "logging_variant", "DEFAULT")

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")

    dynamic "ephemeral_storage_local_ssd_config" {
      for_each = lookup(each.value, "local_ssd_ephemeral_storage_count", 0) > 0 ? [each.value.local_ssd_ephemeral_storage_count] : []
      content {
        local_ssd_count = ephemeral_storage_local_ssd_config.value
      }
    }
    dynamic "ephemeral_storage_config" {
      for_each = lookup(each.value, "local_ssd_ephemeral_count", 0) > 0 ? [each.value.local_ssd_ephemeral_count] : []
      content {
        local_ssd_count = ephemeral_storage_config.value
      }
    }

    dynamic "local_nvme_ssd_block_config" {
      for_each = lookup(each.value, "local_nvme_ssd_count", 0) > 0 ? [each.value.local_nvme_ssd_count] : []
      content {
        local_ssd_count = local_nvme_ssd_block_config.value
      }
    }

    # Supports a single secondary boot disk because `map(any)` must have the same values type.
    dynamic "secondary_boot_disks" {
      for_each = lookup(each.value, "secondary_boot_disk", "") != "" ? [each.value.secondary_boot_disk] : []
      content {
        disk_image = secondary_boot_disks.value
        mode       = "CONTAINER_IMAGE_CACHE"
      }
    }

    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )
    preemptible = lookup(each.value, "preemptible", false)
    spot        = lookup(each.value, "spot", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.value["name"]],
    )

    dynamic "guest_accelerator" {
      for_each = lookup(each.value, "accelerator_count", 0) > 0 ? [1] : []
      content {
        type               = lookup(each.value, "accelerator_type", "")
        count              = lookup(each.value, "accelerator_count", 0)
        gpu_partition_size = lookup(each.value, "gpu_partition_size", null)

        dynamic "gpu_driver_installation_config" {
          for_each = lookup(each.value, "gpu_driver_version", "") != "" ? [1] : []
          content {
            gpu_driver_version = lookup(each.value, "gpu_driver_version", "")
          }
        }

        dynamic "gpu_sharing_config" {
          for_each = lookup(each.value, "gpu_sharing_strategy", "") != "" ? [1] : []
          content {
            gpu_sharing_strategy       = lookup(each.value, "gpu_sharing_strategy", "")
            max_shared_clients_per_gpu = lookup(each.value, "max_shared_clients_per_gpu", 2)
          }
        }
      }
    }

    dynamic "advanced_machine_features" {
      for_each = lookup(each.value, "threads_per_core", 0) > 0 || lookup(each.value, "enable_nested_virtualization", false) ? [1] : []
      content {
        threads_per_core             = lookup(each.value, "threads_per_core", 0)
        enable_nested_virtualization = lookup(each.value, "enable_nested_virtualization", null)
      }
    }

    dynamic "workload_metadata_config" {
      for_each = local.cluster_node_metadata_config

      content {
        mode = lookup(each.value, "node_metadata", workload_metadata_config.value.mode)
      }
    }

    dynamic "kubelet_config" {
      for_each = length(setintersection(
        keys(each.value),
        ["cpu_manager_policy", "cpu_cfs_quota", "cpu_cfs_quota_period", "insecure_kubelet_readonly_port_enabled", "pod_pids_limit"]
      )) != 0 ? [1] : []

      content {
        cpu_manager_policy                     = lookup(each.value, "cpu_manager_policy", "static")
        cpu_cfs_quota                          = lookup(each.value, "cpu_cfs_quota", null)
        cpu_cfs_quota_period                   = lookup(each.value, "cpu_cfs_quota_period", null)
        insecure_kubelet_readonly_port_enabled = lookup(each.value, "insecure_kubelet_readonly_port_enabled", null) != null ? upper(tostring(each.value.insecure_kubelet_readonly_port_enabled)) : null
        pod_pids_limit                         = lookup(each.value, "pod_pids_limit", null)
      }
    }

    dynamic "sandbox_config" {
      for_each = tobool((lookup(each.value, "sandbox_enabled", var.sandbox_enabled))) ? ["gvisor"] : []
      content {
        sandbox_type = sandbox_config.value
      }
    }

    dynamic "linux_node_config" {
      for_each = length(merge(
        local.node_pools_linux_node_configs_sysctls["all"],
        local.node_pools_linux_node_configs_sysctls[each.value["name"]],
        local.node_pools_cgroup_mode["all"] == "" ? {} : { cgroup = local.node_pools_cgroup_mode["all"] },
        local.node_pools_cgroup_mode[each.value["name"]] == "" ? {} : { cgroup = local.node_pools_cgroup_mode[each.value["name"]] }
      )) != 0 ? [1] : []

      content {
        sysctls = merge(
          local.node_pools_linux_node_configs_sysctls["all"],
          local.node_pools_linux_node_configs_sysctls[each.value["name"]]
        )
        cgroup_mode = coalesce(local.node_pools_cgroup_mode[each.value["name"]], local.node_pools_cgroup_mode["all"], null)
      }
    }

    boot_disk_kms_key = lookup(each.value, "boot_disk_kms_key", "")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }

    dynamic "confidential_nodes" {
      for_each = lookup(each.value, "enable_confidential_nodes", null) != null ? [each.value.enable_confidential_nodes] : []
      content {
        enabled = confidential_nodes.value
      }
    }

  }

  lifecycle {
    ignore_changes = [initial_node_count]

    create_before_destroy = true
  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }

  depends_on = [
    google_compute_firewall.intra_egress,
  ]
}
resource "google_container_node_pool" "windows_pools" {
  provider = google-beta
  for_each = local.windows_node_pools
  name     = { for k, v in random_id.name : k => v.hex }[each.key]
  project  = var.project_id
  location = local.location
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

  cluster = google_container_cluster.primary.name

  version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.primary.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count       = contains(keys(autoscaling.value), "total_min_count") ? null : lookup(autoscaling.value, "min_count", 1)
      max_node_count       = contains(keys(autoscaling.value), "total_max_count") ? null : lookup(autoscaling.value, "max_count", 100)
      location_policy      = lookup(autoscaling.value, "location_policy", null)
      total_min_node_count = lookup(autoscaling.value, "total_min_count", null)
      total_max_node_count = lookup(autoscaling.value, "total_max_count", null)
    }
  }

  dynamic "placement_policy" {
    for_each = length(lookup(each.value, "placement_policy", "")) > 0 ? [each.value] : []
    content {
      type = lookup(placement_policy.value, "placement_policy", null)
    }
  }

  dynamic "network_config" {
    for_each = length(lookup(each.value, "pod_range", "")) > 0 ? [each.value] : []
    content {
      pod_range            = lookup(network_config.value, "pod_range", null)
      enable_private_nodes = var.enable_private_nodes
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", local.default_auto_upgrade)
  }

  upgrade_settings {
    strategy        = lookup(each.value, "strategy", "SURGE")
    max_surge       = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_surge", 1) : null
    max_unavailable = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_unavailable", 0) : null

    dynamic "blue_green_settings" {
      for_each = lookup(each.value, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
      content {
        node_pool_soak_duration = lookup(each.value, "node_pool_soak_duration", null)

        standard_rollout_policy {
          batch_soak_duration = lookup(each.value, "batch_soak_duration", null)
          batch_percentage    = lookup(each.value, "batch_percentage", null)
          batch_node_count    = lookup(each.value, "batch_node_count", null)
        }
      }
    }
  }

  dynamic "queued_provisioning" {
    for_each = lookup(each.value, "queued_provisioning", false) ? [true] : []
    content {
      enabled = lookup(each.value, "queued_provisioning", null)
    }
  }

  node_config {
    image_type                  = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type                = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform            = lookup(each.value, "min_cpu_platform", "")
    enable_confidential_storage = lookup(each.value, "enable_confidential_storage", false)
    dynamic "gcfs_config" {
      for_each = lookup(each.value, "enable_gcfs", null) != null ? [each.value.enable_gcfs] : []
      content {
        enabled = gcfs_config.value
      }
    }
    dynamic "gvnic" {
      for_each = lookup(each.value, "enable_gvnic", false) ? [true] : []
      content {
        enabled = gvnic.value
      }
    }
    dynamic "fast_socket" {
      for_each = lookup(each.value, "enable_fast_socket", null) != null ? [each.value.enable_fast_socket] : []
      content {
        enabled = fast_socket.value
      }
    }
    dynamic "reservation_affinity" {
      for_each = lookup(each.value, "queued_provisioning", false) || lookup(each.value, "consume_reservation_type", "") != "" ? [each.value] : []
      content {
        consume_reservation_type = lookup(reservation_affinity.value, "queued_provisioning", false) ? "NO_RESERVATION" : lookup(reservation_affinity.value, "consume_reservation_type", null)
        key                      = lookup(reservation_affinity.value, "reservation_affinity_key", null)
        values                   = lookup(reservation_affinity.value, "reservation_affinity_values", null) == null ? null : [for s in split(",", lookup(reservation_affinity.value, "reservation_affinity_values", null)) : trimspace(s)]
      }
    }
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[each.value["name"]],
    )
    resource_labels = merge(
      local.node_pools_resource_labels["all"],
      local.node_pools_resource_labels[each.value["name"]],
    )
    resource_manager_tags = merge(
      local.node_pools_resource_manager_tags["all"],
      local.node_pools_resource_manager_tags[each.value["name"]],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", var.enable_default_node_pools_metadata) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", var.enable_default_node_pools_metadata) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[each.value["name"]],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[each.value["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    tags = concat(
      lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
      lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-${each.value["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[each.value["name"]],
    )

    logging_variant = lookup(each.value, "logging_variant", "DEFAULT")

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")

    dynamic "ephemeral_storage_local_ssd_config" {
      for_each = lookup(each.value, "local_ssd_ephemeral_storage_count", 0) > 0 ? [each.value.local_ssd_ephemeral_storage_count] : []
      content {
        local_ssd_count = ephemeral_storage_local_ssd_config.value
      }
    }
    dynamic "ephemeral_storage_config" {
      for_each = lookup(each.value, "local_ssd_ephemeral_count", 0) > 0 ? [each.value.local_ssd_ephemeral_count] : []
      content {
        local_ssd_count = ephemeral_storage_config.value
      }
    }

    dynamic "local_nvme_ssd_block_config" {
      for_each = lookup(each.value, "local_nvme_ssd_count", 0) > 0 ? [each.value.local_nvme_ssd_count] : []
      content {
        local_ssd_count = local_nvme_ssd_block_config.value
      }
    }

    # Supports a single secondary boot disk because `map(any)` must have the same values type.
    dynamic "secondary_boot_disks" {
      for_each = lookup(each.value, "secondary_boot_disk", "") != "" ? [each.value.secondary_boot_disk] : []
      content {
        disk_image = secondary_boot_disks.value
        mode       = "CONTAINER_IMAGE_CACHE"
      }
    }

    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )
    preemptible = lookup(each.value, "preemptible", false)
    spot        = lookup(each.value, "spot", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.value["name"]],
    )

    dynamic "guest_accelerator" {
      for_each = lookup(each.value, "accelerator_count", 0) > 0 ? [1] : []
      content {
        type               = lookup(each.value, "accelerator_type", "")
        count              = lookup(each.value, "accelerator_count", 0)
        gpu_partition_size = lookup(each.value, "gpu_partition_size", null)

        dynamic "gpu_driver_installation_config" {
          for_each = lookup(each.value, "gpu_driver_version", "") != "" ? [1] : []
          content {
            gpu_driver_version = lookup(each.value, "gpu_driver_version", "")
          }
        }

        dynamic "gpu_sharing_config" {
          for_each = lookup(each.value, "gpu_sharing_strategy", "") != "" ? [1] : []
          content {
            gpu_sharing_strategy       = lookup(each.value, "gpu_sharing_strategy", "")
            max_shared_clients_per_gpu = lookup(each.value, "max_shared_clients_per_gpu", 2)
          }
        }
      }
    }

    dynamic "advanced_machine_features" {
      for_each = lookup(each.value, "threads_per_core", 0) > 0 || lookup(each.value, "enable_nested_virtualization", false) ? [1] : []
      content {
        threads_per_core             = lookup(each.value, "threads_per_core", 0)
        enable_nested_virtualization = lookup(each.value, "enable_nested_virtualization", null)
      }
    }

    dynamic "workload_metadata_config" {
      for_each = local.cluster_node_metadata_config

      content {
        mode = lookup(each.value, "node_metadata", workload_metadata_config.value.mode)
      }
    }

    dynamic "kubelet_config" {
      for_each = length(setintersection(
        keys(each.value),
        ["cpu_manager_policy", "cpu_cfs_quota", "cpu_cfs_quota_period", "insecure_kubelet_readonly_port_enabled", "pod_pids_limit"]
      )) != 0 ? [1] : []

      content {
        cpu_manager_policy                     = lookup(each.value, "cpu_manager_policy", "static")
        cpu_cfs_quota                          = lookup(each.value, "cpu_cfs_quota", null)
        cpu_cfs_quota_period                   = lookup(each.value, "cpu_cfs_quota_period", null)
        insecure_kubelet_readonly_port_enabled = lookup(each.value, "insecure_kubelet_readonly_port_enabled", null) != null ? upper(tostring(each.value.insecure_kubelet_readonly_port_enabled)) : null
        pod_pids_limit                         = lookup(each.value, "pod_pids_limit", null)
      }
    }

    dynamic "sandbox_config" {
      for_each = tobool((lookup(each.value, "sandbox_enabled", var.sandbox_enabled))) ? ["gvisor"] : []
      content {
        sandbox_type = sandbox_config.value
      }
    }


    boot_disk_kms_key = lookup(each.value, "boot_disk_kms_key", "")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }

    dynamic "confidential_nodes" {
      for_each = lookup(each.value, "enable_confidential_nodes", null) != null ? [each.value.enable_confidential_nodes] : []
      content {
        enabled = confidential_nodes.value
      }
    }

  }

  lifecycle {
    ignore_changes = [initial_node_count]

    create_before_destroy = true
  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }

  depends_on = [
    google_compute_firewall.intra_egress,
    google_container_node_pool.pools[0],
  ]
}
