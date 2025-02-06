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

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version = "~> 36.0"

  project_id              = module.enabled_google_apis.project_id
  name                    = var.cluster_name
  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnets_names[0]
  ip_range_pods           = module.vpc.subnets_secondary_ranges[0][0].range_name
  ip_range_services       = module.vpc.subnets_secondary_ranges[0][1].range_name
  enable_private_endpoint = true
  deletion_protection     = false
  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
  database_encryption = [
    {
      "key_name" : module.kms.keys["gke-key"],
      "state" : "ENCRYPTED"
    }
  ]
  grant_registry_access = true
  node_pools = [
    {
      name          = "safer-pool"
      min_count     = 1
      max_count     = 4
      auto_upgrade  = true
      node_metadata = "GKE_METADATA"
    }
  ]
}
