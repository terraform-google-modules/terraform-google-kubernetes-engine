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

locals {
  // GKE release channel is a list with max length 1 https://github.com/hashicorp/terraform-provider-google/blob/9d5f69f9f0f74f1a8245f1a52dd6cffb572bbce4/google/resource_container_cluster.go#L954
  gke_release_channel          = data.google_container_cluster.asm.release_channel != null ? data.google_container_cluster.asm.release_channel[0].channel : ""
  gke_release_channel_filtered = lower(local.gke_release_channel) == "unspecified" ? "" : local.gke_release_channel
  // In order or precedence, use (1) user specified channel, (2) GKE release channel, and (3) regular channel
  channel       = lower(coalesce(var.channel, local.gke_release_channel_filtered, "regular"))
  revision_name = "asm-managed${local.channel == "regular" ? "" : "-${local.channel}"}"
  // Fleet ID should default to project ID if unset
  fleet_id = coalesce(var.fleet_id, var.project_id)
}

data "google_container_cluster" "asm" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.cluster_location

  depends_on = [var.module_depends_on]
}

resource "kubernetes_namespace" "system" {
  count = var.create_system_namespace && var.mesh_management != "MANAGEMENT_AUTOMATIC" ? 1 : 0

  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_config_map" "asm_options" {
  count = var.mesh_management != "MANAGEMENT_AUTOMATIC" ? 1 : 0

  metadata {
    name      = "asm-options"
    namespace = try(kubernetes_namespace.system[0].metadata[0].name, "istio-system")
  }

  data = {
    multicluster_mode = var.multicluster_mode
    ASM_OPTS          = var.enable_cni ? "CNI=on" : null
  }

  depends_on = [google_gke_hub_membership.membership, google_gke_hub_feature.mesh, var.module_depends_on]
}

module "cpr" {
  count = var.mesh_management != "MANAGEMENT_AUTOMATIC" ? 1 : 0

  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  project_id       = var.project_id
  cluster_name     = var.cluster_name
  cluster_location = var.cluster_location
  internal_ip      = var.internal_ip

  kubectl_create_command  = "${path.module}/scripts/create_cpr.sh ${local.revision_name} ${local.channel} ${var.enable_cni} ${var.enable_vpc_sc}"
  kubectl_destroy_command = "${path.module}/scripts/destroy_cpr.sh ${local.revision_name}"

  module_depends_on = [kubernetes_config_map.asm_options]
}
