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

  dynamic "gke_auto_upgrade_config" {
    for_each = var.gke_auto_upgrade_config_patch_mode != null ? [1] : []

    content {
      patch_mode = var.gke_auto_upgrade_config_patch_mode
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

  dynamic "logging_config" {
    for_each = length(var.logging_enabled_components) > 0 ? [1] : []

    content {
      enable_components = var.logging_enabled_components
    }
  }

  dynamic "monitoring_config" {
    for_each = length(var.monitoring_enabled_components) > 0 ? [1] : []
    content {
      enable_components = var.monitoring_enabled_components
    }
  }

  cluster_autoscaling {
    dynamic "auto_provisioning_defaults" {
      for_each = (var.create_service_account || var.service_account != "" || var.boot_disk_kms_key != null) ? [1] : []

      content {
        service_account   = local.service_account
        boot_disk_kms_key = var.boot_disk_kms_key
      }
    }
  }
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  dynamic "binary_authorization" {
    for_each = var.enable_binary_authorization ? [var.enable_binary_authorization] : []
    content {
      evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
    }
  }

  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting

  disable_l4_lb_firewall_reconciliation = var.disable_l4_lb_firewall_reconciliation

  enable_multi_networking = var.enable_multi_networking

  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy

  in_transit_encryption_config = var.in_transit_encryption_config

  dynamic "network_performance_config" {
    for_each = var.total_egress_bandwidth_tier != null ? [1] : []
    content {
      total_egress_bandwidth_tier = var.total_egress_bandwidth_tier
    }
  }

  dynamic "rbac_binding_config" {
    for_each = var.rbac_binding_config.enable_insecure_binding_system_unauthenticated != null || var.rbac_binding_config.enable_insecure_binding_system_authenticated != null ? [var.rbac_binding_config] : []
    content {
      enable_insecure_binding_system_unauthenticated = rbac_binding_config.value["enable_insecure_binding_system_unauthenticated"]
      enable_insecure_binding_system_authenticated   = rbac_binding_config.value["enable_insecure_binding_system_authenticated"]
    }
  }

  dynamic "secret_manager_config" {
    for_each = var.enable_secret_manager_addon ? [var.enable_secret_manager_addon] : []
    content {
      enabled = secret_manager_config.value
    }
  }

  dynamic "pod_autoscaling" {
    for_each = length(var.hpa_profile) > 0 ? [1] : []
    content {
      hpa_profile = var.hpa_profile
    }
  }

  dynamic "enterprise_config" {
    for_each = var.enterprise_config != null ? [1] : []
    content {
      desired_tier = var.enterprise_config
    }
  }

  enable_fqdn_network_policy = var.enable_fqdn_network_policy
  enable_autopilot           = true
  dynamic "master_authorized_networks_config" {
    for_each = var.gcp_public_cidrs_access_enabled != null || length(var.master_authorized_networks) > 0 ? [true] : []
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
    for_each = length(var.network_tags) > 0 || var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules || var.add_shadow_firewall_rules || var.insecure_kubelet_readonly_port_enabled != null || var.node_pools_cgroup_mode != null ? [1] : []
    content {
      dynamic "network_tags" {
        for_each = length(var.network_tags) > 0 || var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules || var.add_shadow_firewall_rules || var.insecure_kubelet_readonly_port_enabled != null ? [1] : []
        content {
          tags = var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules || var.add_shadow_firewall_rules ? concat(var.network_tags, [local.cluster_network_tag]) : length(var.network_tags) > 0 ? var.network_tags : null
        }
      }

      dynamic "node_kubelet_config" {
        for_each = var.insecure_kubelet_readonly_port_enabled != null ? [1] : []
        content {
          insecure_kubelet_readonly_port_enabled = upper(tostring(var.insecure_kubelet_readonly_port_enabled))
        }
      }
      dynamic "linux_node_config" {
        for_each = var.node_pools_cgroup_mode != null ? [1] : []
        content {
          cgroup_mode = var.node_pools_cgroup_mode
        }
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

    dynamic "lustre_csi_driver_config" {
      for_each = var.lustre_csi_driver == null ? [] : ["lustre_csi_driver_config"]
      content {
        enabled                   = var.lustre_csi_driver
        enable_legacy_lustre_port = var.enable_legacy_lustre_port
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


  }

  allow_net_admin = var.allow_net_admin

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
    precondition {
      condition     = var.ip_range_services == null && var.kubernetes_version != "latest" ? tonumber(split(".", var.kubernetes_version)[0]) >= 1 && tonumber(split(".", var.kubernetes_version)[1]) >= 27 : true
      error_message = "Setting ip_range_services is required for this GKE version. Please set ip_range_services or use kubernetes_version 1.27 or later."
    }

  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
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

  dynamic "control_plane_endpoints_config" {
    for_each = var.dns_allow_external_traffic != null || var.ip_endpoints_enabled != null ? [1] : []
    content {
      dynamic "dns_endpoint_config" {
        for_each = var.dns_allow_external_traffic != null ? [1] : []
        content {
          allow_external_traffic = var.dns_allow_external_traffic
        }
      }
      dynamic "ip_endpoints_config" {
        for_each = var.ip_endpoints_enabled != null ? [1] : []
        content {
          enabled = var.ip_endpoints_enabled
        }
      }
    }
  }


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

  depends_on = [google_project_iam_member.service_agent]
}
