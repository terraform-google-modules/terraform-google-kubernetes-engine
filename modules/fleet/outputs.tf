output "fleet_id" {
  description = "the Fleet identifier"
  value       = google_gke_hub_fleet.this.id
}

output "fleet_state" {
  description = "The state of the fleet resource"
  value       = google_gke_hub_fleet.this.state[0].code
}

output "fleet_uid" {
  description = "Unique UID across all Fleet resources"
  value       = google_gke_hub_fleet.this.uid
}
