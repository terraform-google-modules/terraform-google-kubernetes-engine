# Fix the name typo in the previous ConfigMap creation call
moved {
  from = kubernetes_config_map_v1_data.kube-dns-upstream-namservers
  to   = kubernetes_config_map_v1_data.kube-dns-upstream-nameservers
}

# Updates for kebab to snake case, to match best practices and Google style.
moved {
  from = kubernetes_config_map_v1_data.kube-dns
  to   = kubernetes_config_map_v1_data.kube_dns
}

moved {
  from = kubernetes_config_map_v1_data.kube-dns-upstream-nameservers
  to   = kubernetes_config_map_v1_data.kube_dns_upstream_nameservers
}

moved {
  from = kubernetes_config_map_v1_data.kube-dns-upstream-nameservers-and-stub-domains
  to   = kubernetes_config_map_v1_data.kube_dns_upstream_nameservers_and_stub_domains
}

moved {
  from = google_project_iam_member.cluster_service_account-nodeService_account
  to   = google_project_iam_member.cluster_service_account_node_service_account
}

moved {
  from = google_project_iam_member.cluster_service_account-metric_writer
  to   = google_project_iam_member.cluster_service_account_metric_writer
}

moved {
  from = google_project_iam_member.cluster_service_account-resourceMetadata-writer
  to   = google_project_iam_member.cluster_service_account_resource_metadata_writer
}

moved {
  from = google_project_iam_member.cluster_service_account-gcr
  to   = google_project_iam_member.cluster_service_account_gcr
}

moved {
  from = google_project_iam_member.cluster_service_account-artifact-registry
  to   = google_project_iam_member.cluster_service_account_artifact_registry
}
