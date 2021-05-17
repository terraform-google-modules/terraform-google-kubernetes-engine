apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
spec:
  # clusterName is required and must be unique among all managed clusters
  clusterName: ${cluster_name}
  policyController:
    enabled: ${enable_policy_controller}
    templateLibraryInstalled: ${install_template_library}
    logDeniesEnabled: ${enable_log_denies}
%{ if enable_multi_repo ~}
  enableMultiRepo: true
%{ else ~}
  git:
    syncRepo: ${sync_repo}
    secretType: ${secret_type}
    ${policy_dir_node}
    ${sync_branch_node}
    ${sync_revision_node}
  ${source_format_node}
%{ endif ~}
  ${hierarchy_controller_map_node}
