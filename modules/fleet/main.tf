resource "google_gke_hub_fleet" "this" {
  project      = var.project_id
  display_name = var.display_name

  dynamic "default_cluster_config" {
    for_each = ((var.security_posture_mode != "DISABLED" || var.security_posture_vulnerability_mode != "VULNERABILITY_DISABLED") || (var.binary_authorization_evaluation_mode != "DISABLED" || length(var.binary_authorization_policy_bindings) > 0)) ? [1] : []

    content {
      dynamic "binary_authorization_config" {
        for_each = (var.binary_authorization_evaluation_mode != null || length(var.binary_authorization_policy_bindings) > 0) ? [1] : []
        content {
          evaluation_mode = var.binary_authorization_evaluation_mode
          dynamic "policy_bindings" {
            for_each = var.binary_authorization_policy_bindings
            content {
              name = policy_bindings.value.name
            }
          }
        }
      }

      dynamic "security_posture_config" {
        for_each = (var.security_posture_mode != null || var.security_posture_vulnerability_mode != null) ? [1] : []
        content {
          mode               = var.security_posture_mode
          vulnerability_mode = var.security_posture_vulnerability_mode
        }
      }
    }
  }

  depends_on = [
    google_project_service.gkehub
  ]
}
