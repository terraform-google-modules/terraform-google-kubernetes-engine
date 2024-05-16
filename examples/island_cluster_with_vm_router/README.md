# GKE island cluster using VM as router

This example provisions a cluster in an island VPC allowing reuse of the IP address space for multiple clusters in the same project.

1. An appliance(VM as router) with multiple NICs is used to establish connectivity between the island VPC and the existing network.
1. Outbound connections will go through the router.
1. For inbound connections, use Private Service Connect.

## Deploy

1. Update `project_id`, `cluster_name` and `primary_subnet` values in `terraform.tfvars`, and update other variables as needed.
1. Run `terraform apply`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | n/a | `string` | n/a | yes |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | n/a | yes |
| node\_locations | n/a | `list(string)` | n/a | yes |
| primary\_net\_cidrs | n/a | `list(string)` | n/a | yes |
| primary\_subnet | n/a | `string` | n/a | yes |
| project\_id | n/a | `string` | n/a | yes |
| proxy\_subnet\_cidr | n/a | `string` | n/a | yes |
| psc\_subnet\_cidr | n/a | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| router\_machine\_type | n/a | `string` | n/a | yes |
| secondary\_ranges | n/a | `map(string)` | n/a | yes |
| subnet\_cidr | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
