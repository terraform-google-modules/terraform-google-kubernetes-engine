# Terraform Kubernetes Engine Auth Module

This module allows configuring authentication to a GKE cluster
using an [OpenID Connect token](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)
retrieved from GCP as a `kubeconfig` file or as outputs intended for use with
the `kubernetes` / `helm` providers.

This module retrieves a token for the account configured with the `google`
provider as the Terraform runner using the provider's `credentials`,
`access_token`, or other means of authentication.

If you run a [private cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/private-cluster-concept), you can set the `use_private_endpoint` property to return the GKE private_endpoint IP address.

## Usage

```tf
module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id           = "my-project-id"
  cluster_name         = "my-cluster-name"
  location             = module.gke.location
  use_private_endpoint = true
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
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The name of the GKE cluster. | `string` | n/a | yes |
| location | The location (region or zone) of the GKE cluster. | `string` | n/a | yes |
| project\_id | The GCP project of the GKE cluster. | `string` | n/a | yes |
| use\_private\_endpoint | Connect on the private GKE cluster endpoint | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ca\_certificate | The cluster\_ca\_certificate value for use with the kubernetes provider. |
| host | The host value for use with the kubernetes provider. |
| kubeconfig\_raw | A kubeconfig file configured to access the GKE cluster. |
| token | The token value for use with the kubernetes provider. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
