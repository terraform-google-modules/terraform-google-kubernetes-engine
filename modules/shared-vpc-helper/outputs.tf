output "gke_service_project_id" {
  value       = var.gke_svpc_service_project
  description = "The project ID of the service account (to host the GKE cluster in)"

}

output "gke_host_project_id" {
  value       = var.gke_svpc_host_project
  description = "The project ID of the shared VPC's host"
}

output "gke_subnetwork" {
  value       = var.gke_subnetwork
  description = "The host account subnetwork to share with service account (to host the GKE cluster in)"
}

output "gke_service_account" {
  value       = var.gke_sa
  description = "The service account in a service project to run GKE cluster nodes"
}
