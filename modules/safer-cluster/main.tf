/**
 * Copyright 2018 Google LLC
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
  source             = "../beta-private-cluster/"
  project_id         = var.project_id
  name               = var.name
  regional           = var.regional
  region             = var.region
  zones              = var.zones
  network            = var.network
  network_project_id = var.network_project_id

  // We need to enforce a minimum Kubernetes Version to ensure
  // that the necessary security features are enabled.
  kubernetes_version = var.kubernetes_version

  // Nodes are created with a default version. The nodepool enables
  // auto_upgrade so that the node versions can be kept up to date with
  // the master upgrades.
  //
  // https://cloud.google.com/kubernetes-engine/versioning-and-upgrades
  release_channel = var.release_channel

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
  network_policy = true

  maintenance_start_time = var.maintenance_start_time

  initial_node_count = var.initial_node_count

  // We suggest removing the default node pull, as it cannot be modified without
  // destroying the cluster.
  remove_default_node_pool = true

  node_pools          = var.node_pools
  node_pools_labels   = var.node_pools_labels
  node_pools_metadata = var.node_pools_metadata
  node_pools_taints   = var.node_pools_taints
  node_pools_tags     = var.node_pools_tags

  node_pools_oauth_scopes = var.node_pools_oauth_scopes

  stub_domains         = var.stub_domains
  upstream_nameservers = var.upstream_nameservers

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  // We never use the default service account for the cluster. The default
  // project/editor permissions can create problems if nodes were to be ever
  // compromised.

  // We either:
  // - Create a dedicated service account with minimal permissions to run nodes.
  //   All applications shuold run with an identity defined via Workload Identity anyway.
  // - Use a service account passed as a parameter to the module, in case the user
  //   wants to maintain control of their service accounts.
  create_service_account = var.compute_engine_service_account == "" ? true : false
  service_account        = var.compute_engine_service_account
  registry_project_ids   = var.registry_project_ids
  grant_registry_access  = var.grant_registry_access

  // Basic Auth disabled
  basic_auth_username = ""
  basic_auth_password = ""

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

  config_connector = var.config_connector

  default_max_pods_per_node = var.default_max_pods_per_node

  database_encryption = var.database_encryption

  // We suggest to define policies about  which images can run on a cluster.
  enable_binary_authorization = true

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

  // We enable identity namespace by default.
  identity_namespace = "${var.project_id}.svc.id.goog"

  authenticator_security_group = var.authenticator_security_group

  enable_shielded_nodes = var.enable_shielded_nodes

  skip_provisioners = var.skip_provisioners

  gce_pd_csi_driver = var.gce_pd_csi_driver

  notification_config_topic = var.notification_config_topic
}
