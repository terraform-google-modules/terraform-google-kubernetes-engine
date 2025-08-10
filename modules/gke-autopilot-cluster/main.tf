/**
 * Copyright 2025 Google LLC
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

resource "google_container_cluster" "main" {
  provider = google-beta

  name                = var.name
  description         = var.description
  project             = var.project_id
  resource_labels     = var.resource_labels
  location            = var.location
  node_locations      = var.node_locations
  cluster_ipv4_cidr   = var.cluster_ipv4_cidr
  network             = var.network
  subnetwork          = var.subnetwork
  deletion_protection = var.deletion_protection



  private_ipv6_google_access = var.private_ipv6_google_access
  datapath_provider          = var.datapath_provider



  min_master_version                       = var.min_master_version
  enable_l4_ilb_subsetting                 = var.enable_l4_ilb_subsetting
  disable_l4_lb_firewall_reconciliation    = var.disable_l4_lb_firewall_reconciliation
  enable_multi_networking                  = var.enable_multi_networking
  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy
  in_transit_encryption_config             = var.in_transit_encryption_config
  enable_fqdn_network_policy               = var.enable_fqdn_network_policy
  allow_net_admin                          = var.allow_net_admin
  networking_mode                          = "VPC_NATIVE" # CIS GKE Benchmark Recommendations: 6.6.2. Prefer VPC-native clusters

  enable_autopilot = true

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [var.release_channel] : []
    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "gateway_api_config" {
    for_each = var.gateway_api_config != null ? [var.gateway_api_config] : []
    content {
      channel = gateway_api_config.value.channel
    }
  }

  dynamic "cost_management_config" {
    for_each = var.cost_management_config != null ? [var.cost_management_config] : []
    content {
      enabled = cost_management_config.value.enabled
    }
  }

  dynamic "confidential_nodes" {
    for_each = var.confidential_nodes != null ? [var.confidential_nodes] : []
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  dynamic "default_snat_status" {
    for_each = var.default_snat_status != null ? [var.default_snat_status] : []
    content {
      disabled = default_snat_status.value.disabled
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      enable_components = logging_config.value.enable_components
    }
  }

  dynamic "monitoring_config" {
    for_each = var.monitoring_config != null ? [var.monitoring_config] : []
    content {
      enable_components = monitoring_config.value.enable_components
    }
  }

  dynamic "pod_security_policy_config" {
    for_each = var.pod_security_policy_config != null ? [var.pod_security_policy_config] : []
    content {
      enabled = pod_security_policy_config.value.enabled
    }
  }

  dynamic "cluster_telemetry" {
    for_each = var.cluster_telemetry != null ? [var.cluster_telemetry] : []
    content {
      type = cluster_telemetry.value.type
    }
  }

  dynamic "identity_service_config" {
    for_each = var.identity_service_config != null ? [var.identity_service_config] : []
    content {
      enabled = identity_service_config.value.enabled
    }
  }
  dynamic "dns_config" {
    for_each = var.dns_config != null ? [var.dns_config] : []
    content {
      additive_vpc_scope_dns_domain = dns_config.value.additive_vpc_scope_dns_domain
      cluster_dns                   = dns_config.value.cluster_dns
      cluster_dns_scope             = dns_config.value.cluster_dns_scope
      cluster_dns_domain            = dns_config.value.cluster_dns_domain
    }
  }

  dynamic "workload_alts_config" {
    for_each = var.workload_alts_config != null ? [var.workload_alts_config] : []
    content {
      enable_alts = workload_alts_config.value.enable_alts
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling != null ? [var.cluster_autoscaling] : []
    content {
      dynamic "auto_provisioning_defaults" {
        for_each = cluster_autoscaling.value.auto_provisioning_defaults != null ? [cluster_autoscaling.value.auto_provisioning_defaults] : []
        content {
          service_account   = auto_provisioning_defaults.value.service_account
          boot_disk_kms_key = auto_provisioning_defaults.value.boot_disk_kms_key
        }
      }
    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.vertical_pod_autoscaling != null ? [var.vertical_pod_autoscaling] : []
    content {
      enabled = vertical_pod_autoscaling.value.enabled
    }
  }

  dynamic "binary_authorization" {
    for_each = var.binary_authorization != null ? [var.binary_authorization] : []
    content {
      evaluation_mode = binary_authorization.value.evaluation_mode
    }
  }

  secret_manager_config {
    enabled = var.secret_manager_config != null ? var.secret_manager_config.enabled : false
  }

  dynamic "pod_autoscaling" {
    for_each = var.pod_autoscaling != null ? [var.pod_autoscaling] : []
    content {
      hpa_profile = pod_autoscaling.value.hpa_profile
    }
  }

  dynamic "enterprise_config" {
    for_each = var.enterprise_config != null ? [var.enterprise_config] : []
    content {
      desired_tier = enterprise_config.value.desired_tier
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config != null ? [var.master_authorized_networks_config] : []
    content {
      gcp_public_cidrs_access_enabled = master_authorized_networks_config.value.gcp_public_cidrs_access_enabled
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks != null ? master_authorized_networks_config.value.cidr_blocks : []
        content {
          display_name = cidr_blocks.value.display_name
          cidr_block   = cidr_blocks.value.cidr_block
        }
      }
    }
  }

  dynamic "node_pool_auto_config" {
    for_each = var.node_pool_auto_config != null ? [var.node_pool_auto_config] : []
    content {
      resource_manager_tags = node_pool_auto_config.value.resource_manager_tags
      dynamic "node_kubelet_config" {
        for_each = node_pool_auto_config.value.node_kubelet_config != null ? [node_pool_auto_config.value.node_kubelet_config] : []
        content {
          insecure_kubelet_readonly_port_enabled = upper(tostring(node_kubelet_config.value.insecure_kubelet_readonly_port_enabled))
        }
      }
      dynamic "network_tags" {
        for_each = node_pool_auto_config.value.network_tags != null ? [node_pool_auto_config.value.network_tags] : []
        content {
          tags = network_tags.value.tags
        }
      }
      dynamic "linux_node_config" {
        for_each = node_pool_auto_config.value.linux_node_config != null ? [node_pool_auto_config.value.linux_node_config] : []
        content {
          cgroup_mode = linux_node_config.value.cgroup_mode
        }
      }
    }
  }

  dynamic "master_auth" {
    for_each = var.master_auth != null ? [var.master_auth] : []
    content {
      dynamic "client_certificate_config" {
        for_each = master_auth.value.client_certificate_config != null ? [master_auth.value.client_certificate_config] : []
        content {
          issue_client_certificate = client_certificate_config.value.issue_client_certificate
        }
      }
    }
  }

  dynamic "service_external_ips_config" {
    for_each = var.service_external_ips_config != null ? [var.service_external_ips_config] : []
    content {
      enabled = service_external_ips_config.value.enabled
    }
  }

  dynamic "mesh_certificates" {
    for_each = var.mesh_certificates != null ? [var.mesh_certificates] : []

    content {
      enable_certificates = mesh_certificates.value.enable_certificates
    }
  }

  dynamic "addons_config" {
    for_each = var.addons_config != null ? [var.addons_config] : []
    content {
      dynamic "gcp_filestore_csi_driver_config" {
        for_each = addons_config.value.gcp_filestore_csi_driver_config != null ? [addons_config.value.gcp_filestore_csi_driver_config] : []
        content {
          enabled = gcp_filestore_csi_driver_config.value.enabled
        }
      }
      dynamic "gke_backup_agent_config" {
        for_each = addons_config.value.gke_backup_agent_config != null ? [addons_config.value.gke_backup_agent_config] : []
        content {
          enabled = gke_backup_agent_config.value.enabled
        }
      }
      dynamic "ray_operator_config" {
        for_each = addons_config.value.ray_operator_config != null ? [addons_config.value.ray_operator_config] : []
        content {
          enabled = ray_operator_config.value.enabled
          dynamic "ray_cluster_logging_config" {
            for_each = ray_operator_config.value.ray_cluster_logging_config != null ? [ray_operator_config.value.ray_cluster_logging_config] : []
            content {
              enabled = ray_cluster_logging_config.value.enabled
            }
          }
          dynamic "ray_cluster_monitoring_config" {
            for_each = ray_operator_config.value.ray_cluster_monitoring_config != null ? [ray_operator_config.value.ray_cluster_monitoring_config] : []
            content {
              enabled = ray_cluster_monitoring_config.value.enabled
            }
          }
        }
      }
    }
  }

  dynamic "protect_config" {
    for_each = var.protect_config != null ? [var.protect_config] : []
    content {
      workload_vulnerability_mode = protect_config.value.workload_vulnerability_mode
      dynamic "workload_config" {
        for_each = protect_config.value.workload_config != null ? [protect_config.value.workload_config] : []
        content {
          audit_mode = workload_config.value.audit_mode
        }
      }
    }
  }

  dynamic "security_posture_config" {
    for_each = var.security_posture_config != null ? [var.security_posture_config] : []
    content {
      mode               = security_posture_config.value.mode
      vulnerability_mode = security_posture_config.value.vulnerability_mode
    }
  }

  dynamic "fleet" {
    for_each = var.fleet != null ? [var.fleet] : []
    content {
      project = fleet.value.project
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null ? [var.ip_allocation_policy] : []
    content {
      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
      stack_type                    = ip_allocation_policy.value.stack_type
      dynamic "additional_pod_ranges_config" {
        for_each = ip_allocation_policy.value.additional_pod_ranges_config != null ? [ip_allocation_policy.value.additional_pod_ranges_config] : []
        content {
          pod_range_names = additional_pod_ranges_config.value.pod_range_names
        }
      }
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [var.maintenance_policy] : []
    content {
      dynamic "daily_maintenance_window" {
        for_each = maintenance_policy.value.daily_maintenance_window != null ? [maintenance_policy.value.daily_maintenance_window] : []
        content {
          start_time = daily_maintenance_window.value.start_time
        }
      }
      dynamic "recurring_window" {
        for_each = maintenance_policy.value.recurring_window != null ? [maintenance_policy.value.recurring_window] : []
        content {
          start_time = recurring_window.value.start_time
          end_time   = recurring_window.value.end_time
          recurrence = recurring_window.value.recurrence
        }
      }
      dynamic "maintenance_exclusion" {
        for_each = maintenance_policy.value.maintenance_exclusion != null ? maintenance_policy.value.maintenance_exclusion : []
        content {
          exclusion_name = maintenance_exclusion.value.exclusion_name
          start_time     = maintenance_exclusion.value.start_time
          end_time       = maintenance_exclusion.value.end_time
          dynamic "exclusion_options" {
            for_each = maintenance_exclusion.value.exclusion_options != null ? [maintenance_exclusion.value.exclusion_options] : []
            content {
              scope = exclusion_options.value.scope
            }
          }
        }
      }
    }
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_config != null ? [var.resource_usage_export_config] : []
    content {
      enable_network_egress_metering       = resource_usage_export_config.value.enable_network_egress_metering
      enable_resource_consumption_metering = resource_usage_export_config.value.enable_resource_consumption_metering
      dynamic "bigquery_destination" {
        for_each = resource_usage_export_config.value.bigquery_destination != null ? [resource_usage_export_config.value.bigquery_destination] : []
        content {
          dataset_id = bigquery_destination.value.dataset_id
        }
      }
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config != null ? [var.private_cluster_config] : []
    content {
      enable_private_nodes        = private_cluster_config.value.enable_private_nodes
      enable_private_endpoint     = private_cluster_config.value.enable_private_endpoint
      master_ipv4_cidr_block      = private_cluster_config.value.master_ipv4_cidr_block
      private_endpoint_subnetwork = private_cluster_config.value.private_endpoint_subnetwork
      dynamic "master_global_access_config" {
        for_each = private_cluster_config.value.master_global_access_config != null ? [private_cluster_config.value.master_global_access_config] : []
        content {
          enabled = master_global_access_config.value.enabled
        }
      }
    }
  }

  dynamic "control_plane_endpoints_config" {
    for_each = var.control_plane_endpoints_config != null ? [var.control_plane_endpoints_config] : []
    content {
      dynamic "dns_endpoint_config" {
        for_each = control_plane_endpoints_config.value.dns_endpoint_config != null ? [control_plane_endpoints_config.value.dns_endpoint_config] : []
        content {
          allow_external_traffic = dns_endpoint_config.value.allow_external_traffic
        }
      }
      dynamic "ip_endpoints_config" {
        for_each = control_plane_endpoints_config.value.ip_endpoints_config != null ? [control_plane_endpoints_config.value.ip_endpoints_config] : []
        content {
          enabled = ip_endpoints_config.value.enabled
        }
      }
    }
  }

  dynamic "database_encryption" {
    for_each = var.database_encryption != null ? [var.database_encryption] : []
    content {
      state    = database_encryption.value.state
      key_name = database_encryption.value.key_name
    }
  }

  dynamic "enable_k8s_beta_apis" {
    for_each = var.enable_k8s_beta_apis != null ? [var.enable_k8s_beta_apis] : []

    content {
      enabled_apis = enable_k8s_beta_apis.value.enabled_apis
    }
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_config != null ? [var.workload_identity_config] : []
    content {
      workload_pool = workload_identity_config.value.workload_pool
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = var.authenticator_groups_config != null ? [var.authenticator_groups_config] : []
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  dynamic "notification_config" {
    for_each = var.notification_config != null ? [var.notification_config] : []
    content {
      dynamic "pubsub" {
        for_each = notification_config.value.pubsub != null ? [notification_config.value.pubsub] : []
        content {
          enabled = pubsub.value.enabled
          topic   = pubsub.value.topic
          dynamic "filter" {
            for_each = pubsub.value.filter != null ? [pubsub.value.filter] : []
            content {
              event_type = filter.value.event_type
            }
          }
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}
