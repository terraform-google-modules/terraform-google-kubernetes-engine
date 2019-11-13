/*
Copyright 2019 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

module "gke-network" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "my-network"

  subnets = [
    {
      subnet_name           = "my-subnet"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    "my-subnet" = [
      {
        range_name    = "my-network-${var.cluster_name}-pod-range"
        ip_cidr_range = "10.1.0.0/16"
      },
      {
        range_name    = "my-network-${var.cluster_name}-service-range"
        ip_cidr_range = "10.2.0.0/20"
      },
  ] }
}

module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  project_id    = var.project_id
  region        = var.region
  create_router = "true"
  router        = "${var.cluster_name}-cloud-nat"
  network       = module.gke-network.network_name
}
