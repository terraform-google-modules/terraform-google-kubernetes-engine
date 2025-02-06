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
  cluster_type = "node-pool"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version = "~> 36.0"

  project_id                        = var.project_id
  name                              = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                            = var.region
  zones                             = var.zones
  network                           = var.network
  subnetwork                        = var.subnetwork
  ip_range_pods                     = var.ip_range_pods
  ip_range_services                 = var.ip_range_services
  create_service_account            = false
  remove_default_node_pool          = false
  disable_legacy_metadata_endpoints = false
  cluster_autoscaling               = var.cluster_autoscaling
  deletion_protection               = false
  service_account                   = "default"
  logging_variant                   = "MAX_THROUGHPUT"

  node_pools = [
    {
      name            = "pool-01"
      min_count       = 1
      max_count       = 2
      service_account = var.compute_engine_service_account
      auto_upgrade    = true
      enable_gcfs     = false
      logging_variant = "DEFAULT"
    },
    {
      name              = "pool-02"
      machine_type      = "n1-standard-2"
      min_count         = 1
      max_count         = 2
      local_ssd_count   = 0
      disk_size_gb      = 30
      disk_type         = "pd-standard"
      accelerator_count = 1
      accelerator_type  = "nvidia-tesla-p4"
      auto_repair       = false
      service_account   = var.compute_engine_service_account
    },
    {
      name                                   = "pool-03"
      machine_type                           = "n1-standard-2"
      node_locations                         = "${var.region}-b,${var.region}-c"
      autoscaling                            = false
      node_count                             = 2
      disk_type                              = "pd-standard"
      auto_upgrade                           = true
      service_account                        = var.compute_engine_service_account
      pod_range                              = "test"
      sandbox_enabled                        = true
      cpu_manager_policy                     = "static"
      cpu_cfs_quota                          = true
      insecure_kubelet_readonly_port_enabled = false
      local_ssd_ephemeral_count              = 2
      pod_pids_limit                         = 4096
    },
    {
      name                = "pool-04"
      min_count           = 0
      service_account     = var.compute_engine_service_account
      queued_provisioning = true
    },
    {
      name                         = "pool-05"
      machine_type                 = "n1-standard-2"
      node_count                   = 1
      enable_nested_virtualization = true
    },
  ]

  node_pools_metadata = {
    pool-01 = {
      shutdown-script = "kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-local-data \"$HOSTNAME\""
    }
  }

  node_pools_labels = {
    all = {
      all-pools-example = true
    }
    pool-01 = {
      pool-01-example = true
    }
  }

  node_pools_taints = {
    all = [
      {
        key    = "all-pools-example"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    pool-01 = [
      {
        key    = "pool-01-example"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = [
      "all-node-example",
    ]
    pool-01 = [
      "pool-01-example",
    ]
  }

  node_pools_linux_node_configs_sysctls = {
    all = {
      "net.core.netdev_max_backlog" = "10000"
    }
    pool-01 = {
      "net.core.rmem_max" = "10000"
    }
    pool-03 = {
      "net.core.netdev_max_backlog" = "20000"
    }
  }

  node_pools_cgroup_mode = {
    all     = "CGROUP_MODE_V1"
    pool-01 = "CGROUP_MODE_V2"
  }
}
