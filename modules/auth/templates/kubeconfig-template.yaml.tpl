apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${cluster_ca_certificate}
    server: https://${endpoint}
  name: ${context}
contexts:
- context:
    cluster: ${context}
    user: ${context}
  name: ${context}
current-context: ${context}
kind: Config
preferences: {}
users:
- name: ${context}
  user:
    token: ${token}
