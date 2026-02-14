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


variable "name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "description" {
  description = "Description of the cluster."
  type        = string
  default     = null
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "location" {
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
  type        = string
}

variable "network" {
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, this network must be in the host project."
  type        = string
}

variable "subnetwork" {
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = string
}

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes are located. Nodes are created in the region's zones by default. This list must be a subset of the compute/zones in the region to which the cluster belongs. This field is optional for Zonal clusters and required for Regional clusters."
  type        = list(string)
  default     = null
}

variable "deletion_protection" {
  type        = bool
  description = "Whether Terraform will be prevented from destroying the cluster. Deleting this cluster via terraform destroy or terraform apply will only succeed if this field is false in the Terraform state."
  default     = false
}

variable "addons_config" {
  description = "The configuration for addons supported by GKE."
  type = object({
    http_load_balancing = optional(object({
      disabled = optional(bool)
    }))
    horizontal_pod_autoscaling = optional(object({
      disabled = optional(bool)
    }))
    network_policy_config = optional(object({
      disabled = optional(bool)
    }))
    istio_config = optional(object({
      disabled = optional(bool)
      auth     = optional(string)
    }))
    dns_cache_config = optional(object({
      enabled = optional(bool)
    }))
    config_connector_config = optional(object({
      enabled = optional(bool)
    }))
    gce_persistent_disk_csi_driver_config = optional(object({
      enabled = optional(bool)
    }))
    kalm_config = optional(object({
      enabled = optional(bool)
    }))
    gcp_filestore_csi_driver_config = optional(object({
      enabled = optional(bool)
    }))
    gke_backup_agent_config = optional(object({
      enabled = optional(bool)
    }))
    gcs_fuse_csi_driver_config = optional(object({
      enabled = optional(bool)
    }))
    stateful_ha_config = optional(object({
      enabled = optional(bool)
    }))
    parallelstore_csi_driver_config = optional(object({
      enabled = optional(bool)
    }))
    ray_operator_config = optional(object({
      enabled = optional(bool)
      ray_cluster_logging_config = optional(object({
        enabled = optional(bool)
      }))
      ray_cluster_monitoring_config = optional(object({
        enabled = optional(bool)
      }))
    }))
  })
  default = null
}

variable "cluster_ipv4_cidr" {
  description = "The IP address range of the Kubernetes pods in this cluster in CIDR notation (e.g. 10.96.0.0/14). Leave blank to have one automatically chosen or specify a /14 block in 10.0.0.0/8. This field will only work for routes-based clusters, where ip_allocation_policy is not defined."
  type        = string
  default     = null
}

variable "cluster_autoscaling" {
  description = "Per-cluster configuration of Node Auto-Provisioning with Cluster Autoscaler to automatically adjust the size of the cluster and create/delete node pools based on the current needs of the cluster's workload. See the [guide to using Node Auto-Provisioning](https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-provisioning) for more details."
  type = object({
    enabled = bool
    resource_limits = list(object({
      resource_type = string
      minimum       = optional(number)
      maximum       = number
    }))
    auto_provisioning_defaults = optional(object({
      min_cpu_platform  = optional(string)
      oauth_scopes      = optional(list(string))
      service_account   = optional(string)
      boot_disk_kms_key = optional(string)
      disk_size         = optional(number)
      disk_type         = optional(string)
      image_type        = optional(string)
      shielded_instance_config = optional(object({
        enable_secure_boot          = optional(bool)
        enable_integrity_monitoring = optional(bool)
      }))
      management = optional(object({
        auto_upgrade = optional(bool)
        auto_repair  = optional(bool)
      }))
      upgrade_settings = optional(object({
        strategy        = optional(string)
        max_surge       = optional(number)
        max_unavailable = optional(number)
        blue_green_settings = optional(object({
          node_pool_soak_duration = optional(string)
          standard_rollout_policy = optional(object({
            batch_percentage    = optional(number)
            batch_node_count    = optional(number)
            batch_soak_duration = optional(string)
          }))
        }))
      }))
    }))
    auto_provisioning_locations = list(string)
    autoscaling_profile         = string
  })

  default = null
}

variable "binary_authorization" {
  description = "Configuration options for the Binary Authorization feature."
  type = object({
    evaluation_mode = optional(string)
  })
  default = null
}

variable "service_external_ips_config" {
  description = "Configuration for controlling how IPs are allocated to Service objects."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "mesh_certificates" {
  description = "Configuration for the provisioning of managed mesh certificates."
  type = object({
    enable_certificates = optional(bool)
  })
  default = null
}

variable "database_encryption" {
  description = "Application-layer Secrets Encryption settings."
  type = object({
    state    = optional(string)
    key_name = optional(string)
  })
  default = null
}

variable "default_max_pods_per_node" {
  description = "The default maximum number of pods per node in this cluster. This doesn't work on route-based clusters, clusters that don't have IP Aliasing enabled."
  type        = number
  default     = 110
}


variable "enable_kubernetes_alpha" {
  description = "Whether to enable Kubernetes Alpha features for this cluster. Note that when this is true, the beta version of the GKE API will be used internally."
  type        = bool
  default     = false
}

variable "enable_k8s_beta_apis" {
  description = "Configuration for Kubernetes Beta APIs."
  type = object({
    enabled_apis = list(string)
  })
  default = null
}

variable "enable_tpu" {
  description = "Whether to enable Cloud TPU resources in this cluster."
  type        = bool
  default     = null
}

variable "enable_legacy_abac" {
  description = "Whether the ABAC authorizer is enabled for this cluster. When enabled, identities with the Kubernetes version of 'cluster-admin' role will have permissions to perform any action on any resource within the cluster."
  type        = bool
  default     = null
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded Nodes features on all nodes in this cluster. Defaults to true."
  type        = bool
  default     = null
}

variable "initial_node_count" {
  description = "The number of nodes to create in this cluster's default node pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Must be set if node_pool is not specified."
  type        = number
  default     = 0
}

variable "ip_allocation_policy" {
  description = "Configuration of cluster IP allocation for VPC-native clusters. If this block is unset during creation, it will be set by the GKE backend. "
  type = object({
    cluster_secondary_range_name  = optional(string)
    services_secondary_range_name = optional(string)
    cluster_ipv4_cidr_block       = optional(string)
    services_ipv4_cidr_block      = optional(string)
    stack_type                    = optional(string)
    additional_pod_ranges_config = optional(object({
      pod_range_names = list(string)
    }))
  })
  default = null
}

variable "logging_config" {
  description = "Logging configuration for the cluster."
  type = object({
    enable_components = optional(list(string))
  })
  default = null
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include `logging.googleapis.com`, `logging.googleapis.com/kubernetes`, and `none`."
  type        = string
  default     = null
}


variable "maintenance_policy" {
  description = "The maintenance policy to use for the cluster."
  type = object({
    daily_maintenance_window = optional(object({
      start_time = optional(string)
    }))
    recurring_window = optional(object({
      start_time = optional(string)
      end_time   = optional(string)
      recurrence = optional(string)
    }))
    maintenance_exclusion = optional(list(object({
      exclusion_name = optional(string)
      start_time     = optional(string)
      end_time       = optional(string)
      exclusion_options = optional(object({
        scope = optional(string)
      }))
    })))
  })
  default = null
}

variable "master_auth" {
  description = "The authentication information for accessing the Kubernetes master."
  type = object({
    client_certificate_config = optional(object({
      issue_client_certificate = optional(bool)
    }))
  })
  default = null
}

variable "master_authorized_networks_config" {
  description = "The desired configuration options for master authorized networks. Cidr Block must follow [Cidr notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation)"
  type = object({
    cidr_blocks = list(object({
      display_name = string
      cidr_block   = string
    }))
    gcp_public_cidrs_access_enabled      = optional(bool)
    private_endpoint_enforcement_enabled = optional(bool)
  })
}

variable "min_master_version" {
  description = "The minimum version of the master. GKE will auto-update the master to new versions, so this does not guarantee the master version--use the read-only master_version field to obtain a current version. If unset, the server's default version will be used."
  type        = string
  default     = null
}

variable "monitoring_config" {
  description = "Monitoring configuration for the cluster."
  type = object({
    enable_components = optional(list(string))
  })
  default = null
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Available options include `monitoring.googleapis.com`, `monitoring.googleapis.com/kubernetes`, and `none`."
  type        = string
  default     = null
}

variable "network_policy" {
  description = "Configuration options for the NetworkPolicy feature."
  type = object({
    enabled  = optional(bool)
    provider = optional(string)
  })
  default = null
}

variable "node_config" {
  description = "Parameters used in creating the default node pool. Generally, this field should not be used at the same time as a `google_container_node_pool` or a `node_pool` block; this configuration is inherited by the default node pool, and can conflict with configuration in the separate resource or block."
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
  default = null
}

variable "node_pool_auto_config" {
  description = "Node pool auto-configuration for the cluster. This block contains settings for managing Kubelet, resource manager tags, network tags, and Linux node configurations for automatically provisioned node pools."
  type = object({
    node_kubelet_config = optional(object({
      insecure_kubelet_readonly_port_enabled = optional(bool)
    }))
    resource_manager_tags = optional(map(string))
    network_tags = optional(object({
      tags = optional(list(string))
    }))
    linux_node_config = optional(object({
      cgroup_mode = optional(string)
    }))
  })
  default = {
    node_kubelet_config = {
      insecure_kubelet_readonly_port_enabled = false
    }
  }
}

variable "node_pool" {
  description = "List of node pools associated with this cluster. See google_container_node_pool for schema. Warning: node pools defined inside a cluster can't be changed after creation without destroying and recreating the cluster. You should use google_container_node_pool instead of this property."
  type = list(object({
    cluster            = optional(string)
    project            = optional(string)
    location           = optional(string, null)
    name               = optional(string, null)
    name_prefix        = optional(string, null)
    node_count         = optional(number, 1)
    kubernetes_version = optional(string, null)
    node_locations     = optional(list(string), [])
    initial_node_count = optional(number, null)
    max_pods_per_node  = optional(number, null)

    autoscaling = optional(object({
      min_node_count       = optional(number)
      max_node_count       = optional(number)
      total_min_node_count = optional(number)
      total_max_node_count = optional(number)
      location_policy      = optional(string)
    }))

    management = optional(object({
      auto_repair  = optional(bool)
      auto_upgrade = optional(bool)
    }))

    node_config = optional(object({
      disk_size_gb                = optional(number)
      disk_type                   = optional(string)
      enable_confidential_storage = optional(bool)
      local_ssd_encryption_mode   = optional(string)
      image_type                  = optional(string)
      labels                      = optional(map(string))
      resource_labels             = optional(map(string))
      max_run_duration            = optional(string)
      flex_start                  = optional(bool)
      local_ssd_count             = optional(number)
      machine_type                = optional(string)
      metadata                    = optional(map(string))
      min_cpu_platform            = optional(string)
      oauth_scopes                = optional(list(string))
      preemptible                 = optional(bool)
      spot                        = optional(bool)
      boot_disk_kms_key           = optional(string)
      service_account             = optional(string)
      storage_pools               = optional(list(string))
      tags                        = optional(list(string))
      resource_manager_tags       = optional(map(string))
      node_group                  = optional(string)
      confidential_nodes = optional(object({
        enabled = bool
      }))
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
      reservation_affinity = optional(object({
        consume_reservation_type = string
        key                      = optional(string)
        values                   = optional(list(string))
      }))
      sandbox_config = optional(object({
        sandbox_type = string
      }))
      shielded_instance_config = optional(object({
        enable_secure_boot          = optional(bool)
        enable_integrity_monitoring = optional(bool)
      }))
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
      sole_tenant_config = optional(object({
        node_affinity = optional(object({
          key      = string
          operator = string
          values   = list(string)
        }))
      }))
    }))

    network_config = optional(object({
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
    }))

    upgrade_settings = optional(object({
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
    }))

    placement_policy = optional(object({
      type         = string
      policy_name  = optional(string)
      tpu_topology = optional(string)
    }))

    queued_provisioning = optional(object({
      enabled = bool
    }))
  }))

  default = null
}

variable "node_pool_defaults" {
  description = "Default NodePool settings for the entire cluster. These settings are overridden if specified on the specific NodePool object."
  type = object({
    node_config_defaults = optional(object({
      insecure_kubelet_readonly_port_enabled = optional(bool)
      logging_variant                        = optional(string)
      gcfs_config = optional(object({
        enabled = bool
      }))
    }))
  })
  default = null
}

variable "node_version" {
  description = "The Kubernetes version on the nodes. Must either be unset or set to the same value as min_master_version on create. Defaults to the default version set by GKE which is not necessarily the latest version. This only affects nodes in the default node pool. While a fuzzy version can be specified, it's recommended that you specify explicit versions as Terraform will see spurious diffs when fuzzy versions are used. See the google_container_engine_versions data source's version_prefix field to approximate fuzzy versions in a Terraform-compatible way. To update nodes in other node pools, use the version attribute on the node pool."
  type        = string
  default     = null
}


variable "notification_config" {
  description = "Configuration for the [cluster upgrade notifications](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-upgrade-notifications) feature."
  type = object({
    pubsub = object({
      enabled = bool
      topic   = optional(string)
      filter = optional(object({
        event_type = optional(string)
      }))
    })
  })
  default = null
}

variable "confidential_nodes" {
  description = "Configuration for [Confidential Nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/confidential-gke-nodes) feature. "
  type = object({
    enabled = bool
  })
  default = null
}

variable "pod_security_policy_config" {
  description = "Configuration for the [PodSecurityPolicy](https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies) feature."
  type = object({
    enabled = bool
  })
  default = null
}

variable "pod_autoscaling" {
  description = "Enable the Horizontal Pod Autoscaling profile for this cluster.Acceptable values are:'NONE' - Customers explicitly opt-out of HPA profiles, 'PERFORMANCE' - PERFORMANCE is used when customers opt-in to the performance HPA profile. In this profile we support a higher number of HPAs per cluster and faster metrics collection for workload autoscaling. See HPAProfile for more details."
  type = object({
    hpa_profile = string
  })
  default = null
}

variable "vertical_pod_autoscaling" {
  description = "Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "secret_manager_config" {
  description = "Configuration for the SecretManagerConfig feature"
  type = object({
    enabled = bool
  })
  default = null

}

variable "authenticator_groups_config" {
  description = "Configuration for the Google Groups for GKE feature. The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com."
  type = object({
    security_group = string
  })

  default = null
}

variable "control_plane_endpoints_config" {
  description = "Configuration for all of the cluster's control plane endpoints."
  type = object({
    dns_endpoint_config = optional(object({
      allow_external_traffic = optional(bool)
    }))
    ip_endpoints_config = optional(object({
      enabled = optional(bool)
    }))
  })
}

variable "private_cluster_config" {
  description = "Configuration for private clusters, clusters with private nodes."
  type = object({
    enable_private_nodes        = optional(bool)
    enable_private_endpoint     = optional(bool)
    master_ipv4_cidr_block      = optional(string)
    private_endpoint_subnetwork = optional(string)
    master_global_access_config = optional(object({
      enabled = optional(bool)
    }))
  })
  default = {
    enable_private_nodes    = true # CIS GKE Benchmark Recommendations: 6.6.5. Ensure clusters are created with Private Nodes
    enable_private_endpoint = true # CIS GKE Benchmark Recommendations: 6.6.4. Ensure clusters are created with Private Endpoint Enabled and Public Access Disabled.
    master_global_access_config = {
      enabled = true
    }
  }
}

variable "cluster_telemetry" {
  description = "Configuration for ClusterTelemetry feature. Telemetry integration for the cluster. Supported values (ENABLED, DISABLED, SYSTEM_ONLY); SYSTEM_ONLY (Only system components are monitored and logged) is only available in GKE versions 1.15 and later."
  type = object({
    type = string
  })
  default = null
}

variable "release_channel" {
  description = "Configuration for the release channel feature, which provides more control over automatic upgrades of your GKE clusters."
  type = object({
    channel = optional(string)
  })
  default = null
}

variable "remove_default_node_pool" {
  description = "If true, deletes the default node pool upon cluster creation. If you're using google_container_node_pool resources with no default node pool, this should be set to true."
  type        = bool
  default     = true
}

variable "resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster. Note: This field is non-authoritative, and will only manage the labels present in your configuration. Please refer to the field 'effective_labels' for all of the labels present on the resource."
  type        = map(string)
  default     = null
}

variable "cost_management_config" {
  description = "The Cost Management configuration for the cluster."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "resource_usage_export_config" {
  description = "Configuration for the [ResourceUsageExportConfig](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering) feature."
  type = object({
    enable_network_egress_metering       = optional(bool)
    enable_resource_consumption_metering = optional(bool)
    bigquery_destination = object({
      dataset_id = string
    })
  })
  default = null
}

variable "workload_identity_config" {
  description = "Configuration for the use of Kubernetes Service Accounts in GCP IAM policies."
  type = object({
    workload_pool = string
  })
}

variable "identity_service_config" {
  description = "Whether to enable the Identity Service component. It is disabled by default. Set enabled=true to enable."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "enable_intranode_visibility" {
  type        = bool
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC flow logs."
  default     = null
}

variable "enable_l4_ilb_subsetting" {
  type        = bool
  description = "Enables L4 ILB subsetting. L4 ILB subsetting can be used with clusters of all sizes. This feature is in public beta."
  default     = null
}

variable "disable_l4_lb_firewall_reconciliation" {
  type        = bool
  description = "If true, stops GKE from reconciling firewall rules for L4 ILB Services."
  default     = null
}

variable "enable_multi_networking" {
  type        = bool
  description = "Enable multi-networking for this cluster. This feature requires projects to have enabled GKE multi-networking series APIs. This feature is in public beta."
  default     = null
}

variable "in_transit_encryption_config" {
  type        = string
  description = "Defines the config of in-transit encryption. Valid values are `IN_TRANSIT_ENCRYPTION_DISABLED` and `IN_TRANSIT_ENCRYPTION_INTER_NODE_TRANSPARENT`."
  default     = null
}

variable "enable_fqdn_network_policy" {
  type        = bool
  description = "Whether FQDN Network Policy is enabled on this cluster."
  default     = null
}

variable "enable_cilium_clusterwide_network_policy" {
  type        = bool
  description = "Enables Cilium-based GKE Dataplane V2 wide network policy. This feature is in public beta."
  default     = null
}

variable "private_ipv6_google_access" {
  type        = string
  description = "The desired state of IPv6 access to Google Services. By default, no private IPv6 access to or from Google Services (all access will be via IPv4)."
  default     = null
  validation {
    condition = var.private_ipv6_google_access == null || contains([
      "PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED",
      "PRIVATE_IPV6_GOOGLE_ACCESS_DISABLED",
      "PRIVATE_IPV6_GOOGLE_ACCESS_TO_GOOGLE",
      "PRIVATE_IPV6_GOOGLE_ACCESS_BIDIRECTIONAL"
    ], var.private_ipv6_google_access)
    error_message = "Accepted values for private_ipv6_google_access are: PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED, PRIVATE_IPV6_GOOGLE_ACCESS_DISABLED, PRIVATE_IPV6_GOOGLE_ACCESS_TO_GOOGLE, or PRIVATE_IPV6_GOOGLE_ACCESS_BIDIRECTIONAL."
  }
}

variable "datapath_provider" {
  type        = string
  description = "The desired datapath provider for this cluster. This is set to LEGACY_DATAPATH by default, which uses the IPTables-based kube-proxy implementation. Set to ADVANCED_DATAPATH to enable Dataplane v2."
  default     = null
  validation {
    condition = var.datapath_provider == null || contains([
      "DATAPATH_PROVIDER_UNSPECIFIED",
      "LEGACY_DATAPATH",
      "ADVANCED_DATAPATH"
    ], var.datapath_provider)
    error_message = "Accepted values for datapath_provider are: DATAPATH_PROVIDER_UNSPECIFIED, LEGACY_DATAPATH, or ADVANCED_DATAPATH."
  }
}

variable "default_snat_status" {
  description = "[GKE SNAT](https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent#how_ipmasq_works) DefaultSnatStatus contains the desired state of whether default sNAT should be disabled on the cluster, [API doc](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#networkconfig). In-node sNAT rules will be disabled when defaultSnatStatus is disabled.When disabled is set to false, default IP masquerade rules will be applied to the nodes to prevent sNAT on cluster internal traffic"
  type = object({
    disabled = bool
  })
  default = null
}

variable "dns_config" {
  description = "Configuration for Cloud DNS for GKE."
  type = object({
    additive_vpc_scope_dns_domain = optional(string)
    cluster_dns                   = optional(string)
    cluster_dns_scope             = optional(string)
    cluster_dns_domain            = optional(string)
  })
  default = null
}

variable "gateway_api_config" {
  description = "Configuration for the Gateway API, which manages access to Kubernetes services."
  type = object({
    channel = string
  })
  default = null
}

variable "protect_config" {
  description = "Enable GKE Protect workloads for this cluster."
  type = object({
    workload_config = object({
      audit_mode = string
    })
    workload_vulnerability_mode = optional(string)
  })
  default = null
}

variable "security_posture_config" {
  description = "Security posture configuration for the cluster. mode - Sets the mode of the Kubernetes security posture API's off-cluster features. Available options include DISABLED, BASIC, and ENTERPRISE. vulnerability_mode - Sets the mode of the Kubernetes security posture API's workload vulnerability scanning. Available options include VULNERABILITY_DISABLED, VULNERABILITY_BASIC and VULNERABILITY_ENTERPRISE."
  type = object({
    mode               = optional(string)
    vulnerability_mode = optional(string)
  })
  default = null
}

variable "fleet" {
  description = "Fleet configuration for the cluster. The name of the Fleet host project where this cluster will be registered."
  type = object({
    project = optional(string)
  })
  default = null
}

variable "workload_alts_config" {
  description = "Workload ALTS configuration for the cluster. Whether the alts handshaker should be enabled or not for direct-path. Requires Workload Identity (workloadPool) must be non-empty"
  type = object({
    enable_alts = bool
  })
  default = null
}

variable "enterprise_config" {
  description = "Enterprise configuration for the cluster. Sets the tier of the cluster. Available options include STANDARD and ENTERPRISE."
  type = object({
    desired_tier = string
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
