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

/******************************************
  Delete default kube-dns configmap
 *****************************************/
resource "null_resource" "delete_default_kube_dns_configmap" {
  count = "${local.custom_kube_dns_config ? 1 : 0}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/kube_auth_wrapper.sh ${var.project_id} ${var.credentials_path} ${var.region} ${var.cluster_name} ${path.module}/scripts/delete-default-resource.sh kube-system configmap kube-dns"
  }

  depends_on = ["google_container_cluster.primary", "google_container_node_pool.pools"]
}

/******************************************
  Create kube-dns confimap
 *****************************************/
resource "kubernetes_config_map" "kube-dns" {
  count = "${local.custom_kube_dns_config ? 1 : 0}"

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"

    labels {
      maintained_by = "terraform"
    }
  }

  data {
    stubDomains = <<EOF
${jsonencode(var.stub_domains)}
EOF
  }

  depends_on = ["null_resource.delete_default_kube_dns_configmap", "google_container_cluster.primary", "google_container_node_pool.pools"]
}
