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

locals {
  node_pool_default_attributes = {
    version            = "${local.node_version}"
    initial_node_count = 1
    max_node_count     = 100
    min_node_count     = 1
    auto_repair        = true
    auto_upgrade       = true
    image_type         = "COS"
    machine_type       = "n1-standard-2"
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    service_account    = "${local.service_account}"
    preemptible        = "false"
    tags_csv           = "gke-${var.name},gke-${var.name}-%s"
    oauth_scopes_csv   = "https://www.googleapis.com/auth/cloud-platform,"
  }

  node_pool_labels = "${merge(
      var.node_pools_labels["all"],
      map("cluster_name", var.name),
  )}"

  node_pool_metadata = "${merge(
    var.node_pools_metadata["all"],
    map("cluster_name", var.name),
    map("disable-legacy-endpoints", var.disable_legacy_metadata_endpoints),
  )}"
}

resource "google_container_node_pool" "main" {
  provider           = "google-beta"
  count              = "${length(var.node_pools)}"
  name               = "${lookup(var.node_pools[count.index], "name")}"
  project            = "${var.project_id}"
  location           = "${local.location}"
  cluster            = "${var.name}"
  version            = "${lookup(var.node_pools[count.index], "version", lookup(var.node_pool_default_attributes, "version", lookup(local.node_pool_default_attributes, "version")))}"
  initial_node_count = "${lookup(var.node_pools[count.index], "initial_node_count", lookup(var.node_pool_default_attributes, "initial_node_count", lookup(local.node_pool_default_attributes, "initial_node_count")))}"

  autoscaling {
    min_node_count = "${lookup(var.node_pools[count.index], "min_node_count", lookup(var.node_pool_default_attributes, "min_node_count", lookup(local.node_pool_default_attributes, "min_node_count")))}"
    max_node_count = "${lookup(var.node_pools[count.index], "max_node_count", lookup(var.node_pool_default_attributes, "max_node_count", lookup(local.node_pool_default_attributes, "max_node_count")))}"
  }

  management {
    auto_repair  = "${lookup(var.node_pools[count.index], "auto_repair", lookup(var.node_pool_default_attributes, "auto_repair", lookup(local.node_pool_default_attributes, "auto_repair")))}"
    auto_upgrade = "${lookup(var.node_pools[count.index], "auto_upgrade", lookup(var.node_pool_default_attributes, "auto_upgrade", lookup(local.node_pool_default_attributes, "auto_upgrade")))}"
  }

  node_config {
    image_type      = "${lookup(var.node_pools[count.index], "image_type", lookup(var.node_pool_default_attributes, "image_type", lookup(local.node_pool_default_attributes, "image_type")))}"
    machine_type    = "${lookup(var.node_pools[count.index], "machine_type", lookup(var.node_pool_default_attributes, "machine_type", lookup(local.node_pool_default_attributes, "machine_type")))}"
    disk_size_gb    = "${lookup(var.node_pools[count.index], "disk_size_gb", lookup(var.node_pool_default_attributes, "disk_size_gb", lookup(local.node_pool_default_attributes, "disk_size_gb")))}"
    disk_type       = "${lookup(var.node_pools[count.index], "disk_type", lookup(var.node_pool_default_attributes, "disk_type", lookup(local.node_pool_default_attributes, "disk_type")))}"
    service_account = "${lookup(var.node_pools[count.index], "service_account", lookup(var.node_pool_default_attributes, "service_account", lookup(local.node_pool_default_attributes, "service_account")))}"
    preemptible     = "${lookup(var.node_pools[count.index], "preemptible", lookup(var.node_pool_default_attributes, "preemptible", lookup(local.node_pool_default_attributes, "preemptible")))}"

    labels = "${merge(
      local.node_pool_labels,
      map("node_pool", lookup(var.node_pools[count.index], "name")),
      var.node_pools_labels[lookup(var.node_pools[count.index], "name")],
    )}"

    metadata = "${merge(
        local.node_pool_metadata,
        map("node_pool", lookup(var.node_pools[count.index], "name")),
    )}"

    taint = "${concat(
      var.node_pools_taints["all"],
      var.node_pools_taints[lookup(var.node_pools[count.index], "name")]
    )}"

    tags = ["${compact(
      concat(
        split(",", lookup(var.node_pools[count.index], "tags_csv", ",") ),
        split(",",
          format(
            local.node_pool_default_attributes["tags_csv"],
            lookup(var.node_pools[count.index], "name")
          )
        ),
      )
    )}"]

    oauth_scopes = ["${compact(
      concat(
        split(",",
          lookup(
            var.node_pools[count.index],
            "oauth_scopes_csv",
            local.node_pool_default_attributes["oauth_scopes_csv"]
          )
        )
      )
    )}"]
  }

  lifecycle {
    ignore_changes = ["initial_node_count"]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = ["google_container_cluster.public", "google_container_cluster.private"]
}
