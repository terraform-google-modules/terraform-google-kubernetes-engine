# Add backup plan resources outside the cluster resource
resource "google_gke_backup_backup_plan" "this" {
  for_each = {
    for plan in try(var.gke_backup_agent_config.backup_plans, []) :
    plan.name => plan
    if try(var.gke_backup_agent_config.enabled, false)
  }

  name     = each.value.name
  location = each.value.location
  cluster  = each.value.cluster

  description = try(each.value.description, null)
  labels      = try(each.value.labels, null)

  dynamic "retention_policy" {
    for_each = each.value.retention_policy != null ? [each.value.retention_policy] : []
    content {
      backup_delete_lock_days = try(retention_policy.value.backup_delete_lock_days, null)
      backup_retain_days      = try(retention_policy.value.backup_retain_days, null)
      locked                  = try(retention_policy.value.locked, null)
    }
  }

  dynamic "schedule" {
    for_each = each.value.schedule != null ? [each.value.schedule] : []
    content {
      cron_schedule = schedule.value.cron_schedule
      paused        = try(schedule.value.paused, null)
    }
  }
}
