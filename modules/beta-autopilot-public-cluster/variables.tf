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

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "description" {
  type        = string
  description = "The description of the cluster"
  default     = ""
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = null
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}

variable "network_project_id" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = ""
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "gcp_public_cidrs_access_enabled" {
  type        = bool
  description = "Allow access through Google Cloud public IP addresses"
  default     = null
}

variable "enable_vertical_pod_autoscaling" {
  type        = bool
  description = "Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it"
  default     = true
}

variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "http_load_balancing" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = true
}

variable "service_external_ips" {
  type        = bool
  description = "Whether external ips specified by a service will be allowed in this cluster"
  default     = false
}

variable "insecure_kubelet_readonly_port_enabled" {
  type        = bool
  description = "Whether or not to set `insecure_kubelet_readonly_port_enabled` for node pool defaults and autopilot clusters."
  default     = null
}

variable "maintenance_start_time" {
  type        = string
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  default     = "05:00"
}

variable "maintenance_exclusions" {
  type        = list(object({ name = string, start_time = string, end_time = string, exclusion_scope = string }))
  description = "List of maintenance exclusions. A cluster can have up to three"
  default     = []
}

variable "maintenance_end_time" {
  type        = string
  description = "Time window specified for recurring maintenance operations in RFC3339 format"
  default     = ""
}

variable "maintenance_recurrence" {
  type        = string
  description = "Frequency of the recurring maintenance window in RFC5545 format."
  default     = ""
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "additional_ip_range_pods" {
  type        = list(string)
  description = "List of _names_ of the additional secondary subnet ip ranges to use for pods"
  default     = []
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "stack_type" {
  type        = string
  description = "The stack type to use for this cluster. Either `IPV4` or `IPV4_IPV6`. Defaults to `IPV4`."
  default     = "IPV4"
}


variable "enable_cost_allocation" {
  type        = bool
  description = "Enables Cost Allocation Feature and the cluster name and namespace of your GKE workloads appear in the labels field of the billing export to BigQuery"
  default     = false
}
variable "resource_usage_export_dataset_id" {
  type        = string
  description = "The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export."
  default     = ""
}

variable "enable_network_egress_export" {
  type        = bool
  description = "Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic."
  default     = false
}

variable "enable_resource_consumption_export" {
  type        = bool
  description = "Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export."
  default     = true
}


variable "network_tags" {
  description = "(Optional) - List of network tags applied to auto-provisioned node pools."
  type        = list(string)
  default     = []
}


variable "non_masquerade_cidrs" {
  type        = list(string)
  description = "List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading."
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "ip_masq_resync_interval" {
  type        = string
  description = "The interval at which the agent attempts to sync its ConfigMap file from the disk."
  default     = "60s"
}

variable "ip_masq_link_local" {
  type        = bool
  description = "Whether to masquerade traffic to the link-local prefix (169.254.0.0/16)."
  default     = false
}

variable "configure_ip_masq" {
  type        = bool
  description = "Enables the installation of ip masquerading, which is usually no longer required when using aliasied IP addresses. IP masquerading uses a kubectl call, so when you have a private cluster, you will need access to the API server."
  default     = false
}

variable "create_service_account" {
  type        = bool
  description = "Defines if service account specified to run nodes should be created."
  default     = true
}

variable "grant_registry_access" {
  type        = bool
  description = "Grants created cluster-specific service account storage.objectViewer and artifactregistry.reader roles."
  default     = false
}

variable "registry_project_ids" {
  type        = list(string)
  description = "Projects holding Google Container Registries. If empty, we use the cluster project. If a service account is created and the `grant_registry_access` variable is set to `true`, the `storage.objectViewer` and `artifactregsitry.reader` roles are assigned on these projects."
  default     = []
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created. This service account should already exists and it will be used by the node pools. If you wish to only override the service account name, you can use service_account_name variable."
  default     = ""
}

variable "service_account_name" {
  type        = string
  description = "The name of the service account that will be created if create_service_account is true. If you wish to use an existing service account, use service_account variable."
  default     = ""
}

variable "boot_disk_kms_key" {
  type        = string
  description = "The Customer Managed Encryption Key used to encrypt the boot disk attached to each node in the node pool, if not overridden in `node_pools`. This should be of the form projects/[KEY_PROJECT_ID]/locations/[LOCATION]/keyRings/[RING_NAME]/cryptoKeys/[KEY_NAME]. For more information about protecting resources with Cloud KMS Keys please see: https://cloud.google.com/compute/docs/disks/customer-managed-encryption"
  default     = null
}

variable "issue_client_certificate" {
  type        = bool
  description = "Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive!"
  default     = false
}

variable "cluster_ipv4_cidr" {
  type        = string
  default     = null
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}


variable "dns_cache" {
  type        = bool
  description = "The status of the NodeLocal DNSCache addon."
  default     = true
}

variable "authenticator_security_group" {
  type        = string
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
  default     = null
}

variable "identity_namespace" {
  description = "The workload pool to attach all Kubernetes service accounts to. (Default value of `enabled` automatically sets project-based pool `[project_id].svc.id.goog`)"
  type        = string
  default     = "enabled"
}


variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  default     = "REGULAR"
}

variable "gateway_api_channel" {
  type        = string
  description = "The gateway api channel of this cluster. Accepted values are `CHANNEL_STANDARD` and `CHANNEL_DISABLED`."
  default     = null
}

variable "add_cluster_firewall_rules" {
  type        = bool
  description = "Create additional firewall rules"
  default     = false
}

variable "add_master_webhook_firewall_rules" {
  type        = bool
  description = "Create master_webhook firewall rules for ports defined in `firewall_inbound_ports`"
  default     = false
}

variable "firewall_priority" {
  type        = number
  description = "Priority rule for firewall rules"
  default     = 1000
}

variable "firewall_inbound_ports" {
  type        = list(string)
  description = "List of TCP ports for admission/webhook controllers. Either flag `add_master_webhook_firewall_rules` or `add_cluster_firewall_rules` (also adds egress rules) must be set to `true` for inbound-ports firewall rules to be applied."
  default     = ["8443", "9443", "15017"]
}

variable "add_shadow_firewall_rules" {
  type        = bool
  description = "Create GKE shadow firewall (the same as default firewall rules with firewall logs enabled)."
  default     = false
}

variable "shadow_firewall_rules_priority" {
  type        = number
  description = "The firewall priority of GKE shadow firewall rules. The priority should be less than default firewall, which is 1000."
  default     = 999
  validation {
    condition     = var.shadow_firewall_rules_priority < 1000
    error_message = "The shadow firewall rule priority must be lower than auto-created one(1000)."
  }
}

variable "shadow_firewall_rules_log_config" {
  type = object({
    metadata = string
  })
  description = "The log_config for shadow firewall rules. You can set this variable to `null` to disable logging."
  default = {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

variable "enable_confidential_nodes" {
  type        = bool
  description = "An optional flag to enable confidential node config."
  default     = false
}

variable "enable_secret_manager_addon" {
  description = "Enable the Secret Manager add-on for this cluster"
  type        = bool
  default     = false
}

variable "workload_vulnerability_mode" {
  description = "(beta) Sets which mode to use for Protect workload vulnerability scanning feature. Accepted values are DISABLED, BASIC."
  type        = string
  default     = ""
}

variable "workload_config_audit_mode" {
  description = "(beta) Sets which mode of auditing should be used for the cluster's workloads. Accepted values are DISABLED, BASIC."
  type        = string
  default     = "DISABLED"
}

variable "enable_fqdn_network_policy" {
  type        = bool
  description = "Enable FQDN Network Policies on the cluster"
  default     = null
}

variable "enable_cilium_clusterwide_network_policy" {
  type        = bool
  description = "Enable Cilium Cluster Wide Network Policies on the cluster"
  default     = false
}

variable "security_posture_mode" {
  description = "Security posture mode. Accepted values are `DISABLED` and `BASIC`. Defaults to `DISABLED`."
  type        = string
  default     = "DISABLED"
}

variable "security_posture_vulnerability_mode" {
  description = "Security posture vulnerability mode. Accepted values are `VULNERABILITY_DISABLED`, `VULNERABILITY_BASIC`, and `VULNERABILITY_ENTERPRISE`. Defaults to `VULNERABILITY_DISABLED`."
  type        = string
  default     = "VULNERABILITY_DISABLED"
}

variable "disable_default_snat" {
  type        = bool
  description = "Whether to disable the default SNAT to support the private use of public IP addresses"
  default     = false
}

variable "notification_config_topic" {
  type        = string
  description = "The desired Pub/Sub topic to which notifications will be sent by GKE. Format is projects/{project}/topics/{topic}."
  default     = ""
}

variable "notification_filter_event_type" {
  type        = list(string)
  description = "Choose what type of notifications you want to receive. If no filters are applied, you'll receive all notification types. Can be used to filter what notifications are sent. Accepted values are UPGRADE_AVAILABLE_EVENT, UPGRADE_EVENT, and SECURITY_BULLETIN_EVENT."
  default     = []
}

variable "deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the cluster."
  default     = true
}

variable "enable_tpu" {
  type        = bool
  description = "Enable Cloud TPU resources in the cluster. WARNING: changing this after cluster creation is destructive!"
  default     = false
}

variable "filestore_csi_driver" {
  type        = bool
  description = "The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes"
  default     = false
}

variable "database_encryption" {
  description = "Application-layer Secrets Encryption settings. The object format is {state = string, key_name = string}. Valid values of state are: \"ENCRYPTED\"; \"DECRYPTED\". key_name is the name of a CloudKMS key."
  type        = list(object({ state = string, key_name = string }))

  default = [{
    state    = "DECRYPTED"
    key_name = ""
  }]
}

variable "enable_binary_authorization" {
  type        = bool
  description = "Enable BinAuthZ Admission controller"
  default     = false
}


variable "gke_backup_agent_config" {
  type        = bool
  description = "Whether Backup for GKE agent is enabled for this cluster."
  default     = false
}

variable "stateful_ha" {
  type        = bool
  description = "Whether the Stateful HA Addon is enabled for this cluster."
  default     = false
}

variable "ray_operator_config" {
  type = object({
    enabled            = bool
    logging_enabled    = optional(bool, false)
    monitoring_enabled = optional(bool, false)
  })
  description = "The Ray Operator Addon configuration for this cluster."
  default = {
    enabled            = false
    logging_enabled    = false
    monitoring_enabled = false
  }
}

variable "timeouts" {
  type        = map(string)
  description = "Timeout for cluster operations."
  default     = {}
  validation {
    condition     = !contains([for t in keys(var.timeouts) : contains(["create", "update", "delete"], t)], false)
    error_message = "Only create, update, delete timeouts can be specified."
  }
}

variable "monitoring_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, APISERVER, SCHEDULER, CONTROLLER_MANAGER, STORAGE, HPA, POD, DAEMONSET, DEPLOYMENT, STATEFULSET, KUBELET, CADVISOR and DCGM. In beta provider, WORKLOADS is supported on top of those 12 values. (WORKLOADS is deprecated and removed in GKE 1.24.) KUBELET and CADVISOR are only supported in GKE 1.29.3-gke.1093000 and above. Empty list is default GKE configuration."
  default     = []
  validation {
    condition = alltrue([
      for c in var.monitoring_enabled_components :
      contains([
        "SYSTEM_COMPONENTS",
        "APISERVER",
        "SCHEDULER",
        "CONTROLLER_MANAGER",
        "STORAGE",
        "HPA",
        "POD",
        "DAEMONSET",
        "DEPLOYMENT",
        "STATEFULSET",
        "WORKLOADS",
        "KUBELET",
        "CADVISOR",
        "DCGM"
      ], c)
    ])
    error_message = "Valid values are SYSTEM_COMPONENTS, APISERVER, SCHEDULER, CONTROLLER_MANAGER, STORAGE, HPA, POD, DAEMONSET, DEPLOYMENT, STATEFULSET, WORKLOADS, KUBELET, CADVISOR and DCGM."
  }
}

variable "logging_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, KCP_CONNECTION, KCP_SSHD, SCHEDULER, and WORKLOADS. Empty list is default GKE configuration."
  default     = []
  validation {
    condition = alltrue([
      for c in var.logging_enabled_components :
      contains([
        "SYSTEM_COMPONENTS",
        "APISERVER",
        "CONTROLLER_MANAGER",
        "SCHEDULER",
        "KCP_CONNECTION",
        "KCP_SSHD",
        "WORKLOADS"
      ], c)
    ])
    error_message = "Valid values are SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, SCHEDULER, KCP_CONNECTION, KCP_SSHD and WORKLOADS."
  }
}

variable "enable_l4_ilb_subsetting" {
  type        = bool
  description = "Enable L4 ILB Subsetting on the cluster"
  default     = false
}

variable "allow_net_admin" {
  description = "(Optional) Enable NET_ADMIN for the cluster."
  type        = bool
  default     = null
}

variable "fleet_project" {
  description = "(Optional) Register the cluster with the fleet in this project."
  type        = string
  default     = null
}

variable "fleet_project_grant_service_agent" {
  description = "(Optional) Grant the fleet project service identity the `roles/gkehub.serviceAgent` and `roles/gkehub.crossProjectServiceAgent` roles."
  type        = bool
  default     = false
}

variable "monitoring_metric_writer_role" {
  description = "The monitoring metrics writer role to assign to the GKE node service account"
  type        = string
  default     = "roles/monitoring.metricWriter"
  validation {
    condition     = can(regex("^(roles/[a-zA-Z0-9_.]+|projects/[a-zA-Z0-9-]+/roles/[a-zA-Z0-9_.]+)$", var.monitoring_metric_writer_role))
    error_message = "The monitoring_metric_writer_role must be either a predefined role (roles/*) or a custom role (projects/*/roles/*)."
  }
}
