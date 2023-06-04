# Private Regional Autopilot Cluster With Firewall Rules

This example creates a regional autopilot cluster with beta features

It will:
- Create a private autopilot cluster
- Variables ```add_cluster_firewall_rules```, ```add_master_webhook_firewall_rules``` and ```add_shadow_firewal_rules``` are toggled on. In a environment with stringent firewall rules, these cluster firewall rules may be required to allow intra cluster communication
- Adds an example network tag. This example network tag aligns with a firewall rule target tag from the [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation) configuration to allow google api access

>note: this example does **not** create a network with stringent firewall rules. This example shows what cluster configuration may be required for a networking configuration comparable to the [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation)'s base shared VPCs, or any VPC with firewall rules to deny 0.0.0.0/0 egress and an allow rule for private google api egress access which targets tags "allow-google-apis". By toggling on the firewall rules variables and adding network_tags to allow private google api access, a private cluster can come up healthy with no internet egress. This configuration shows how to ensure those firewalls that explicitly allow intra cluster ingress and egress are created and appropriate network tags are attached to the cluster.

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
