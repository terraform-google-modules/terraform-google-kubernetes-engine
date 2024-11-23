# Upgrading to v35.0
The v35.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 6 of the Google Cloud Platform Providers.  See the [Terraform Google Provider 6.0.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/version_6_upgrade) for more details.

### Private Cluster Sub-Modules Endpoint Output
The private cluster sub-modules now return the cluster's private endpoint for the `endpoint` output when the `enable_private_endpoint` argument is `true`, regardless of the `deploy_using_private_endpoint` argument value.
