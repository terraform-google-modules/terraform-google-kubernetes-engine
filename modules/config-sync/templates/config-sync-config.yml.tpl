apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
spec:
  # clusterName is required and must be unique among all managed clusters
  clusterName: ${cluster_name}
  git:
    syncRepo: ${sync_repo}
    secretType: ${secret_type}
    ${sync_branch_node}
    ${policy_dir_node}
  ${source_format_node}
  ${hierarchy_controller_map_node}
