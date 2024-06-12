# GKE island cluster anywhere in GCP design

This example provisions a cluster in an island VPC allowing reuse of the IP address space for multiple clusters across different GCP organizations.

## Deploy

1. Create NCC hub.
2. Update `ncc_hub_project_id`, `ncc_hub_name`, `network_name` and gke spokes in `terraform.tfvars`.
3. Run `terraform apply`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gke\_spokes | n/a | `any` | n/a | yes |
| ingress\_ip\_addrs\_subnet\_cidr | Subnet to use for reserving internal ip addresses for the ILBs. | `string` | n/a | yes |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | n/a | yes |
| ncc\_hub\_name | n/a | `string` | n/a | yes |
| ncc\_hub\_project\_id | n/a | `string` | n/a | yes |
| net\_attachment\_subnet\_cidr | Subnet for the router PSC interface network attachment in island network. | `string` | n/a | yes |
| node\_locations | n/a | `list(string)` | n/a | yes |
| primary\_net\_name | Primary VPC network name. | `string` | n/a | yes |
| primary\_subnet | Subnet to use in primary network to deploy the router. | `string` | n/a | yes |
| proxy\_subnet\_cidr | CIDR for the regional managed proxy subnet. | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| router\_machine\_type | n/a | `string` | n/a | yes |
| secondary\_ranges | n/a | `map(string)` | n/a | yes |
| subnet\_cidr | Primary subnet CIDR used by the cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ids | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
