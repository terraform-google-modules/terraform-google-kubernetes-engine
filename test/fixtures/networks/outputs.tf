output "project_id" {
  value = "${var.project_id}"
}

output "credentials_path" {
  value = "${local.credentials_path}"
}

output "region" {
  value = "${var.region}"
}

output "network" {
  value = "${google_compute_network.main.name}"
}

output "subnetwork" {
  value = 
    {
      deploy-service = "${google_compute_subnetwork.example-deploy_service.name}"
      node-pool = "${google_compute_subnetwork.example-node_pool.name}"
      simple-regional = "${google_compute_subnetwork.example-simple_regional.name}"
      simple-zonal = "${google_compute_subnetwork.example-simple_zonal.name}"
      stub-domains = "${google_compute_subnetwork.example-stub_domains.name}"
    }
}

output "ip_range_pods" {
  value = {
    deploy-service = "${google_compute_subnetwork.example-deploy_service.secondary_ip_range.0.range_name}"
    node-pool = "${google_compute_subnetwork.example-node_pool.secondary_ip_range.0.range_name}"
    simple-regional = "${google_compute_subnetwork.example-simple_regional.secondary_ip_range.0.range_name}"
    simple-zonal = "${google_compute_subnetwork.example-simple_zonal.secondary_ip_range.0.range_name}"
    stub-domains = "${google_compute_subnetwork.example-stub_domains.secondary_ip_range.0.range_name}"
  }
}

output "ip_range_services" {
  value = {
    deploy-service = "${google_compute_subnetwork.example-deploy_service.secondary_ip_range.1.range_name}"
    node-pool = "${google_compute_subnetwork.example-node_pool.secondary_ip_range.1.range_name}"
    simple-regional = "${google_compute_subnetwork.example-simple_regional.secondary_ip_range.1.range_name}"
    simple-zonal = "${google_compute_subnetwork.example-simple_zonal.secondary_ip_range.1.range_name}"
    stub-domains = "${google_compute_subnetwork.example-stub_domains.secondary_ip_range.1.range_name}"
  }
}
