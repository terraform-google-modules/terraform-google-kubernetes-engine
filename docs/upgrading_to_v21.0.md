# Upgrading to v21.0

The v21.0 release of *kubernetes-engine* is a backwards incompatible
release.

### Terraform Kubernetes Engine Module

The [Terraform Kubernetes Engine Module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine) has been rewritten to use the 'kubernetes_config_map_v1_data' resouce added to the Terraform Kubernetes provider version 2.10.

1. Run `terraform state rm module.gke.kubernetes_config_map.kube-dns`
2. Update the module version to v21.0
4. Run `terraform apply`

### Kubernetes Provider upgrade
The Terraform Kubernetes Engine module now requires version 2.10 or higher of
the Kubernetes Provider.
