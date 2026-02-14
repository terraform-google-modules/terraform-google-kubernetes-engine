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
  description = "The name of the cluster (required)"
  type        = string
}

variable "description" {
  description = "Description of the cluster."
  type        = string
  default     = ""
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
  description = "Whether Terraform will be prevented from destroying the cluster. Deleting this cluster via terraform destroy or terraform apply will only succeed if this field is false in the Terraform state."
  type        = bool
  default     = false
}

variable "addons_config" {
  description = "The configuration for addons supported by GKE Autopilot."
  type = object({
    gcp_filestore_csi_driver_config = optional(object({
      enabled = optional(bool)
    }))
    gke_backup_agent_config = optional(object({
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
  description = "Per-cluster configuration of Node Auto-Provisioning with Cluster Autoscaler to automatically adjust the size of the cluster."
  type = object({
    auto_provisioning_defaults = optional(object({
      service_account   = optional(string)
      boot_disk_kms_key = optional(string)
    }))
  })
  default = null
}

variable "binary_authorization" {
  description = "Configuration options for the Binary Authorization feature. Can be `PROJECT_SINGLETON_POLICY_ENFORCE` or `DISABLED`"
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
  default = {
    enabled = false
  }
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

variable "enable_k8s_beta_apis" {
  description = "Configuration for Kubernetes Beta APIs."
  type = object({
    enabled_apis = list(string)
  })
  default = null
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
  description = "The GKE components exposing logs. Supported values include: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, SCHEDULER, and WORKLOADS."
  type = object({
    enable_components = optional(list(string))
  })
  default = null
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
  default = {
    daily_maintenance_window = {
      start_time = "05:00"
    }
  }
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
  description = "(Optional) The GKE components exposing metrics. Supported values include: SYSTEM_COMPONENTS, APISERVER, SCHEDULER, CONTROLLER_MANAGER, STORAGE, HPA, POD, DAEMONSET, DEPLOYMENT, STATEFULSET, KUBELET, CADVISOR, DCGM and JOBSET. "
  type = object({
    enable_components = optional(list(string))
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
  default = {
    enabled = true
  }
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
    enable_private_endpoint = true # CIS GKE Benchmark Recommendations: 6.6.4. Ensure clusters are created with Private Endpoint Enabled and Public Access Disabled
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
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  type = object({
    channel = optional(string)
  })
  default = {
    channel = "REGULAR"
  }
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

variable "enable_l4_ilb_subsetting" {
  description = "Enables L4 ILB subsetting. L4 ILB subsetting can be used with clusters of all sizes. This feature is in public beta."
  type        = bool
  default     = null
}

variable "disable_l4_lb_firewall_reconciliation" {
  description = "If true, stops GKE from reconciling firewall rules for L4 ILB Services."
  type        = bool
  default     = null
}

variable "enable_multi_networking" {
  description = "Enable multi-networking for this cluster. This feature requires projects to have enabled GKE multi-networking series APIs. This feature is in public beta."
  type        = bool
  default     = null
}

variable "in_transit_encryption_config" {
  description = "Defines the config of in-transit encryption. Valid values are `IN_TRANSIT_ENCRYPTION_DISABLED` and `IN_TRANSIT_ENCRYPTION_INTER_NODE_TRANSPARENT`."
  type        = string
  default     = null
}

variable "enable_fqdn_network_policy" {
  description = "Whether FQDN Network Policy is enabled on this cluster."
  type        = bool
  default     = null
}

variable "enable_cilium_clusterwide_network_policy" {
  description = "Enables Cilium-based GKE Dataplane V2 wide network policy. This feature is in public beta."
  type        = bool
  default     = null
}

variable "private_ipv6_google_access" {
  description = "The desired state of IPv6 access to Google Services. By default, no private IPv6 access to or from Google Services (all access will be via IPv4)."
  type        = string
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
  description = "The desired datapath provider for this cluster. This is set to LEGACY_DATAPATH by default, which uses the IPTables-based kube-proxy implementation. Set to ADVANCED_DATAPATH to enable Dataplane v2."
  type        = string
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
  description = "Enable/Disable Protect API features for the cluster."
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

variable "allow_net_admin" {
  description = "(Optional) Enable NET_ADMIN for the cluster."
  type        = bool
  default     = false
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
