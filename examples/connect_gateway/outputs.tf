output "cluster" {
  sensitive   = true
  description = "The full cluster details"
  value       = module.gke_auth.cluster
}
