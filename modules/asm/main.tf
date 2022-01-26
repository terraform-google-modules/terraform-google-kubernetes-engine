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
  gke_release_channel = length(data.google_container_cluster.asm_cluster.release_channel) > 0 ? data.google_container_cluster.asm_cluster.release_channel[0].channel : ""
  gke_release_channel_fixed = local.gke_release_channel == "UNSPECIFIED" ? "" : local.gke_release_channel
  // In order or precedence, use (1) user specified channel, (2) GKE release channel, and (3) regular channel
  channel = lower(coalesce(var.channel, local.gke_release_channel_fixed, "regular"))
  revision_name = "asm-managed${local.channel == "regular" ? "" : "-${local.channel}"}"
  mesh_config_name= "istio-${local.revision_name}"
}

data "google_container_cluster" "asm_cluster" {
  project = var.project_id
  name = var.cluster_name
  location = var.cluster_location
}

resource "kubernetes_namespace" "system_namespace" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_config_map" "mesh_config" {
    metadata {
      name = local.mesh_config_name
      namespace = kubernetes_namespace.system_namespace.metadata[0].name
      annotations = {
        "mesh.cloud.google.com/proxy" = "{\"managed\": \"${var.enable_mdp}\"}"
      }
      labels = {
        "istio.io/rev" = local.revision_name
      }
    }
    data = {
      mesh = yamlencode(var.mesh_config)
    }
}

resource "kubernetes_config_map" "asm_options" {
  metadata {
    name = "asm-options"
    namespace = kubernetes_namespace.system_namespace.metadata[0].name
  }

  data = {
    CROSS_CLUSTER_SERVICE_DISCOVERY = var.enable_cross_cluster_service_discovery ? "ON" : "OFF"
  }
}

module "cpr" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"

  project_id                  = var.project_id
  cluster_name                = var.cluster_name
  cluster_location            = var.cluster_location

  kubectl_create_command  = "${path.module}/scripts/create_cpr.sh ${local.revision_name} ${local.channel} ${var.enable_cni}"
  kubectl_destroy_command = "${path.module}/scripts/destroy_cpr.sh ${local.revision_name}"

  module_depends_on = [kubernetes_config_map.asm_options, kubernetes_config_map.mesh_config]
}
