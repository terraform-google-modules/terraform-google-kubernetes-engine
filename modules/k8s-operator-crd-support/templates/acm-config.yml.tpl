apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
spec:
  clusterName: ${cluster_name}
  git:
    secretType: ${secret_type}
    syncRepo: ${sync_repo}
    syncBranch: ${sync_branch}
    policyDir: ${policy_dir}
  policyController:
    enabled: ${enable_policy_controller}
    templateLibraryInstalled: ${install_template_library}
