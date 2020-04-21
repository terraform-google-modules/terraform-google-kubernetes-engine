# Terraform Kubernetes Engine Auth Module

This module allows configuring authentication to a GKE cluster
using an [OpenID Connect token](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)
retrieved from GCP as a `kubeconfig` file or as outputs intended for use with
the `kubernetes` / `helm` providers.

This module retrieves a token for the account configured with the `google`
provider as the Terraform runner using the provider's `credentials`,
`access_token`, or other means of authentication.

## Usage

```tf
module "gke_auth" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id       = "my-project-id"
  cluster_name     = "my-cluster-name"
  location         = module.gke.location
}
```


### `kubeconfig` output

```hcl
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
}
```

### `kubernetes`/`helm` provider output

```hcl
provider "kubernetes" {
  load_config_file = false

  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
}
```
