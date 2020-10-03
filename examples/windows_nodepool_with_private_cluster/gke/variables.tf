/**
 * Copyright 2020 Google LLC
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

variable "project" {}

variable "region" {}

variable "network" {}

variable "cluster_name" {
  default = ""
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "subnetwork" {
  default = ""
}

variable "gke_cluster_min_master_version" {
  default = "1.16.8-gke.15"
}
variable "master_ipv4_cidr_block" {
  default = ""
}
variable "regional" {
  default = false
}

# variable "image_type" {
#   default = "COS"
# }

variable "machine_type" {
  default = "n1-standard-1"
}

variable "node_count" {
  default = 1
}

# variable "preemptible" {
#   default = false
# }

# variable "enable_autoscaling" {
#   default = false
# }
# variable "auto_repair" {
#   default = true
# }
# variable "auto_upgrade" {
#   default = false
# }
# variable "min_node_count" {
#   default = 1
# }

# variable "max_node_count" {
#   default = 3
# }

variable "service_account" {
  default = ""
}

# variable "kubernetes_labels" {
#   default = ""
# }

variable "gce_labels" {
  default = ""
}

# variable "disk_type" {
#   default = ""
# }

# variable "disk_size_gb" {
#   default = ""
# }

variable "gke_cluster_master_version" {
  default = ""
}

variable "master_authorized_networks" {
  default = []
}
variable "node_pool_01" {
  description = "The configuration for Node pool 1"
}
variable "node_pool_02" {
  description = "The configuration for Node pool 2"
}