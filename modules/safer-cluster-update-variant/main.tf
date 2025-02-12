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

// This file was automatically generated from a template in ./autogen/safer-cluster

// The safer-cluster module is based on a private cluster, with a several
// settings set to recommended values by default.
module "gke" {
  source              = "../beta-private-cluster-update-variant/"
  project_id          = var.project_id
  name                = var.name
  description         = var.description
  regional            = var.regional
  region              = var.region
  zones               = var.zones
  network             = var.network
  network_project_id  = var.network_project_id
  deletion_protection = var.deletion_protection

  // We need to enforce a minimum Kubernetes Version to ensure
  // that the necessary security features are enabled.
  kubernetes_version = var.kubernetes_version

  // Nodes are created with a default version. The nodepool enables
  // auto_upgrade so that the node versions can be kept up to date with
  // the master upgrades.
  //
  // https://cloud.google.com/kubernetes-engine/versioning-and-upgrades
  release_channel     = var.release_channel
  gateway_api_channel = var.gateway_api_channel

  master_authorized_networks = var.master_authorized_networks

  subnetwork        = var.subnetwork
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  disable_default_snat = var.disable_default_snat

  add_cluster_firewall_rules = var.add_cluster_firewall_rules
  firewall_priority          = var.firewall_priority
  firewall_inbound_ports     = var.firewall_inbound_ports

  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  http_load_balancing        = var.http_load_balancing

  // We suggest the use coarse network policies to enforce restrictions in the
  // communication between pods.
  //
  // NOTE: Enabling network policy is not sufficient to enforce restrictions.
  // NetworkPolicies need to be configured in every namespace. The network
  // policies should be under the control of a cental cluster management team,
  // rather than individual teams.
  //
  // NOTE: Dataplane-V2 conflicts with the Calico network policy add-on because
  // it provides redundant NetworkPolicy capabilities. If V2 is enabled, the
  // Calico add-on should be disabled.
  network_policy = var.datapath_provider == "ADVANCED_DATAPATH" ? false : true

  // Default to the recommended Dataplane V2 which enables NetworkPolicies and
  // allows for network policy logging of allowed and denied requests to Pods.
  datapath_provider = var.datapath_provider

  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time
  maintenance_recurrence = var.maintenance_recurrence
  maintenance_exclusions = var.maintenance_exclusions

  // We suggest removing the default node pool, as it cannot be modified without
  // destroying the cluster.
  remove_default_node_pool = true
  // If removing the default node pool, initial_node_count should be at least 1.
  initial_node_count = (var.initial_node_count == 0) ? 1 : var.initial_node_count

  node_pools                 = var.node_pools
  windows_node_pools         = var.windows_node_pools
  node_pools_labels          = var.node_pools_labels
  node_pools_resource_labels = var.node_pools_resource_labels
  node_pools_metadata        = var.node_pools_metadata
  node_pools_taints          = var.node_pools_taints
  node_pools_tags            = var.node_pools_tags

  node_pools_oauth_scopes = var.node_pools_oauth_scopes

  cluster_autoscaling = var.cluster_autoscaling

  stub_domains         = var.stub_domains
  upstream_nameservers = var.upstream_nameservers

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  monitoring_enable_managed_prometheus = var.monitoring_enable_managed_prometheus
  monitoring_enabled_components        = var.monitoring_enabled_components

  enable_confidential_nodes = var.enable_confidential_nodes

  // We never use the default service account for the cluster. The default
  // project/editor permissions can create problems if nodes were to be ever
  // compromised.

  // We either:
  // - Create a dedicated service account with minimal permissions to run nodes.
  //   All applications should run with an identity defined via Workload Identity anyway.
  // - Use a service account passed as a parameter to the module, in case the user
  //   wants to maintain control of their service accounts.
  service_account       = var.compute_engine_service_account
  registry_project_ids  = var.registry_project_ids
  grant_registry_access = var.grant_registry_access

  // If create_service_account is explicitly set to false we short-circuit the
  // compute_engine_service_account check to potentially avoid an error (see variables.tf documentation).
  // Otherwise if true (the default), we check if compute_engine_service_account is set for backwards compatability
  // before the create_service_account variable was added.
  create_service_account = var.create_service_account == false ? var.create_service_account : (var.compute_engine_service_account == "" ? true : false)

  issue_client_certificate = false

  cluster_resource_labels = var.cluster_resource_labels

  // We enable private endpoints to limit exposure.
  enable_private_endpoint       = var.enable_private_endpoint
  deploy_using_private_endpoint = true

  // Private nodes better control public exposure, and reduce
  // the ability of nodes to reach to the Internet without
  // additional configurations.
  enable_private_nodes = true

  master_global_access_enabled = true

  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  // Istio is recommended for pod-to-pod communications.
  istio      = var.istio
  istio_auth = var.istio_auth

  cloudrun = var.cloudrun

  dns_cache = var.dns_cache


  config_connector        = var.config_connector
  gke_backup_agent_config = var.gke_backup_agent_config

  cluster_dns_provider = var.cluster_dns_provider

  cluster_dns_scope = var.cluster_dns_scope

  cluster_dns_domain = var.cluster_dns_domain

  default_max_pods_per_node = var.default_max_pods_per_node

  database_encryption = var.database_encryption

  // We suggest to define policies about  which images can run on a cluster.
  enable_binary_authorization = true

  // Enable cost allocation support
  enable_cost_allocation = var.enable_cost_allocation

  // Enable L4 ILB subsetting on the cluster
  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting

  // Use of PodSecurityPolicy admission controller
  // https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies
  enable_pod_security_policy = var.enable_pod_security_policy

  resource_usage_export_dataset_id = var.resource_usage_export_dataset_id

  // Sandbox is needed if the cluster is going to run any untrusted workload (e.g., user submitted code).
  // Sandbox can also provide increased protection in other cases, at some performance cost.
  sandbox_enabled = var.sandbox_enabled

  // Intranode Visibility enables you to capture flow logs for traffic between pods and create FW rules that apply to traffic between pods.
  enable_intranode_visibility = var.enable_intranode_visibility

  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling

  // We enable Workload Identity by default.
  identity_namespace = "${var.project_id}.svc.id.goog"

  // Enabling mesh certificates requires Workload Identity
  enable_mesh_certificates = var.enable_mesh_certificates

  authenticator_security_group = var.authenticator_security_group

  enable_shielded_nodes = var.enable_shielded_nodes

  gce_pd_csi_driver    = var.gce_pd_csi_driver
  filestore_csi_driver = var.filestore_csi_driver

  notification_config_topic = var.notification_config_topic

  timeouts = var.timeouts

  enable_gcfs = var.enable_gcfs

  // Enabling vulnerability and audit for workloads
  workload_vulnerability_mode = var.workload_vulnerability_mode
  workload_config_audit_mode  = var.workload_config_audit_mode

  // Enabling security posture
  security_posture_mode               = var.security_posture_mode
  security_posture_vulnerability_mode = var.security_posture_vulnerability_mode
}
