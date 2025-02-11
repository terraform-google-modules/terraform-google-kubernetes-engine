# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module "net" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  for_each = { for k, v in var.gke_spokes : k => v }

  network_name = "gke-net-${random_id.rand.hex}"
  routing_mode = "GLOBAL"
  project_id   = each.value["project_id"]

  subnets = [
    {
      subnet_name           = "${each.value["cluster_name"]}-${var.region}-snet"
      subnet_ip             = var.subnet_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${each.value["cluster_name"]}-${var.region}-int-ip-addr-snet"
      subnet_ip             = var.ingress_ip_addrs_subnet_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${each.value["cluster_name"]}-${var.region}-net-attachment-snet"
      subnet_ip             = var.net_attachment_subnet_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = "${each.value["cluster_name"]}-${var.region}-proxy-snet"
      subnet_ip     = var.proxy_subnet_cidr
      subnet_region = var.region
      purpose       = "REGIONAL_MANAGED_PROXY"
      role          = "ACTIVE"
    },
    {
      subnet_name           = "${each.value["cluster_name"]}-${var.region}-private-nat-snet"
      subnet_ip             = each.value["private_nat_subnet_cidr"]
      subnet_region         = var.region
      subnet_private_access = "true"
      purpose               = "PRIVATE_NAT"
    },
  ]

  secondary_ranges = {
    "${each.value["cluster_name"]}-${var.region}-snet" = [
      {
        range_name    = "${each.value["cluster_name"]}-${var.region}-snet-pods"
        ip_cidr_range = var.secondary_ranges["pods"]
      },
      {
        range_name    = "${each.value["cluster_name"]}-${var.region}-snet-services"
        ip_cidr_range = var.secondary_ranges["services"]
      },
    ]
  }

  firewall_rules = [
    {
      name      = "${each.value["cluster_name"]}-iap"
      direction = "INGRESS"
      allow = [
        {
          protocol = "TCP"
          ports    = ["22"]
        }
      ]
      ranges = ["35.235.240.0/20"]
    },
    {
      name      = "${each.value["cluster_name"]}-tcp-primary"
      direction = "INGRESS"
      allow = [
        {
          protocol = "TCP"
        }
      ]
      ranges = [
        var.net_attachment_subnet_cidr
      ]
    },
    {
      name      = "${each.value["cluster_name"]}-allow-proxy"
      direction = "INGRESS"
      allow = [
        {
          protocol = "TCP"
        }
      ]
      ranges                  = [var.proxy_subnet_cidr]
      target_service_accounts = [google_service_account.gke-sa[each.key].email]
    },
  ]
}

resource "google_compute_route" "primary_to_spoke" {
  for_each = { for k, v in var.gke_spokes : k => v }

  name              = "primary-to-spoke-for-${each.value["cluster_name"]}"
  description       = "primary to GKE spoke through router"
  project           = var.ncc_hub_project_id
  network           = var.primary_net_name
  dest_range        = each.value["spoke_netmap_subnet"]
  next_hop_instance = google_compute_instance.vm[each.key].id
}

resource "google_network_connectivity_spoke" "spoke" {
  provider = google-beta
  for_each = { for k, v in var.gke_spokes : k => v }

  name        = "${each.value["cluster_name"]}-spoke-${random_id.rand.hex}"
  project     = each.value["project_id"]
  location    = "global"
  description = "vpc spoke for inter vpc nat"
  hub         = "projects/${var.ncc_hub_project_id}/locations/global/hubs/${var.ncc_hub_name}"
  linked_vpc_network {
    exclude_export_ranges = [
      var.subnet_cidr,
      var.ingress_ip_addrs_subnet_cidr,
      var.net_attachment_subnet_cidr,
      var.secondary_ranges["pods"],
      var.secondary_ranges["services"],
      var.secondary_ranges["master_cidr"],
      var.proxy_subnet_cidr
    ]
    uri = module.net[each.key].network_self_link
  }
}

resource "google_compute_network_attachment" "router_net_attachment" {
  provider = google-beta
  for_each = { for k, v in var.gke_spokes : k => v }

  name                  = "net-attachment-${each.value["cluster_name"]}"
  project               = each.value["project_id"]
  region                = var.region
  description           = "router network attachment for cluster ${each.value["cluster_name"]}"
  connection_preference = "ACCEPT_MANUAL"

  subnetworks = [
    module.net[each.key].subnets["${var.region}/${each.value["cluster_name"]}-${var.region}-net-attachment-snet"]["self_link"]
  ]

  producer_accept_lists = [
    var.ncc_hub_project_id
  ]
}

module "cloud_router" {
  source   = "terraform-google-modules/cloud-router/google"
  version  = "~> 6.0"
  for_each = { for k, v in var.gke_spokes : k => v }

  name    = "router-${each.value["cluster_name"]}-${random_id.rand.hex}"
  project = each.value["project_id"]
  network = module.net[each.key].network_name
  region  = var.region
}

resource "google_compute_router_nat" "nat_type" {
  provider   = google-beta
  depends_on = [module.cloud_router]

  for_each = { for k, v in var.gke_spokes : k => v }

  name                               = "private-nat-${random_id.rand.hex}"
  router                             = "router-${each.value["cluster_name"]}-${random_id.rand.hex}"
  project                            = each.value["project_id"]
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  type                               = "PRIVATE"
  rules {
    rule_number = 100
    description = "rule for private nat"
    match       = "nexthop.hub == \"//networkconnectivity.googleapis.com/projects/${var.ncc_hub_project_id}/locations/global/hubs/${var.ncc_hub_name}\""
    action {
      source_nat_active_ranges = [
        module.net[each.key].subnets["${var.region}/${each.value["cluster_name"]}-${var.region}-private-nat-snet"]["self_link"]
      ]
    }
  }
}

resource "google_compute_address" "gke-l7-rilb-ip" {
  for_each = { for k, v in var.gke_spokes : k => v }

  name         = "${each.value["cluster_name"]}-l7-rilb-ip"
  address_type = "INTERNAL"
  region       = var.region
  project      = each.value["project_id"]
  subnetwork   = module.net[each.key].subnets["${var.region}/${each.value["cluster_name"]}-${var.region}-int-ip-addr-snet"]["self_link"]
}
