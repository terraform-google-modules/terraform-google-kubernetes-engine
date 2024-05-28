# Terrafrom Module for Fleet App Operator Permissions

This module bundles different permissions (IAM and RBAC Role Bindings) required for [Fleet team management](https://cloud.google.com/kubernetes-engine/fleet-management/docs/team-management). A platform admin can use this module to set up permissions for an app operator (user or group) in a team--including usage of Fleet Scopes, Connect Gateway, logging, and metrics--based on predefined roles (VIEW, EDIT, ADMIN).

## Usage
```tf
Example:
module "fleet_app_operator_permissions" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/fleet-app-operator-permissions"

  project_id       = "my-project-id"
  scope_id         = "frontend-team"
  user             = "person@company.com"
  role             = "EDIT"
}
```

To deploy this config:
1. Run `terraform apply`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| group | The group principal for the Fleet Scope, e.g., people@company.com. Either user or group must be provided. | `string` | `""` | no |
| project\_id | The project to which the Fleet belongs. | `string` | n/a | yes |
| role | The principal role for the Fleet Scope (VIEW/EDIT/ADMIN). | `string` | n/a | yes |
| scope\_id | The scope for which IAM and RBAC role bindings are created. | `string` | n/a | yes |
| user | The user principal for the Fleet Scope, e.g., person@company.com. Either user or group must be provided. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | The project to which the Fleet belongs. |
| wait | An output to use when you want to depend on Scope RBAC Role Binding creation finishing. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
