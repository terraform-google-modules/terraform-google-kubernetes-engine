# Services

This is a helper module used to provision apis required for GKE modules. Do no use this module directly

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services | `bool` | `false` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy | `bool` | `false` | no |
| enable\_apis | Whether to actually enable the APIs. If false, this module is a no-op. | `bool` | `true` | no |
| project\_id | The GCP project you want to enable APIs on | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | The GCP project you enabled APIs on |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
