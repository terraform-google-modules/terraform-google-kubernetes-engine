ncc_hub_project_id = "<ncc_hub_project_id>"
ncc_hub_name       = "<ncc_hub_name>"
region             = "us-central1"
primary_net_name   = "<network_name>"
primary_subnet     = "projects/<ncc_hub_project_id>/regions/us-central1/subnetworks/<network_name>"
gke_spokes = [
  {
    project_id              = "<gke_spoke_1_project_id>",
    cluster_name            = "gke-spoke-1",
    private_nat_subnet_cidr = "100.65.1.0/24",
    spoke_netmap_subnet     = "10.244.0.0/28"
  },
  {
    project_id              = "<gke_spoke_2_project_id>",
    cluster_name            = "gke-spoke-2",
    private_nat_subnet_cidr = "100.65.2.0/24",
    spoke_netmap_subnet     = "10.244.0.16/28"
  },
  {
    project_id              = "<gke_spoke_3_project_id>",
    cluster_name            = "gke-spoke-3",
    private_nat_subnet_cidr = "100.65.3.0/24",
    spoke_netmap_subnet     = "10.244.0.32/28"
  }
]
node_locations = [
  "us-central1-a",
  "us-central1-b",
  "us-central1-f"
]
subnet_cidr                = "100.64.0.0/19"
net_attachment_subnet_cidr = "100.64.87.0/29"
router_machine_type        = "n2-highcpu-4"
secondary_ranges = {
  pods        = "100.64.32.0/19"
  services    = "100.64.64.0/20"
  master_cidr = "100.64.96.32/28"
}
proxy_subnet_cidr            = "100.64.83.0/24"
ingress_ip_addrs_subnet_cidr = "100.64.84.0/28"
master_authorized_networks = [
  {
    cidr_block   = "100.64.0.0/10"
    display_name = "cluster net"
  }
]
