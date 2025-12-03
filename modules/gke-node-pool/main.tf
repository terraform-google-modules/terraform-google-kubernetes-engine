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

resource "google_container_node_pool" "main" {
  provider = google-beta

  name        = var.name
  name_prefix = var.name_prefix
  project     = var.project_id
  cluster     = var.cluster
  location    = var.location

  initial_node_count = var.initial_node_count
  max_pods_per_node  = var.max_pods_per_node
  node_locations     = var.node_locations
  node_count         = var.node_count
  version            = var.kubernetes_version

  dynamic "autoscaling" {
    for_each = var.autoscaling != null ? [var.autoscaling] : []
    content {
      min_node_count       = autoscaling.value.total_min_node_count != null ? null : autoscaling.value.min_node_count
      max_node_count       = autoscaling.value.total_max_node_count != null ? null : autoscaling.value.max_node_count
      location_policy      = autoscaling.value.location_policy
      total_min_node_count = autoscaling.value.total_min_node_count
      total_max_node_count = autoscaling.value.total_max_node_count
    }
  }

  dynamic "management" {
    for_each = var.management != null ? [var.management] : []
    content {
      auto_repair  = management.value.auto_repair
      auto_upgrade = management.value.auto_upgrade
    }
  }


  dynamic "node_config" {
    for_each = var.node_config != null ? [var.node_config] : []
    content {

      dynamic "confidential_nodes" {
        for_each = node_config.value.confidential_nodes != null ? [node_config.value.confidential_nodes] : []
        content {
          enabled = confidential_nodes.value.enabled
        }
      }

      disk_size_gb                = node_config.value.disk_size_gb
      disk_type                   = node_config.value.disk_type
      enable_confidential_storage = node_config.value.enable_confidential_storage
      local_ssd_encryption_mode   = node_config.value.local_ssd_encryption_mode

      dynamic "ephemeral_storage_config" {
        for_each = node_config.value.ephemeral_storage_config != null ? [node_config.value.ephemeral_storage_config] : []
        content {
          local_ssd_count = ephemeral_storage_config.value.local_ssd_count
        }
      }

      dynamic "ephemeral_storage_local_ssd_config" {
        for_each = node_config.value.ephemeral_storage_local_ssd_config != null ? [node_config.value.ephemeral_storage_local_ssd_config] : []
        content {
          data_cache_count = ephemeral_storage_local_ssd_config.value.data_cache_count
          local_ssd_count  = ephemeral_storage_local_ssd_config.value.local_ssd_count
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

      logging_variant = node_config.value.logging_variant

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

          gpu_driver_installation_config {
            gpu_driver_version = guest_accelerator.value.gpu_driver_installation_config.gpu_driver_version
          }

          gpu_sharing_config {
            gpu_sharing_strategy       = guest_accelerator.value.gpu_sharing_config.gpu_sharing_strategy
            max_shared_clients_per_gpu = guest_accelerator.value.gpu_sharing_config.max_shared_clients_per_gpu
          }
        }

      }

      image_type       = node_config.value.image_type
      labels           = node_config.value.labels
      resource_labels  = node_config.value.resource_labels
      max_run_duration = node_config.value.max_run_duration
      flex_start       = node_config.value.flex_start
      local_ssd_count  = node_config.value.local_ssd_count
      machine_type     = node_config.value.machine_type
      metadata         = node_config.value.metadata
      min_cpu_platform = node_config.value.min_cpu_platform
      oauth_scopes     = node_config.value.oauth_scopes
      preemptible      = node_config.value.preemptible

      dynamic "reservation_affinity" {
        for_each = node_config.value.reservation_affinity != null ? [node_config.value.reservation_affinity] : []
        content {
          consume_reservation_type = reservation_affinity.value.consume_reservation_type
          key                      = reservation_affinity.value.key
          values                   = reservation_affinity.value.values
        }
      }

      spot = node_config.value.spot

      dynamic "sandbox_config" {
        for_each = node_config.value.sandbox_config != null ? [node_config.value.sandbox_config] : []
        content {
          sandbox_type = sandbox_config.value.sandbox_type
        }
      }

      boot_disk_kms_key = node_config.value.boot_disk_kms_key
      service_account   = node_config.value.service_account

      dynamic "shielded_instance_config" {
        for_each = node_config.value.shielded_instance_config != null ? [node_config.value.shielded_instance_config] : []
        content {
          enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
          enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
        }
      }

      storage_pools         = node_config.value.storage_pools
      tags                  = node_config.value.tags
      resource_manager_tags = node_config.value.resource_manager_tags

      dynamic "taint" {
        for_each = node_config.value.taint != null ? node_config.value.taint : []
        content {
          effect = taint.value.effect
          key    = taint.value.key
          value  = taint.value.value
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
          cgroup_mode = linux_node_config.value.cgroup_mode
          sysctls     = linux_node_config.value.sysctls
          hugepages_config {
            hugepage_size_1g = linux_node_config.value.hugepages_config.hugepage_size_1g
            hugepage_size_2m = linux_node_config.value.hugepages_config.hugepage_size_2m
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
          private_registry_access_config {
            enabled = containerd_config.value.private_registry_access_config.enabled
            certificate_authority_domain_config {
              fqdns = containerd_config.value.private_registry_access_config.certificate_authority_domain_config.fqdns
              gcp_secret_manager_certificate_config {
                secret_uri = containerd_config.value.private_registry_access_config.certificate_authority_domain_config.gcp_secret_manager_certificate_config.secret_uri
              }
            }
          }
        }
      }

      node_group = node_config.value.node_group

      dynamic "sole_tenant_config" {
        for_each = node_config.value.sole_tenant_config != null ? [node_config.value.sole_tenant_config] : []
        content {
          node_affinity {
            operator = sole_tenant_config.value.node_affinity.operator
            key      = sole_tenant_config.value.node_affinity.key
            values   = sole_tenant_config.value.node_affinity.values
          }
        }
      }
    }
  }

  dynamic "network_config" {
    for_each = var.network_config != null ? [var.network_config] : []
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
    for_each = var.upgrade_settings != null ? [var.upgrade_settings] : []
    content {
      max_surge       = upgrade_settings.value.max_surge
      max_unavailable = upgrade_settings.value.max_unavailable
      strategy        = upgrade_settings.value.strategy
      dynamic "blue_green_settings" {
        for_each = upgrade_settings.value.blue_green_settings != null ? [upgrade_settings.value.blue_green_settings] : []
        content {
          node_pool_soak_duration = blue_green_settings.value.node_pool_soak_duration
          standard_rollout_policy {
            batch_percentage    = blue_green_settings.value.standard_rollout_policy.batch_percentage
            batch_node_count    = blue_green_settings.value.standard_rollout_policy.batch_node_count
            batch_soak_duration = blue_green_settings.value.standard_rollout_policy.batch_soak_duration
          }
        }
      }
    }
  }

  dynamic "placement_policy" {
    for_each = var.placement_policy != null ? [var.placement_policy] : []
    content {
      type         = placement_policy.value.type
      policy_name  = placement_policy.value.policy_name
      tpu_topology = placement_policy.value.tpu_topology
    }
  }

  dynamic "queued_provisioning" {
    for_each = var.queued_provisioning != null ? [var.queued_provisioning] : []
    content {
      enabled = queued_provisioning.value.enabled
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

}
