# --- Enable GKE HUB API ---

resource "google_project_service" "gkehub" {
  project = var.project_id
  service = "gkehub.googleapis.com"

  disable_on_destroy = false
}

# --- Enable Anthos API ---

resource "google_project_service" "anthos" {
  count = ((var.security_posture_mode != "DISABLED" || var.security_posture_vulnerability_mode != "VULNERABILITY_DISABLED") || (var.binary_authorization_evaluation_mode != "DISABLED" || length(var.binary_authorization_policy_bindings) > 0)) ? 1 : 0

  project = var.project_id
  service = "anthos.googleapis.com"

  disable_on_destroy = false
}
