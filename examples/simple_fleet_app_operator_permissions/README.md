# Simple App Operator Permissions Setup for a Fleet Scope

This example illustrates how to create a Fleet Scope for a [team](https://cloud.google.com/kubernetes-engine/fleet-management/docs/team-management) and set up permissions for an app operator in the team.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| fleet\_project\_id | The project to which the Fleet belongs. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| fleet\_project\_id | The project to which the Fleet belongs. |
| wait | An output (Fleet Scope RBAC Role Binding IDs) to use when you want to depend on granting permissions finishing. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

