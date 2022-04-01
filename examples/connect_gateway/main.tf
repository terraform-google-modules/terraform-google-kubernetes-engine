# /**
#  * Copyright 2022 Google LLC
#  *
#  * Licensed under the Apache License, Version 2.0 (the "License");
#  * you may not use this file except in compliance with the License.
#  * You may obtain a copy of the License at
#  *
#  *      http://www.apache.org/licenses/LICENSE-2.0
#  *
#  * Unless required by applicable law or agreed to in writing, software
#  * distributed under the License is distributed on an "AS IS" BASIS,
#  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  * See the License for the specific language governing permissions and
#  * limitations under the License.
#  */
module "gke" {
  source     = "../../modules/beta-private-cluster"
  project_id = var.project_id
  name       = "private-connect-cluster"
  region     = var.region

  network    = module.network.network_name
  subnetwork = module.network.subnets_names[0]

  ip_range_pods     = module.network.subnets_secondary_ranges[0][0].range_name
  ip_range_services = module.network.subnets_secondary_ranges[0][1].range_name
}

module "gke_auth" {
  source = "../../modules/auth"

  project_id          = var.project_id
  cluster_name        = module.gke.name
  location            = module.gke.location
  use_connect_gateway = true
}

provider "kubernetes" {
  host  = module.gke_auth.host
  token = module.gke_auth.token
}

resource "kubernetes_config_map" "example" {
  metadata {
    name      = "connect-example"
    namespace = "default"

    labels = {
      maintained_by = "terraform"
    }
  }

  data = {
    example = "test"
  }

  depends_on = [module.gke, module.gke_auth]
}
