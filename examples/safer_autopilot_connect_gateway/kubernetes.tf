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

resource "random_string" "random_suffix" {
  length  = 6
  special = false
}

resource "kubernetes_cluster_role_binding" "gateway_cluster_admin" {
  for_each = { for perm in var.user_permissions : "${element(split(":", perm.user), 1)}" => perm }
  metadata {
    name = "gateway-cluster-admin-${element(split("@", each.key), 0)}"
  }
  subject {
    kind      = "User"
    name      = element(split(":", each.value.user), 1)
    api_group = "rbac.authorization.k8s.io"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = each.value.rbac_role
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [module.hub]
}