# Private Regional Autopilot Cluster With Firewall Rules

This example illustrates how to create a autopilot cluster with beta features.

It will:
- Create a private autopilot cluster
- All additional firewall variables are toggled on. In a environment with stringent firewall rules, these firewall rules allow intra cluster communication 

>note: this example does not create a stringent firewall network. This example shows what cluster firewall and network tag configuration may be required for a configuration comparable to the [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation) Which creates hierarchical firewalls to deny 0.0.0.0/0 egress and creates firewall rules to allow private google api access which targets tags "allow-google-apis". By toggling on the firewall rules variables and adding the appropriate target tag a cluster can come up healthy with no outbound internet access. 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region the cluster in | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| cluster\_name | Cluster name |
| kubernetes\_endpoint | The cluster endpoint |
| location | n/a |
| master\_kubernetes\_version | Kubernetes version of the master |
| network\_name | The name of the VPC being created |
| project\_id | The project ID the cluster is in |
| region | The region in which the cluster resides |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| subnet\_names | The names of the subnet being created |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
