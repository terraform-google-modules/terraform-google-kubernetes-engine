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

// This file was automatically generated from a template in ./autogen/main

/******************************************
  Delete default kube-dns configmap
 *****************************************/
module "gcloud_delete_default_kube_dns_configmap" {
  source                = "terraform-google-modules/gcloud/google"
  version               = "~> 1.0.1"
  enabled               = (local.custom_kube_dns_config || local.upstream_nameservers_config) && ! var.skip_provisioners
  additional_components = ["kubectl"]

  upgrade       = var.gcloud_upgrade
  skip_download = var.gcloud_skip_download

  create_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  create_cmd_body       = "https://${local.cluster_endpoint} ${data.google_client_config.default.access_token} ${local.cluster_ca_certificate} ${path.module}/scripts/delete-default-resource.sh kube-system configmap kube-dns"

  module_depends_on = concat(
    [data.google_client_config.default.access_token],
    [google_container_cluster.primary.master_version],
    [for pool in google_container_node_pool.pools : pool.name]
  )
}

/******************************************
  Create kube-dns confimap
 *****************************************/
resource "kubernetes_config_map" "kube-dns" {
  count = local.custom_kube_dns_config && ! local.upstream_nameservers_config ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"

    labels = {
      maintained_by = "terraform"
    }
  }

  data = {
    stubDomains = <<EOF
${jsonencode(var.stub_domains)}
EOF
  }

  depends_on = [
    module.gcloud_delete_default_kube_dns_configmap.wait,
    data.google_client_config.default,
    google_container_cluster.primary,
    google_container_node_pool.pools,
  ]
}

resource "kubernetes_config_map" "kube-dns-upstream-namservers" {
  count = ! local.custom_kube_dns_config && local.upstream_nameservers_config ? 1 : 0

  metadata {
    name = "kube-dns"

    namespace = "kube-system"

    labels = {
      maintained_by = "terraform"
    }
  }

  data = {
    upstreamNameservers = <<EOF
${jsonencode(var.upstream_nameservers)}
EOF
  }

  depends_on = [
    module.gcloud_delete_default_kube_dns_configmap.wait,
    data.google_client_config.default,
    google_container_cluster.primary,
    google_container_node_pool.pools,
  ]
}

resource "kubernetes_config_map" "kube-dns-upstream-nameservers-and-stub-domains" {
  count = local.custom_kube_dns_config && local.upstream_nameservers_config ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"

    labels = {
      maintained_by = "terraform"
    }
  }

  data = {
    upstreamNameservers = <<EOF
${jsonencode(var.upstream_nameservers)}
EOF

    stubDomains = <<EOF
${jsonencode(var.stub_domains)}
EOF
  }

  depends_on = [
    module.gcloud_delete_default_kube_dns_configmap.wait,
    data.google_client_config.default,
    google_container_cluster.primary,
    google_container_node_pool.pools,
  ]
}
