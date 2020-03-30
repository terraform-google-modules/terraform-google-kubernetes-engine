# kubeconfig

output "kubeconfig_raw" {
  sensitive   = true
  description = "A kubeconfig file configured to access the GKE cluster."
  value       = data.template_file.kubeconfig.rendered
}

# Terraform providers (kubernetes, helm)

output "cluster_ca_certificate" {
  sensitive   = true
  description = "The cluster_ca_certificate value for use with the kubernetes provider."
  value       = base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
}

output "host" {
  description = "The host value for use with the kubernetes provider."
  value       = "https://${data.google_container_cluster.gke_cluster.endpoint}"
}

output "token" {
  sensitive   = true
  description = "The token value for use with the kubernetes provider."
  value       = data.google_client_config.provider.access_token
}
