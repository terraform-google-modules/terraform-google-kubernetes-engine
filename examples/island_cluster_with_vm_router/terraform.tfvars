project_id   = "<project_id>"
region       = "us-central1"
cluster_name = "gke-island-cluster-test"
node_locations = [
  "us-central1-a",
  "us-central1-b",
  "us-central1-f"
]
subnet_cidr         = "100.64.0.0/20"
router_machine_type = "n2-highcpu-4"
primary_subnet      = "projects/<project_id>/regions/<region>/subnetworks/<subnet>"
secondary_ranges = {
  pods        = "100.64.64.0/18"
  services    = "100.64.128.0/20"
  master_cidr = "100.64.144.0/28"
}
proxy_subnet_cidr = "100.64.168.0/24"
psc_subnet_cidr   = "100.64.192.0/24"
master_authorized_networks = [
  {
    cidr_block   = "100.64.0.0/10"
    display_name = "cluster net"
  }
]
primary_net_cidrs = [
  "10.0.0.0/8",
  "192.168.0.0/16",
  "172.16.0.0/12"
]
