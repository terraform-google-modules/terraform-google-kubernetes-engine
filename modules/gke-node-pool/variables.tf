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
  description = "The cluster to create the node pool for. Cluster must be present in location provided for clusters. May be specified in the format projects/{{project_id}}/locations/{{location}}/clusters/{{cluster}} or as just the name of the cluster."
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
  description = <<EOT
  Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage.
  - min_node_count: Minimum number of nodes per zone in the NodePool. Must be >=0 and <= max_node_count. Cannot be used with total limits.
  - max_node_count: Maximum number of nodes per zone in the NodePool. Must be >= min_node_count. Cannot be used with total limits.
  - total_min_node_count: Total minimum number of nodes in the NodePool. Must be >=0 and <= total_max_node_count. Cannot be used with per zone limits. Total size limits are supported only in 1.24.1+ clusters.
  - total_max_node_count: Total maximum number of nodes in the NodePool. Must be >= total_min_node_count. Cannot be used with per zone limits. Total size limits are supported only in 1.24.1+ clusters.
  - location_policy: Location policy specifies the algorithm used when scaling-up the node pool. Location policy is supported only in 1.24.1+ clusters.
      - "BALANCED" - Is a best effort policy that aims to balance the sizes of available zones.
      - "ANY" - Instructs the cluster autoscaler to prioritize utilization of unused reservations, and reduce preemption risk for Spot VMs.
EOT
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
  description = "The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource. WARNING: Resizing your node pool manually may change this value in your existing cluster, which will trigger destruction and recreation on the next Terraform run (to rectify the discrepancy). If you don't need this value, don't set it."
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
  description = <<EOT
  Parameters used in creating the node pool.
  - confidential_nodes - (Optional) Configuration for Confidential Nodes feature.
    - enabled (Required) - Enable Confidential GKE Nodes for this node pool, to enforce encryption of data in-use.
  - disk_size_gb - (Optional) Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100GB.
  - disk_type - (Optional) Type of the disk attached to each node (e.g. 'pd-standard', 'pd-balanced' or 'pd-ssd'). If unspecified, the default disk type is 'pd-balanced'
  - enable_confidential_storage - (Optional) Enabling Confidential Storage will create boot disk with confidential mode. It is disabled by default.
  - local_ssd_encryption_mode - (Optional) Possible Local SSD encryption modes: Accepted values are:
    - STANDARD_ENCRYPTION: The given node will be encrypted using keys managed by Google infrastructure and the keys wll be deleted when the node is deleted.
    - EPHEMERAL_KEY_ENCRYPTION: The given node will opt-in for using ephemeral key for encrypting Local SSDs. The Local SSDs will not be able to recover data in case of node crash.
  - ephemeral_storage_config - (Optional, Beta) Parameters for the ephemeral storage filesystem. If unspecified, ephemeral storage is backed by the boot disk.
    - local_ssd_count
  - ephemeral_storage_local_ssd_config - (Optional) Parameters for the ephemeral storage filesystem. If unspecified, ephemeral storage is backed by the boot disk.
    - local_ssd_count
    - data_cache_count
  - fast_socket - (Optional) Parameters for the NCCL Fast Socket feature. If unspecified, NCCL Fast Socket will not be enabled on the node pool. Node Pool must enable gvnic. GKE version 1.25.2-gke.1700 or later.
    - enabled - Whether or not the NCCL Fast Socket is enabled
  - local_nvme_ssd_block_config - (Optional) Parameters for the local NVMe SSDs.
    - local_ssd_count (Required) - Number of raw-block local NVMe SSD disks to be attached to the node. Each local SSD is 375 GB in size. If zero, it means no raw-block local NVMe SSD disks to be attached to the node. -> Note: Local NVMe SSD storage available in GKE versions v1.25.3-gke.1800 and later.
  - logging_variant (Optional) Parameter for specifying the type of logging agent used in a node pool. This will override any cluster-wide default value. Valid values include DEFAULT and MAX_THROUGHPUT. See [Increasing logging agent throughput](https://cloud.google.com/stackdriver/docs/solutions/gke/managing-logs#throughput) for more information.
  - secondary_boot_disks - (Optional) Parameters for secondary boot disks to preload container images and data on new nodes. gcfs_config must be enabled=true for this feature to work. min_master_version must also be set to use GKE 1.28.3-gke.106700 or later versions.
    - disk_image (Required) - Path to disk image to create the secondary boot disk from. After using the gke-disk-image-builder, this argument should be global/images/DISK_IMAGE_NAME.
    - mode (Optional) - Mode for how the secondary boot disk is used. An example mode is CONTAINER_IMAGE_CACHE.
  - gcfs_config - (Optional) Parameters for the Google Container Filesystem (GCFS). If unspecified, GCFS will not be enabled on the node pool. When enabling this feature you must specify image_type = "COS_CONTAINERD" and node_version from GKE versions 1.19 or later to use it. For GKE versions 1.19, 1.20, and 1.21, the recommended minimum node_version would be 1.19.15-gke.1300, 1.20.11-gke.1300, and 1.21.5-gke.1300 respectively. A machine_type that has more than 16 GiB of memory is also recommended. GCFS must be enabled in order to use image streaming.
    - enabled (Required) - Whether or not the Google Container Filesystem (GCFS) is enabled.
  - gvnic - (Optional) Google Virtual NIC (gVNIC) is a virtual network interface. Installing the gVNIC driver allows for more efficient traffic transmission across the Google network infrastructure. gVNIC is an alternative to the virtIO-based ethernet driver. GKE nodes must use a Container-Optimized OS node image. GKE node version 1.15.11-gke.15 or later.
    - enabled (Required) - Whether or not the Google Virtual NIC (gVNIC) is enabled
  - guest_accelerator - (Optional) List of the type and count of accelerator cards attached to the instance. Note: As of 6.0.0, argument syntax is no longer supported for this field in favor of block syntax. To dynamically set a list of guest accelerators, use dynamic blocks. To set an empty list, use a single guest_accelerator block with count = 0.
    - type (Required) - The accelerator type resource to expose to this instance. E.g. nvidia-tesla-k80.
    - count (Required) - The number of the guest accelerator cards exposed to this instance.
    - gpu_driver_installation_config (Optional) - Configuration for auto installation of GPU driver.
      - gpu_driver_version (Required) - Mode for how the GPU driver is installed. Accepted values are:
        - "GPU_DRIVER_VERSION_UNSPECIFIED": Default value is to install the "Default" GPU driver. Before GKE 1.30.1-gke.1156000, the default value is to not install any GPU driver.
        - "INSTALLATION_DISABLED": Disable GPU driver auto installation and needs manual installation.
        - "DEFAULT": "Default" GPU driver in COS and Ubuntu.
        - "LATEST": "Latest" GPU driver in COS.
    - gpu_partition_size (Optional) - Size of partitions to create on the GPU. Valid values are described in the NVIDIA mig user guide.
    - gpu_sharing_config (Optional) - Configuration for GPU sharing.
      - gpu_sharing_strategy (Required) - The type of GPU sharing strategy to enable on the GPU node. Accepted values are:
        - "TIME_SHARING": Allow multiple containers to have time-shared access to a single GPU device.
        - "MPS": Enable co-operative multi-process CUDA workloads to run concurrently on a single GPU device with MPS
      - max_shared_clients_per_gpu (Required) - The maximum number of containers that can share a GPU.
  - image_type - (Optional) The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool.
  - labels - (Optional) The Kubernetes labels (key/value pairs) to be applied to each node. The kubernetes.io/ and k8s.io/ prefixes are reserved by Kubernetes Core components and cannot be specified.
  - resource_labels - (Optional) The GCP labels (key/value pairs) to be applied to each node. Refer here for how these labels are applied to clusters, node pools and nodes.
  - max_run_duration - (Optional) The runtime of each node in the node pool in seconds, terminated by 's'. Example: "3600s".
  - flex_start - (Optional) Enables Flex Start provisioning model for the node pool.
  - local_ssd_count - (Optional) The amount of local SSD disks that will be attached to each cluster node. Defaults to 0.
  - machine_type - (Optional) The name of a Google Compute Engine machine type. Defaults to e2-medium. To create a custom machine type, value should be set as specified here.
  - metadata - (Optional) The metadata key/value pairs assigned to instances in the cluster. From GKE 1.12 onwards, disable-legacy-endpoints is set to true by the API; if metadata is set but that default value is not included, Terraform will attempt to unset the value. To avoid this, set the value in your config.
  - min_cpu_platform - (Optional) Minimum CPU platform to be used by this instance. The instance may be scheduled on the specified or newer CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell. See the official documentation for more information.
  - oauth_scopes - (Optional) The set of Google API scopes to be made available on all of the node VMs under the "default" service account. Use the "https://www.googleapis.com/auth/cloud-platform" scope to grant access to all APIs. It is recommended that you set service_account to a non-default service account and grant IAM roles to that service account for only the resources that it needs.See the [official documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/access-scopes) for information on migrating off of legacy access scopes.
  - preemptible - (Optional) A boolean that represents whether or not the underlying node VMs are preemptible. See the official documentation for more information. Defaults to false.
  - reservation_affinity (Optional) The configuration of the desired reservation which instances could take capacity from.
    - consume_reservation_type (Required) The type of reservation consumption Accepted values are:
      - "UNSPECIFIED": Default value. This should not be used.
      - "NO_RESERVATION": Do not consume from any reserved capacity.
      - "ANY_RESERVATION": Consume any reservation available.
      - "SPECIFIC_RESERVATION": Must consume from a specific reservation. Must specify key value fields for specifying the reservations.
    - key (Optional) The label key of a reservation resource. To target a SPECIFIC_RESERVATION by name, specify "compute.googleapis.com/reservation-name" as the key and specify the name of your reservation as its value.
    - values (Optional) The list of label values of reservation resources. For example: the name of the specific reservation when using a key of "compute.googleapis.com/reservation-name"
  - spot - (Optional) A boolean that represents whether the underlying node VMs are spot. See the official documentation for more information. Defaults to false.
  - sandbox_config - (Optional, Beta) GKE Sandbox configuration. When enabling this feature you must specify image_type = "COS_CONTAINERD" and node_version = "1.12.7-gke.17" or later to use it.
    - sandbox_type (Required) Which sandbox to use for pods in the node pool. Accepted values are:
      - "gvisor": Pods run within a gVisor sandbox.
  - boot_disk_kms_key - (Optional) The Customer Managed Encryption Key used to encrypt the boot disk attached to each node in the node pool. This should be of the form projects/[KEY_PROJECT_ID]/locations/[LOCATION]/keyRings/[RING_NAME]/cryptoKeys/[KEY_NAME]. For more information about protecting resources with Cloud KMS Keys please see: https://cloud.google.com/compute/docs/disks/customer-managed-encryption.
  - service_account - (Optional) The service account to be used by the Node VMs. If not specified, the "default" service account is used.
  - shielded_instance_config - (Optional) Shielded Instance options.
    - enable_secure_boot (Optional) - Defines if the instance has Secure Boot enabled. Secure Boot helps ensure that the system only runs authentic software by verifying the digital signature of all boot components, and halting the boot process if signature verification fails. Defaults to false.
    - enable_integrity_monitoring (Optional) - Defines if the instance has integrity monitoring enabled.
  - storage_pools - (Optional) The list of Storage Pools where boot disks are provisioned.
  - tags - (Optional) The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls.
  - resource_manager_tags - (Optional) A map of resource manager tag keys and values to be attached to the nodes for managing Compute Engine firewalls using Network Firewall Policies. Tags must be according to specifications found here. A maximum of 5 tag key-value pairs can be specified. Existing tags will be replaced with new values. Tags must be in one of the following formats ([KEY]=[VALUE]) 1. tagKeys/{tag_key_id}=tagValues/{tag_value_id} 2. {org_id}/{tag_key_name}={tag_value_name} 3. {project_id}/{tag_key_name}={tag_value_name}.
  - taint - (Optional) A list of Kubernetes taints to apply to nodes. This field will only report drift on taint keys that are already managed with Terraform, use effective_taints to view the list of GKE-managed taints on the node pool from all sources. Importing this resource will not record any taints as being Terraform-managed, and will cause drift with any configured taints.
    - key (Required) Key for taint.
    - value (Required) Value for taint.
    - effect (Required) Effect for taint. Accepted values are NO_SCHEDULE, PREFER_NO_SCHEDULE, and NO_EXECUTE.
  - workload_metadata_config - (Optional) Metadata configuration to expose to workloads on the node pool.
    - mode (Required) How to expose the node metadata to the workload running on the node. Accepted values are:
      - MODE_UNSPECIFIED: Not Set
      - GCE_METADATA: Expose all Compute Engine metadata to pods.
      - GKE_METADATA: Run the GKE Metadata Server on this node. The GKE Metadata Server exposes a metadata API to workloads that is compatible with the V1 Compute Metadata APIs exposed by the Compute Engine and App Engine Metadata Servers. This feature can only be enabled if workload identity is enabled at the cluster level.
  - kubelet_config - (Optional) Kubelet configuration, currently supported attributes can be found [here](https://cloud.google.com/sdk/gcloud/reference/beta/container/node-pools/create#--system-config-from-file).
    - cpu_manager_policy - The CPU management policy on the node. See K8S CPU Management Policies. One of "none" or "static". If unset (or set to the empty string ""), the API will treat the field as if set to "none". Prior to the 6.4.0 this field was marked as required. The workaround for the required field is setting the empty string "", which will function identically to not setting this field.
    - cpu_cfs_quota - If true, enables CPU CFS quota enforcement for containers that specify CPU limits.
    - cpu_cfs_quota_period - The CPU CFS quota period value. Specified as a sequence of decimal numbers, each with optional fraction and a unit suffix, such as "300ms". Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h". The value must be a positive duration.
    - insecure_kubelet_readonly_port_enabled - Controls whether the kubelet read-only port is enabled. It is strongly recommended to set this to FALSE. Possible values: TRUE, FALSE.
    - pod_pids_limit - Controls the maximum number of processes allowed to run in a pod. The value must be greater than or equal to 1024 and less than 4194304.
    - container_log_max_size - Defines the maximum size of the container log file before it is rotated. Specified as a positive number and a unit suffix, such as "100Ki", "10Mi". Valid units are "Ki", "Mi", "Gi". The value must be between "10Mi" and "500Mi", inclusive. And the total container log size (container_log_max_size * container_log_max_files) cannot exceed 1% of the total storage of the node.
    - container_log_max_files - Defines the maximum number of container log files that can be present for a container. The integer must be between 2 and 10, inclusive.
    - image_gc_low_threshold_percent -  Defines the percent of disk usage before which image garbage collection is never run. Lowest disk usage to garbage collect to. The integer must be between 10 and 85, inclusive.
    - image_gc_high_threshold_percent - Defines the percent of disk usage after which image garbage collection is always run. The integer must be between 10 and 85, inclusive.
    - image_minimum_gc_age - Defines the minimum age for an unused image before it is garbage collected. Specified as a sequence of decimal numbers, each with optional fraction and a unit suffix, such as "300s", "1.5m". The value cannot be greater than "2m".
    - allowed_unsafe_sysctls - Defines a comma-separated allowlist of unsafe sysctls or sysctl patterns which can be set on the Pods. The allowed sysctl groups are kernel.shm*, kernel.msg*, kernel.sem, fs.mqueue.*, and net.*.
  - linux_node_config - (Optional) Parameters that can be configured on Linux nodes.
    - sysctls - (Optional) The Linux kernel parameters to be applied to the nodes and all pods running on the nodes. Specified as a map from the key, such as net.core.wmem_max, to a string value. Currently supported attributes can be found [here](https://cloud.google.com/sdk/gcloud/reference/beta/container/node-pools/create#--system-config-from-file). Note that validations happen all server side. All attributes are optional.
    - cgroup_mode - (Optional) Possible cgroup modes that can be used. Accepted values are:
      - CGROUP_MODE_UNSPECIFIED: CGROUP_MODE_UNSPECIFIED is when unspecified cgroup configuration is used. The default for the GKE node OS image will be used.
      - CGROUP_MODE_V1: CGROUP_MODE_V1 specifies to use cgroupv1 for the cgroup configuration on the node image.
      - CGROUP_MODE_V2: CGROUP_MODE_V2 specifies to use cgroupv2 for the cgroup configuration on the node image.
    - hugepages_config - (Optional) Amounts for 2M and 1G hugepages.
      - hugepage_size_2m - (Optional) Amount of 2M hugepages.
      - hugepage_size_1g - (Optional) Amount of 1G hugepages.
  - windows_node_config - (Optional) Windows node configuration, currently supporting OSVersion attribute. The value must be one of [OS_VERSION_UNSPECIFIED, OS_VERSION_LTSC2019, OS_VERSION_LTSC2022].
  - containerd_config - (Optional) Parameters to customize containerd runtime.
    - private_registry_access_config (Optional) - Configuration for private container registries. There are two fields in this config:
      - enabled (Required) - Enables private registry config. If set to false, all other fields in this object must not be set.
      - certificate_authority_domain_config (Optional) - List of configuration objects for CA and domains. Each object identifies a certificate and its assigned domains. See [how to configure for private container registries](https://cloud.google.com/kubernetes-engine/docs/how-to/access-private-registries-private-certificates) for more detail.
        - fqdns - List of Fully Qualified Domain Names.
        - gcp_secret_manager_certificate_config
          - secret_uri - URI for the Google Cloud Secret that stores the certificate. Format is 'projects/PROJECT_NUMBER/secrets/SECRET_NAME/versions/VERSION'.
  - node_group - (Optional) Setting this field will assign instances of this pool to run on the specified node group. This is useful for running workloads on sole tenant nodes.
  - sole_tenant_config (Optional) Allows specifying multiple node affinities useful for running workloads on sole tenant nodes.
    - node_affinity
      - key (Required) - The default or custom node affinity label key name.
      - operator (Required) - Specifies affinity or anti-affinity. Accepted values are "IN" or "NOT_IN"
      - values (Required) - List of node affinity label values as strings.
  EOT
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
  description = <<EOT
  The network configuration of the pool. Such as configuration for Adding Pod IP address ranges to the node pool. Or enabling private nodes.
    - create_pod_range: Whether to create a new range for pod IPs in this node pool. Defaults are provided for pod_range and pod_ipv4_cidr_block if they are not specified.
    - enable_private_nodes: Whether nodes have internal IP addresses only.
    - pod_ipv4_cidr_block: The IP address range for pod IPs in this node pool. Only applicable if createPodRange is true. Set to blank to have a range chosen with the default size. Set to /netmask (e.g. /14) to have a range chosen with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) to pick a specific range to use.
    - pod_range - The ID of the secondary range for pod IPs. If create_pod_range is true, this ID is used for the new range. If create_pod_range is false, uses an existing secondary range with this ID.
    - additional_node_network_configs - We specify the additional node networks for this node pool using this list. Each node network corresponds to an additional interface.
      - network - Name of the VPC where the additional interface belongs.
      - subnetwork - Name of the subnetwork where the additional interface belongs
    - additional_pod_network_configs - We specify the additional pod networks for this node pool using this list. Each pod network corresponds to an additional alias IP range for the node.
      - subnetwork - Name of the subnetwork where the additional pod network belongs.
      - secondary_pod_range - The name of the secondary range on the subnet which provides IP address for this pod range.
      - max_pods_per_node - The maximum number of pods per node which use this pod network.
    - pod_cidr_overprovision_config  - Configuration for node-pool level pod cidr overprovision. If not set, the cluster level setting will be inherited.
      - disabled - Whether pod cidr overprovision is disabled.
    - network_performance_config - Network bandwidth tier configuration.
      - total_egress_bandwidth_tier - Specifies the total network bandwidth tier for the NodePool. Valid values include: "TIER_1" and "TIER_UNSPECIFIED".
EOT
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
  description = <<EOT
  Specify node upgrade settings to change how GKE upgrades nodes. The maximum number of nodes upgraded simultaneously is limited to 20.
  - max_surge:he number of additional nodes that can be added to the node pool during an upgrade. Increasing max_surge raises the number of nodes that can be upgraded simultaneously. Can be set to 0 or greater.
  - max_unavailable - (Optional) The number of nodes that can be simultaneously unavailable during an upgrade. Increasing max_unavailable raises the number of nodes that can be upgraded in parallel. Can be set to 0 or greater.
  - strategy - (Default SURGE) The upgrade strategy to be used for upgrading the nodes.
  - blue_green_settings: The settings to adjust blue green upgrades.
    - standard_rollout_policy: Specifies the standard policy settings for blue-green upgrades.
      - batch_percentage: Percentage of the blue pool nodes to drain in a batch.
      - batch_node_count:Number of blue nodes to drain in a batch.
      - batch_soak_duration: Soak time after each batch gets drained.
    - local_ssd_encryption_mode: Possible Local SSD encryption modes: Accepted values are:
      - STANDARD_ENCRYPTION: The given node will be encrypted using keys managed by Google infrastructure and the keys wll be deleted when the node is deleted.
      - EPHEMERAL_KEY_ENCRYPTION: The given node will opt-in for using ephemeral key for encrypting Local SSDs. The Local SSDs will not be able to recover data in case of node crash.
    - node_pool_soak_duration: Time needed after draining the entire blue pool. After this period, the blue pool will be cleaned up.
EOT
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
