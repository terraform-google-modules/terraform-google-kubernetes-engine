# Terrafrom Module for Fleet App Operator Permissions

This module bundles different permissions (IAM and RBAC Role Bindings) required for [Fleet team management](https://cloud.google.com/kubernetes-engine/fleet-management/docs/team-management). A platform admin can use this module to set up permissions for an app operator (user or group) in a team--including usage of Fleet Scopes, Connect Gateway, logging, and metrics--based on predefined roles (VIEW, EDIT, ADMIN).

## Usage
```tf
Example:
module "fleet_app_operator_permissions" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/fleet-app-operator-permissions"

  fleet_project_id = "my-project-id"
  scope_id         = "frontend-team"
  users            = ["person1@company.com", "person2@company.com"]
  groups           = ["people@company.com"]
  role             = "EDIT"
}
```

To deploy this config, run:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| fleet\_project\_id | The project to which the Fleet belongs. | `string` | n/a | yes |
| groups | The list of app operator group principals, e.g., `people@google.com`, `principalSet://iam.googleapis.com/locations/global/workforcePools/my-pool/group/people`. | `list(string)` | `[]` | no |
| role | The principals role for the Fleet Scope (`VIEW`/`EDIT`/`ADMIN`). | `string` | n/a | yes |
| scope\_id | The scope for which IAM and RBAC role bindings are created. | `string` | n/a | yes |
| users | The list of app operator user principals, e.g., `person@google.com`, `principal://iam.googleapis.com/locations/global/workforcePools/my-pool/subject/person`, `serviceAccount:my-service-account@my-project.iam.gserviceaccount.com`. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| fleet\_project\_id | The project to which the Fleet belongs. |
| wait | An output to use when you want to depend on Scope RBAC Role Binding creation finishing. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
