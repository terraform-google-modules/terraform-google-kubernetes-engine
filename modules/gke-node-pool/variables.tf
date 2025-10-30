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

variable "cluster" {
  description = "The cluster to create the node pool for. Cluster must be present in location provided for clusters. May be specified in the format projects/{project_id}/locations/{location}/clusters/{cluster} or as just the name of the cluster."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which to create the node pool."
  type        = string
}

variable "location" {
  description = "The location (region or zone) of the cluster."
  type        = string
  default     = null
}

variable "autoscaling" {
  description = "Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage."
  type = object({
    min_node_count       = optional(number)
    max_node_count       = optional(number)
    total_min_node_count = optional(number)
    total_max_node_count = optional(number)
    location_policy      = optional(string)
  })
  default = {
    min_node_count = 1
    max_node_count = 100
  }
}

variable "initial_node_count" {
  description = "The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone."
  type        = number
  default     = null
}

variable "management" {
  description = <<EOT
Node management configuration, wherein auto-repair and auto-upgrade is configured.
  - auto_repair: Whether the nodes will be automatically repaired. Enabled by default.
  - auto_upgrade : Whether the nodes will be automatically upgraded. Enabled by default.
EOT
  type = object({
    auto_repair  = optional(bool)
    auto_upgrade = optional(bool)
  })
  default = {
    auto_repair  = true
    auto_upgrade = true
  }
}

variable "max_pods_per_node" {
  description = "The maximum number of pods per node in this node pool. Note that this does not work on node pools which are 'route-based' - that is, node pools belonging to clusters that do not have IP Aliasing enabled. See the [official documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr) for more information."
  type        = number
  default     = null
}

variable "node_locations" {
  description = "The list of zones in which the node pool's nodes should be located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If unspecified, the cluster-level node_locations will be used. Note: node_locations will not revert to the cluster's default set of zones upon being unset. You must manually reconcile the list of zones with your cluster."
  type        = list(string)
  default     = null
}

variable "name" {
  description = "The name of the node pool. If left blank, Terraform will auto-generate a unique name."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name for the node pool beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "node_config" {
  description = "Parameters used in creating the node pool."
  type = object({
    confidential_nodes = optional(object({
      enabled = bool
    }))
    disk_size_gb                = optional(number)
    disk_type                   = optional(string)
    enable_confidential_storage = optional(bool)
    local_ssd_encryption_mode   = optional(string)
    ephemeral_storage_config = optional(object({
      local_ssd_count = number
    }))
    ephemeral_storage_local_ssd_config = optional(object({
      local_ssd_count  = number
      data_cache_count = optional(number)
    }))
    fast_socket = optional(object({
      enabled = bool
    }))
    local_nvme_ssd_block_config = optional(object({
      local_ssd_count = number
    }))
    logging_variant = optional(string)
    secondary_boot_disks = optional(object({
      disk_image = string
      mode       = optional(string)
    }))
    gcfs_config = optional(object({
      enabled = bool
    }))
    gvnic = optional(object({
      enabled = bool
    }))
    guest_accelerator = optional(object({
      type  = string
      count = number
      gpu_driver_installation_config = optional(object({
        gpu_driver_version = string
      }))
      gpu_partition_size = optional(string)
      gpu_sharing_config = optional(object({
        gpu_sharing_strategy       = string
        max_shared_clients_per_gpu = number
      }))
    }))
    image_type       = optional(string)
    labels           = optional(map(string))
    resource_labels  = optional(map(string))
    max_run_duration = optional(string)
    flex_start       = optional(bool)
    local_ssd_count  = optional(number)
    machine_type     = optional(string)
    metadata         = optional(map(string))
    min_cpu_platform = optional(string)
    oauth_scopes     = optional(list(string))
    preemptible      = optional(bool)
    reservation_affinity = optional(object({
      consume_reservation_type = string
      key                      = optional(string)
      values                   = optional(list(string))
    }))
    spot = optional(bool)
    sandbox_config = optional(object({
      sandbox_type = string
    }))
    boot_disk_kms_key = optional(string)
    service_account   = optional(string)
    shielded_instance_config = optional(object({
      enable_secure_boot          = optional(bool)
      enable_integrity_monitoring = optional(bool)
    }))
    storage_pools         = optional(list(string))
    tags                  = optional(list(string))
    resource_manager_tags = optional(map(string))
    taint = optional(list(object({
      key    = string
      value  = string
      effect = string
    })))
    workload_metadata_config = optional(object({
      mode = optional(string)
    }))
    kubelet_config = optional(object({
      cpu_manager_policy                     = optional(string)
      cpu_cfs_quota                          = optional(bool)
      cpu_cfs_quota_period                   = optional(string)
      insecure_kubelet_readonly_port_enabled = optional(bool)
      pod_pids_limit                         = optional(number)
      container_log_max_size                 = optional(string)
      container_log_max_files                = optional(number)
      image_gc_low_threshold_percent         = optional(number)
      image_gc_high_threshold_percent        = optional(number)
      image_minimum_gc_age                   = optional(string)
      allowed_unsafe_sysctls                 = optional(list(string))
    }))
    linux_node_config = optional(object({
      sysctls     = optional(map(string))
      cgroup_mode = optional(string)
      hugepages_config = optional(object({
        hugepage_size_2m = optional(number)
        hugepage_size_1g = optional(number)
      }))
    }))
    windows_node_config = optional(object({
      osversion = string
    }))
    containerd_config = optional(object({
      private_registry_access_config = optional(object({
        enabled = bool
        certificate_authority_domain_config = optional(object({
          fqdns = list(string)
          gcp_secret_manager_certificate_config = object({
            secret_uri = string
          })
        }))
      }))
    }))
    node_group = optional(string)
    sole_tenant_config = optional(object({
      node_affinity = optional(object({
        key      = string
        operator = string
        values   = list(string)
      }))
    }))
  })
  default = {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"
    machine_type = "e2-medium"
    workload_metadata_config = {
      mode = "GKE_METADATA"
    }
    kubelet_config = {
      insecure_kubelet_readonly_port_enabled = false
    }
  }
}

variable "network_config" {
  description = "The network configuration of the pool."
  type = object({
    create_pod_range     = optional(bool)
    enable_private_nodes = optional(bool)
    pod_ipv4_cidr_block  = optional(string)
    pod_range            = optional(string)
    additional_node_network_configs = optional(object({
      network    = string
      subnetwork = string
    }))
    additional_pod_network_configs = optional(object({
      subnetwork          = string
      secondary_pod_range = string
      max_pods_per_node   = number
    }))
    pod_cidr_overprovision_config = optional(object({
      disabled = bool
    }))
    network_performance_config = optional(object({
      total_egress_bandwidth_tier = string
    }))
  })

  default = null
}

variable "node_count" {
  description = "The number of nodes per instance group. This field can be used to update the number of nodes per instance group but should not be used alongside autoscaling."
  type        = number
  default     = 1
}


variable "upgrade_settings" {
  description = "Specify node upgrade settings to change how GKE upgrades nodes."
  type = object({
    max_surge       = optional(number)
    max_unavailable = optional(number)
    strategy        = optional(string)
    blue_green_settings = optional(object({
      standard_rollout_policy = object({
        batch_percentage    = optional(number)
        batch_node_count    = optional(number)
        batch_soak_duration = optional(string)
      })
      node_pool_soak_duration = optional(string)
    }))
  })
  default = {
    max_surge       = 1
    max_unavailable = 0
    strategy        = "SURGE"
  }
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the nodes in this pool. Note that if this field and auto_upgrade are both specified, they will fight each other for what the node version should be, so setting both is highly discouraged. While a fuzzy version can be specified, it's recommended that you specify explicit versions as Terraform will see spurious diffs when fuzzy versions are used. See the google_container_engine_versions data source's version_prefix field to approximate fuzzy versions in a Terraform-compatible way."
  type        = string
  default     = null
}

variable "placement_policy" {
  description = <<EOT
  Specifies a custom placement policy for the nodes.
    - type: The type of the policy. Supports a single value: COMPACT. Specifying COMPACT placement policy type places node pool's nodes in a closer physical proximity in order to reduce network latency between nodes.
    - policy_name: If set, refers to the name of a custom resource policy supplied by the user. The resource policy must be in the same project and region as the node pool. If not found, InvalidArgument error is returned.
    - tpu_topology: The TPU topology like "2x4" or "2x2x2".
  EOT
  type = object({
    type         = string
    policy_name  = optional(string)
    tpu_topology = optional(string)
  })
  default = null
}

variable "queued_provisioning" {
  description = <<EOT
  Specifies node pool-level settings of queued provisioning.
    - enabled (Required) - Makes nodes obtainable through the ProvisioningRequest API exclusively.
  EOT
  type = object({
    enabled = bool
  })
  default = null
}

variable "timeouts" {
  description = "Timeout for cluster operations."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}
