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
  git:
    syncRepo: ${sync_repo}
    secretType: ${secret_type}
    ${policy_dir_node}
    ${sync_branch_node}
