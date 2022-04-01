module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project_id
  network_name = "example-network"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = var.subnet_name
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnet_name}" = [
      {
        range_name    = "${var.subnet_name}-pods"
        ip_cidr_range = "10.0.0.0/14"
      },
      {
        range_name    = "${var.subnet_name}-services"
        ip_cidr_range = "10.4.0.0/19"
      }
    ]
  }
}
