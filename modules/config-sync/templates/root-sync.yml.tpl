apiVersion: configsync.gke.io/v1beta1
kind: RootSync
metadata:
  name: root-sync
  namespace: config-management-system
spec:
  ${source_format_node}
  git:
    repo: ${sync_repo}
    auth: ${secret_type}
    ${policy_dir_node}
    ${sync_branch_node}
    ${sync_revision_node}
    ${secret_ref_node}
