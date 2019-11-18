apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
spec:
  # clusterName is required and must be unique among all managed clusters
  clusterName: ${cluster_name}
  git:
    syncRepo: ${sync_repo}
    syncBranch: ${sync_branch}
    secretType: ${secret_type}
    policyDir: ${policy_dir}
  policyController:
    enabled: ${enable_policy_controller}
    templateLibraryInstalled: ${install_template_library}
