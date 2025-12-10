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

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.resource_labels

  location            = var.location
  node_locations      = var.node_locations
  cluster_ipv4_cidr   = var.cluster_ipv4_cidr
  network             = var.network
  subnetwork          = var.subnetwork
  networking_mode     = "VPC_NATIVE" # CIS GKE Benchmark Recommendations: 6.6.2. Prefer VPC-native clusters
  deletion_protection = var.deletion_protection

  default_max_pods_per_node = var.default_max_pods_per_node
  enable_kubernetes_alpha   = var.enable_kubernetes_alpha
  enable_tpu                = var.enable_tpu
  enable_legacy_abac        = var.enable_legacy_abac
  enable_shielded_nodes     = var.enable_shielded_nodes
  initial_node_count        = var.initial_node_count
  min_master_version        = var.min_master_version
  logging_service           = var.logging_service
  monitoring_service        = var.monitoring_service


  allow_net_admin = false
  # enable_autopilot = false

  dynamic "addons_config" {
    for_each = var.addons_config != null ? [var.addons_config] : []

    content {

      dynamic "http_load_balancing" {
        for_each = addons_config.value.http_load_balancing != null ? [addons_config.value.http_load_balancing] : []
        content {
          disabled = http_load_balancing.value.disabled
        }
      }

      dynamic "horizontal_pod_autoscaling" {
        for_each = addons_config.value.horizontal_pod_autoscaling != null ? [addons_config.value.horizontal_pod_autoscaling] : []
        content {
          disabled = horizontal_pod_autoscaling.value.disabled
        }
      }

      dynamic "network_policy_config" {
        for_each = addons_config.value.network_policy_config != null ? [addons_config.value.network_policy_config] : []
        content {
          disabled = network_policy_config.value.disabled
        }
      }

      dynamic "istio_config" {
        for_each = addons_config.value.istio_config != null ? [addons_config.value.istio_config] : []
        content {
          disabled = istio_config.value.disabled
          auth     = istio_config.value.auth
        }
      }

      dynamic "dns_cache_config" {
        for_each = addons_config.value.dns_cache_config != null ? [addons_config.value.dns_cache_config] : []
        content {
          enabled = dns_cache_config.value.enabled
        }
      }

      dynamic "config_connector_config" {
        for_each = addons_config.value.config_connector_config != null ? [addons_config.value.config_connector_config] : []
        content {
          enabled = config_connector_config.value.enabled
        }
      }

      dynamic "gce_persistent_disk_csi_driver_config" {
        for_each = addons_config.value.gce_persistent_disk_csi_driver_config != null ? [addons_config.value.gce_persistent_disk_csi_driver_config] : []
        content {
          enabled = gce_persistent_disk_csi_driver_config.value.enabled
        }
      }

      dynamic "kalm_config" {
        for_each = addons_config.value.kalm_config != null ? [addons_config.value.kalm_config] : []
        content {
          enabled = kalm_config.value.enabled
        }
      }

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

      dynamic "gcs_fuse_csi_driver_config" {
        for_each = addons_config.value.gcs_fuse_csi_driver_config != null ? [addons_config.value.gcs_fuse_csi_driver_config] : []
        content {
          enabled = gcs_fuse_csi_driver_config.value.enabled
        }
      }

      dynamic "stateful_ha_config" {
        for_each = addons_config.value.stateful_ha_config != null ? [addons_config.value.stateful_ha_config] : []
        content {
          enabled = stateful_ha_config.value.enabled
        }
      }

      dynamic "parallelstore_csi_driver_config" {
        for_each = addons_config.value.parallelstore_csi_driver_config != null ? [addons_config.value.parallelstore_csi_driver_config] : []
        content {
          enabled = parallelstore_csi_driver_config.value.enabled
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

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling != null ? [var.cluster_autoscaling] : []

    content {
      enabled                     = cluster_autoscaling.value.enabled
      autoscaling_profile         = cluster_autoscaling.value.autoscaling_profile
      auto_provisioning_locations = cluster_autoscaling.value.auto_provisioning_locations
      dynamic "resource_limits" {
        for_each = cluster_autoscaling.value.resource_limits != null ? cluster_autoscaling.value.resource_limits : []
        content {
          resource_type = resource_limits.value.resource_type
          minimum       = resource_limits.value.minimum
          maximum       = resource_limits.value.maximum
        }
      }
      dynamic "auto_provisioning_defaults" {
        for_each = cluster_autoscaling.value.auto_provisioning_defaults != null ? [cluster_autoscaling.value.auto_provisioning_defaults] : []
        content {
          min_cpu_platform  = auto_provisioning_defaults.value.min_cpu_platform
          oauth_scopes      = auto_provisioning_defaults.value.oauth_scopes
          service_account   = auto_provisioning_defaults.value.service_account
          boot_disk_kms_key = auto_provisioning_defaults.value.boot_disk_kms_key
          disk_size         = auto_provisioning_defaults.value.disk_size
          disk_type         = auto_provisioning_defaults.value.disk_type
          image_type        = auto_provisioning_defaults.value.image_type
          dynamic "shielded_instance_config" {
            for_each = auto_provisioning_defaults.value.shielded_instance_config != null ? [auto_provisioning_defaults.value.shielded_instance_config] : []
            content {
              enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
              enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
            }
          }
          dynamic "management" {
            for_each = auto_provisioning_defaults.value.management != null ? [auto_provisioning_defaults.value.management] : []
            content {
              auto_upgrade = management.value.auto_upgrade
              auto_repair  = management.value.auto_repair
            }
          }
          dynamic "upgrade_settings" {
            for_each = auto_provisioning_defaults.value.upgrade_settings != null ? [auto_provisioning_defaults.value.upgrade_settings] : []
            content {
              strategy        = upgrade_settings.value.strategy
              max_surge       = upgrade_settings.value.max_surge
              max_unavailable = upgrade_settings.value.max_unavailable
              dynamic "blue_green_settings" {
                for_each = upgrade_settings.value.blue_green_settings != null ? [upgrade_settings.value.blue_green_settings] : []
                content {
                  node_pool_soak_duration = blue_green_settings.value.node_pool_soak_duration
                  dynamic "standard_rollout_policy" {
                    for_each = blue_green_settings.value.standard_rollout_policy != null ? [blue_green_settings.value.standard_rollout_policy] : []
                    content {
                      batch_percentage    = standard_rollout_policy.value.batch_percentage
                      batch_node_count    = standard_rollout_policy.value.batch_node_count
                      batch_soak_duration = standard_rollout_policy.value.batch_soak_duration
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  dynamic "binary_authorization" {
    for_each = var.binary_authorization != null ? [var.binary_authorization] : []

    content {
      evaluation_mode = binary_authorization.value.evaluation_mode
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

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null ? [var.ip_allocation_policy] : []

    content {
      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
      cluster_ipv4_cidr_block       = ip_allocation_policy.value.cluster_ipv4_cidr_block
      services_ipv4_cidr_block      = ip_allocation_policy.value.services_ipv4_cidr_block
      stack_type                    = ip_allocation_policy.value.stack_type
      dynamic "additional_pod_ranges_config" {
        for_each = ip_allocation_policy.value.additional_pod_ranges_config != null ? [ip_allocation_policy.value.additional_pod_ranges_config] : []
        content {
          pod_range_names = additional_pod_ranges_config.value.pod_range_names
        }
      }
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []

    content {
      enable_components = logging_config.value.enable_components
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

  dynamic "master_auth" {
    for_each = var.master_auth != null ? [var.master_auth] : []

    content {
      client_certificate_config {
        issue_client_certificate = master_auth.value.client_certificate_config.issue_client_certificate
      }

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

  dynamic "monitoring_config" {
    for_each = var.monitoring_config != null ? [var.monitoring_config] : []

    content {
      enable_components = monitoring_config.value.enable_components
    }
  }

  dynamic "network_policy" {
    for_each = var.network_policy != null ? [var.network_policy] : []

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  dynamic "node_config" {
    for_each = var.node_config != null ? [var.node_config] : []

    content {
      disk_size_gb                = node_config.value.disk_size_gb
      disk_type                   = node_config.value.disk_type
      enable_confidential_storage = node_config.value.enable_confidential_storage
      local_ssd_encryption_mode   = node_config.value.local_ssd_encryption_mode
      logging_variant             = node_config.value.logging_variant
      image_type                  = node_config.value.image_type
      labels                      = node_config.value.labels
      resource_labels             = node_config.value.resource_labels
      max_run_duration            = node_config.value.max_run_duration
      flex_start                  = node_config.value.flex_start
      local_ssd_count             = node_config.value.local_ssd_count
      machine_type                = node_config.value.machine_type
      metadata                    = node_config.value.metadata
      min_cpu_platform            = node_config.value.min_cpu_platform
      oauth_scopes                = node_config.value.oauth_scopes
      preemptible                 = node_config.value.preemptible
      spot                        = node_config.value.spot
      boot_disk_kms_key           = node_config.value.boot_disk_kms_key
      service_account             = node_config.value.service_account
      storage_pools               = node_config.value.storage_pools
      tags                        = node_config.value.tags
      resource_manager_tags       = node_config.value.resource_manager_tags
      node_group                  = node_config.value.node_group

      dynamic "confidential_nodes" {
        for_each = node_config.value.confidential_nodes != null ? [node_config.value.confidential_nodes] : []
        content {
          enabled = confidential_nodes.value.enabled
        }
      }

      dynamic "ephemeral_storage_config" {
        for_each = node_config.value.ephemeral_storage_config != null ? [node_config.value.ephemeral_storage_config] : []
        content {
          local_ssd_count = ephemeral_storage_config.value.local_ssd_count
        }
      }

      dynamic "ephemeral_storage_local_ssd_config" {
        for_each = node_config.value.ephemeral_storage_local_ssd_config != null ? [node_config.value.ephemeral_storage_local_ssd_config] : []
        content {
          local_ssd_count  = ephemeral_storage_local_ssd_config.value.local_ssd_count
          data_cache_count = ephemeral_storage_local_ssd_config.value.data_cache_count
        }
      }

      dynamic "fast_socket" {
        for_each = node_config.value.fast_socket != null ? [node_config.value.fast_socket] : []
        content {
          enabled = fast_socket.value.enabled
        }
      }

      dynamic "local_nvme_ssd_block_config" {
        for_each = node_config.value.local_nvme_ssd_block_config != null ? [node_config.value.local_nvme_ssd_block_config] : []
        content {
          local_ssd_count = local_nvme_ssd_block_config.value.local_ssd_count
        }
      }

      dynamic "secondary_boot_disks" {
        for_each = node_config.value.secondary_boot_disks != null ? [node_config.value.secondary_boot_disks] : []
        content {
          disk_image = secondary_boot_disks.value.disk_image
          mode       = secondary_boot_disks.value.mode
        }
      }

      dynamic "gcfs_config" {
        for_each = node_config.value.gcfs_config != null ? [node_config.value.gcfs_config] : []
        content {
          enabled = gcfs_config.value.enabled
        }
      }

      dynamic "gvnic" {
        for_each = node_config.value.gvnic != null ? [node_config.value.gvnic] : []
        content {
          enabled = gvnic.value.enabled
        }
      }

      dynamic "guest_accelerator" {
        for_each = node_config.value.guest_accelerator != null ? [node_config.value.guest_accelerator] : []
        content {
          type               = guest_accelerator.value.type
          count              = guest_accelerator.value.count
          gpu_partition_size = guest_accelerator.value.gpu_partition_size

          dynamic "gpu_driver_installation_config" {
            for_each = guest_accelerator.value.gpu_driver_installation_config != null ? [guest_accelerator.value.gpu_driver_installation_config] : []
            content {
              gpu_driver_version = gpu_driver_installation_config.value.gpu_driver_version
            }
          }

          dynamic "gpu_sharing_config" {
            for_each = guest_accelerator.value.gpu_sharing_config != null ? [guest_accelerator.value.gpu_sharing_config] : []
            content {
              gpu_sharing_strategy       = gpu_sharing_config.value.gpu_sharing_strategy
              max_shared_clients_per_gpu = gpu_sharing_config.value.max_shared_clients_per_gpu
            }
          }
        }
      }

      dynamic "reservation_affinity" {
        for_each = node_config.value.reservation_affinity != null ? [node_config.value.reservation_affinity] : []
        content {
          consume_reservation_type = reservation_affinity.value.consume_reservation_type
          key                      = reservation_affinity.value.key
          values                   = reservation_affinity.value.values
        }
      }

      dynamic "sandbox_config" {
        for_each = node_config.value.sandbox_config != null ? [node_config.value.sandbox_config] : []
        content {
          sandbox_type = sandbox_config.value.sandbox_type
        }
      }

      dynamic "shielded_instance_config" {
        for_each = node_config.value.shielded_instance_config != null ? [node_config.value.shielded_instance_config] : []
        content {
          enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
          enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
        }
      }

      dynamic "taint" {
        for_each = node_config.value.taint != null ? node_config.value.taint : []
        content {
          key    = taint.value.key
          value  = taint.value.value
          effect = taint.value.effect
        }
      }

      dynamic "workload_metadata_config" {
        for_each = node_config.value.workload_metadata_config != null ? [node_config.value.workload_metadata_config] : []
        content {
          mode = workload_metadata_config.value.mode
        }
      }

      dynamic "kubelet_config" {
        for_each = node_config.value.kubelet_config != null ? [node_config.value.kubelet_config] : []
        content {
          cpu_manager_policy                     = kubelet_config.value.cpu_manager_policy
          cpu_cfs_quota                          = kubelet_config.value.cpu_cfs_quota
          cpu_cfs_quota_period                   = kubelet_config.value.cpu_cfs_quota_period
          insecure_kubelet_readonly_port_enabled = upper(tostring(kubelet_config.value.insecure_kubelet_readonly_port_enabled))
          pod_pids_limit                         = kubelet_config.value.pod_pids_limit
          container_log_max_size                 = kubelet_config.value.container_log_max_size
          container_log_max_files                = kubelet_config.value.container_log_max_files
          image_gc_low_threshold_percent         = kubelet_config.value.image_gc_low_threshold_percent
          image_gc_high_threshold_percent        = kubelet_config.value.image_gc_high_threshold_percent
          image_minimum_gc_age                   = kubelet_config.value.image_minimum_gc_age
          allowed_unsafe_sysctls                 = kubelet_config.value.allowed_unsafe_sysctls
        }
      }

      dynamic "linux_node_config" {
        for_each = node_config.value.linux_node_config != null ? [node_config.value.linux_node_config] : []
        content {
          sysctls     = linux_node_config.value.sysctls
          cgroup_mode = linux_node_config.value.cgroup_mode

          dynamic "hugepages_config" {
            for_each = linux_node_config.value.hugepages_config != null ? [linux_node_config.value.hugepages_config] : []
            content {
              hugepage_size_2m = hugepages_config.value.hugepage_size_2m
              hugepage_size_1g = hugepages_config.value.hugepage_size_1g
            }
          }
        }
      }

      dynamic "windows_node_config" {
        for_each = node_config.value.windows_node_config != null ? [node_config.value.windows_node_config] : []
        content {
          osversion = windows_node_config.value.osversion
        }
      }

      dynamic "containerd_config" {
        for_each = node_config.value.containerd_config != null ? [node_config.value.containerd_config] : []
        content {
          dynamic "private_registry_access_config" {
            for_each = containerd_config.value.private_registry_access_config != null ? [containerd_config.value.private_registry_access_config] : []
            content {
              enabled = private_registry_access_config.value.enabled

              dynamic "certificate_authority_domain_config" {
                for_each = private_registry_access_config.value.certificate_authority_domain_config != null ? private_registry_access_config.value.certificate_authority_domain_config : []
                content {
                  fqdns = certificate_authority_domain_config.value.fqdns

                  dynamic "gcp_secret_manager_certificate_config" {
                    for_each = certificate_authority_domain_config.value.gcp_secret_manager_certificate_config != null ? [certificate_authority_domain_config.value.gcp_secret_manager_certificate_config] : []
                    content {
                      secret_uri = gcp_secret_manager_certificate_config.value.secret_uri
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "sole_tenant_config" {
        for_each = node_config.value.sole_tenant_config != null ? [node_config.value.sole_tenant_config] : []
        content {
          dynamic "node_affinity" {
            for_each = sole_tenant_config.value.node_affinity != null ? sole_tenant_config.value.node_affinity : []
            content {
              key      = node_affinity.value.key
              operator = node_affinity.value.operator
              values   = node_affinity.value.values
            }
          }
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


  dynamic "node_pool" {
    for_each = var.node_pool != null ? var.node_pool : []

    content {
      name               = node_pool.value.name
      node_count         = node_pool.value.node_count
      version            = node_pool.value.version
      node_locations     = node_pool.value.node_locations
      initial_node_count = node_pool.value.initial_node_count
      max_pods_per_node  = node_pool.value.max_pods_per_node

      dynamic "autoscaling" {
        for_each = node_pool.value.autoscaling != null ? [node_pool.value.autoscaling] : []
        content {
          min_node_count       = autoscaling.value.min_node_count
          max_node_count       = autoscaling.value.max_node_count
          total_min_node_count = autoscaling.value.total_min_node_count
          total_max_node_count = autoscaling.value.total_max_node_count
          location_policy      = autoscaling.value.location_policy
        }
      }

      dynamic "management" {
        for_each = node_pool.value.management != null ? [node_pool.value.management] : []
        content {
          auto_repair  = management.value.auto_repair
          auto_upgrade = management.value.auto_upgrade
        }
      }

      dynamic "node_config" {
        for_each = node_pool.value.node_config != null ? [node_pool.value.node_config] : []
        content {
          disk_size_gb                = node_config.value.disk_size_gb
          disk_type                   = node_config.value.disk_type
          enable_confidential_storage = node_config.value.enable_confidential_storage
          local_ssd_encryption_mode   = node_config.value.local_ssd_encryption_mode
          image_type                  = node_config.value.image_type
          labels                      = node_config.value.labels
          resource_labels             = node_config.value.resource_labels
          max_run_duration            = node_config.value.max_run_duration
          flex_start                  = node_config.value.flex_start
          local_ssd_count             = node_config.value.local_ssd_count
          machine_type                = node_config.value.machine_type
          metadata                    = node_config.value.metadata
          min_cpu_platform            = node_config.value.min_cpu_platform
          oauth_scopes                = node_config.value.oauth_scopes
          preemptible                 = node_config.value.preemptible
          spot                        = node_config.value.spot
          boot_disk_kms_key           = node_config.value.boot_disk_kms_key
          service_account             = node_config.value.service_account
          storage_pools               = node_config.value.storage_pools
          tags                        = node_config.value.tags
          resource_manager_tags       = node_config.value.resource_manager_tags
          node_group                  = node_config.value.node_group
          logging_variant             = node_config.value.logging_variant

          dynamic "confidential_nodes" {
            for_each = node_config.value.confidential_nodes != null ? [node_config.value.confidential_nodes] : []
            content {
              enabled = confidential_nodes.value.enabled
            }
          }

          dynamic "ephemeral_storage_config" {
            for_each = node_config.value.ephemeral_storage_config != null ? [node_config.value.ephemeral_storage_config] : []
            content {
              local_ssd_count = ephemeral_storage_config.value.local_ssd_count
            }
          }

          dynamic "ephemeral_storage_local_ssd_config" {
            for_each = node_config.value.ephemeral_storage_local_ssd_config != null ? [node_config.value.ephemeral_storage_local_ssd_config] : []
            content {
              local_ssd_count  = ephemeral_storage_local_ssd_config.value.local_ssd_count
              data_cache_count = ephemeral_storage_local_ssd_config.value.data_cache_count
            }
          }

          dynamic "fast_socket" {
            for_each = node_config.value.fast_socket != null ? [node_config.value.fast_socket] : []
            content {
              enabled = fast_socket.value.enabled
            }
          }

          dynamic "local_nvme_ssd_block_config" {
            for_each = node_config.value.local_nvme_ssd_block_config != null ? [node_config.value.local_nvme_ssd_block_config] : []
            content {
              local_ssd_count = local_nvme_ssd_block_config.value.local_ssd_count
            }
          }

          dynamic "secondary_boot_disks" {
            for_each = node_config.value.secondary_boot_disks != null ? node_config.value.secondary_boot_disks : []
            content {
              disk_image = secondary_boot_disks.value.disk_image
              mode       = secondary_boot_disks.value.mode
            }
          }

          dynamic "gcfs_config" {
            for_each = node_config.value.gcfs_config != null ? [node_config.value.gcfs_config] : []
            content {
              enabled = gcfs_config.value.enabled
            }
          }

          dynamic "gvnic" {
            for_each = node_config.value.gvnic != null ? [node_config.value.gvnic] : []
            content {
              enabled = gvnic.value.enabled
            }
          }

          dynamic "guest_accelerator" {
            for_each = node_config.value.guest_accelerator != null ? node_config.value.guest_accelerator : []
            content {
              type               = guest_accelerator.value.type
              count              = guest_accelerator.value.count
              gpu_partition_size = guest_accelerator.value.gpu_partition_size

              dynamic "gpu_driver_installation_config" {
                for_each = guest_accelerator.value.gpu_driver_installation_config != null ? [guest_accelerator.value.gpu_driver_installation_config] : []
                content {
                  gpu_driver_version = gpu_driver_installation_config.value.gpu_driver_version
                }
              }

              dynamic "gpu_sharing_config" {
                for_each = guest_accelerator.value.gpu_sharing_config != null ? [guest_accelerator.value.gpu_sharing_config] : []
                content {
                  gpu_sharing_strategy       = gpu_sharing_config.value.gpu_sharing_strategy
                  max_shared_clients_per_gpu = gpu_sharing_config.value.max_shared_clients_per_gpu
                }
              }
            }
          }

          dynamic "reservation_affinity" {
            for_each = node_config.value.reservation_affinity != null ? [node_config.value.reservation_affinity] : []
            content {
              consume_reservation_type = reservation_affinity.value.consume_reservation_type
              key                      = reservation_affinity.value.key
              values                   = reservation_affinity.value.values
            }
          }

          dynamic "sandbox_config" {
            for_each = node_config.value.sandbox_config != null ? [node_config.value.sandbox_config] : []
            content {
              sandbox_type = sandbox_config.value.sandbox_type
            }
          }

          dynamic "shielded_instance_config" {
            for_each = node_config.value.shielded_instance_config != null ? [node_config.value.shielded_instance_config] : []
            content {
              enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
              enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
            }
          }

          dynamic "taint" {
            for_each = node_config.value.taint != null ? node_config.value.taint : []
            content {
              key    = taint.value.key
              value  = taint.value.value
              effect = taint.value.effect
            }
          }

          dynamic "workload_metadata_config" {
            for_each = node_config.value.workload_metadata_config != null ? [node_config.value.workload_metadata_config] : []
            content {
              mode = workload_metadata_config.value.mode
            }
          }

          dynamic "kubelet_config" {
            for_each = node_config.value.kubelet_config != null ? [node_config.value.kubelet_config] : []
            content {
              cpu_manager_policy                     = kubelet_config.value.cpu_manager_policy
              cpu_cfs_quota                          = kubelet_config.value.cpu_cfs_quota
              cpu_cfs_quota_period                   = kubelet_config.value.cpu_cfs_quota_period
              insecure_kubelet_readonly_port_enabled = upper(tostring(kubelet_config.value.insecure_kubelet_readonly_port_enabled))
              pod_pids_limit                         = kubelet_config.value.pod_pids_limit
              container_log_max_size                 = kubelet_config.value.container_log_max_size
              container_log_max_files                = kubelet_config.value.container_log_max_files
              image_gc_low_threshold_percent         = kubelet_config.value.image_gc_low_threshold_percent
              image_gc_high_threshold_percent        = kubelet_config.value.image_gc_high_threshold_percent
              image_minimum_gc_age                   = kubelet_config.value.image_minimum_gc_age
              allowed_unsafe_sysctls                 = kubelet_config.value.allowed_unsafe_sysctls
            }
          }

          dynamic "linux_node_config" {
            for_each = node_config.value.linux_node_config != null ? [node_config.value.linux_node_config] : []
            content {
              sysctls     = linux_node_config.value.sysctls
              cgroup_mode = linux_node_config.value.cgroup_mode
              dynamic "hugepages_config" {
                for_each = linux_node_config.value.hugepages_config != null ? [linux_node_config.value.hugepages_config] : []
                content {
                  hugepage_size_2m = hugepages_config.value.hugepage_size_2m
                  hugepage_size_1g = hugepages_config.value.hugepage_size_1g
                }
              }
            }
          }

          dynamic "windows_node_config" {
            for_each = node_config.value.windows_node_config != null ? [node_config.value.windows_node_config] : []
            content {
              osversion = windows_node_config.value.osversion
            }
          }

          dynamic "containerd_config" {
            for_each = node_config.value.containerd_config != null ? [node_config.value.containerd_config] : []
            content {
              dynamic "private_registry_access_config" {
                for_each = containerd_config.value.private_registry_access_config != null ? [containerd_config.value.private_registry_access_config] : []
                content {
                  enabled = private_registry_access_config.value.enabled
                  dynamic "certificate_authority_domain_config" {
                    for_each = private_registry_access_config.value.certificate_authority_domain_config != null ? private_registry_access_config.value.certificate_authority_domain_config : []
                    content {
                      fqdns = certificate_authority_domain_config.value.fqdns
                      dynamic "gcp_secret_manager_certificate_config" {
                        for_each = certificate_authority_domain_config.value.gcp_secret_manager_certificate_config != null ? [certificate_authority_domain_config.value.gcp_secret_manager_certificate_config] : []
                        content {
                          secret_uri = gcp_secret_manager_certificate_config.value.secret_uri
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "sole_tenant_config" {
            for_each = node_config.value.sole_tenant_config != null ? [node_config.value.sole_tenant_config] : []
            content {
              dynamic "node_affinity" {
                for_each = sole_tenant_config.value.node_affinity != null ? sole_tenant_config.value.node_affinity : []
                content {
                  key      = node_affinity.value.key
                  operator = node_affinity.value.operator
                  values   = node_affinity.value.values
                }
              }
            }
          }
        }
      }

      dynamic "network_config" {
        for_each = node_pool.value.network_config != null ? [node_pool.value.network_config] : []
        content {
          create_pod_range     = network_config.value.create_pod_range
          enable_private_nodes = network_config.value.enable_private_nodes
          pod_ipv4_cidr_block  = network_config.value.pod_ipv4_cidr_block
          pod_range            = network_config.value.pod_range

          dynamic "additional_node_network_configs" {
            for_each = network_config.value.additional_node_network_configs != null ? network_config.value.additional_node_network_configs : []
            content {
              network    = additional_node_network_configs.value.network
              subnetwork = additional_node_network_configs.value.subnetwork
            }
          }

          dynamic "additional_pod_network_configs" {
            for_each = network_config.value.additional_pod_network_configs != null ? network_config.value.additional_pod_network_configs : []
            content {
              subnetwork          = additional_pod_network_configs.value.subnetwork
              secondary_pod_range = additional_pod_network_configs.value.secondary_pod_range
              max_pods_per_node   = additional_pod_network_configs.value.max_pods_per_node
            }
          }

          dynamic "pod_cidr_overprovision_config" {
            for_each = network_config.value.pod_cidr_overprovision_config != null ? [network_config.value.pod_cidr_overprovision_config] : []
            content {
              disabled = pod_cidr_overprovision_config.value.disabled
            }
          }

          dynamic "network_performance_config" {
            for_each = network_config.value.network_performance_config != null ? [network_config.value.network_performance_config] : []
            content {
              total_egress_bandwidth_tier = network_performance_config.value.total_egress_bandwidth_tier
            }
          }
        }
      }

      dynamic "upgrade_settings" {
        for_each = node_pool.value.upgrade_settings != null ? [node_pool.value.upgrade_settings] : []
        content {
          max_surge       = upgrade_settings.value.max_surge
          max_unavailable = upgrade_settings.value.max_unavailable
          strategy        = upgrade_settings.value.strategy

          dynamic "blue_green_settings" {
            for_each = upgrade_settings.value.blue_green_settings != null ? [upgrade_settings.value.blue_green_settings] : []
            content {
              node_pool_soak_duration = blue_green_settings.value.node_pool_soak_duration
              dynamic "standard_rollout_policy" {
                for_each = blue_green_settings.value.standard_rollout_policy != null ? [blue_green_settings.value.standard_rollout_policy] : []
                content {
                  batch_percentage    = standard_rollout_policy.value.batch_percentage
                  batch_node_count    = standard_rollout_policy.value.batch_node_count
                  batch_soak_duration = standard_rollout_policy.value.batch_soak_duration
                }
              }
            }
          }
        }
      }

      dynamic "placement_policy" {
        for_each = node_pool.value.placement_policy != null ? [node_pool.value.placement_policy] : []
        content {
          type         = placement_policy.value.type
          policy_name  = placement_policy.value.policy_name
          tpu_topology = placement_policy.value.tpu_topology
        }
      }

      dynamic "queued_provisioning" {
        for_each = node_pool.value.queued_provisioning != null ? [node_pool.value.queued_provisioning] : []
        content {
          enabled = queued_provisioning.value.enabled
        }
      }
    }
  }

  dynamic "node_pool_defaults" {
    for_each = var.node_pool_defaults != null ? [var.node_pool_defaults] : []

    content {
      dynamic "node_config_defaults" {
        for_each = node_pool_defaults.value.node_config_defaults != null ? [node_pool_defaults.value.node_config_defaults] : []
        content {
          logging_variant                        = node_config_defaults.value.logging_variant
          insecure_kubelet_readonly_port_enabled = upper(tostring(node_config_defaults.value.insecure_kubelet_readonly_port_enabled))
          dynamic "gcfs_config" {
            for_each = node_config_defaults.value.gcfs_config != null ? [node_config_defaults.value.gcfs_config] : []
            content {
              enabled = gcfs_config.value.enabled
            }
          }
        }
      }
    }
  }

  node_version = var.node_version

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

  dynamic "confidential_nodes" {
    for_each = var.confidential_nodes != null ? [var.confidential_nodes] : []
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  dynamic "pod_security_policy_config" {
    for_each = var.pod_security_policy_config != null ? [var.pod_security_policy_config] : []
    content {
      enabled = pod_security_policy_config.value.enabled
    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.vertical_pod_autoscaling != null ? [var.vertical_pod_autoscaling] : []
    content {
      enabled = vertical_pod_autoscaling.value.enabled
    }
  }

  dynamic "pod_autoscaling" {
    for_each = var.pod_autoscaling != null ? [var.pod_autoscaling] : []
    content {
      hpa_profile = pod_autoscaling.value.hpa_profile
    }
  }

  dynamic "secret_manager_config" {
    for_each = var.secret_manager_config != null ? [var.secret_manager_config] : []
    content {
      enabled = secret_manager_config.value.enabled
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = var.authenticator_groups_config != null ? [var.authenticator_groups_config] : []
    content {
      security_group = authenticator_groups_config.value.security_group
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

  dynamic "cluster_telemetry" {
    for_each = var.cluster_telemetry != null ? [var.cluster_telemetry] : []
    content {
      type = cluster_telemetry.value.type
    }
  }

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [var.release_channel] : []
    content {
      channel = release_channel.value.channel
    }
  }

  remove_default_node_pool = var.remove_default_node_pool


  dynamic "cost_management_config" {
    for_each = var.cost_management_config != null ? [var.cost_management_config] : []
    content {
      enabled = cost_management_config.value.enabled
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

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_config != null ? [var.workload_identity_config] : []
    content {
      workload_pool = workload_identity_config.value.workload_pool
    }
  }

  dynamic "identity_service_config" {
    for_each = var.identity_service_config != null ? [var.identity_service_config] : []
    content {
      enabled = identity_service_config.value.enabled
    }
  }

  enable_intranode_visibility              = var.enable_intranode_visibility
  enable_l4_ilb_subsetting                 = var.enable_l4_ilb_subsetting
  disable_l4_lb_firewall_reconciliation    = var.disable_l4_lb_firewall_reconciliation
  enable_multi_networking                  = var.enable_multi_networking
  enable_fqdn_network_policy               = var.enable_fqdn_network_policy
  private_ipv6_google_access               = var.private_ipv6_google_access
  datapath_provider                        = var.datapath_provider
  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy
  in_transit_encryption_config             = var.in_transit_encryption_config

  dynamic "default_snat_status" {
    for_each = var.default_snat_status != null ? [var.default_snat_status] : []
    content {
      disabled = default_snat_status.value.disabled
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

  dynamic "gateway_api_config" {
    for_each = var.gateway_api_config != null ? [var.gateway_api_config] : []
    content {
      channel = gateway_api_config.value.channel
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

  dynamic "workload_alts_config" {
    for_each = var.workload_alts_config != null ? [var.workload_alts_config] : []
    content {
      enable_alts = workload_alts_config.value.enable_alts
    }
  }

  dynamic "enterprise_config" {
    for_each = var.enterprise_config != null ? [var.enterprise_config] : []
    content {
      desired_tier = enterprise_config.value.desired_tier
    }
  }


  lifecycle {
    ignore_changes = [node_pool, initial_node_count, resource_labels["asmv"]] # asmv: Anthos Service Mesh version
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}
