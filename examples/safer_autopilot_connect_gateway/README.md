# Safer Autopilot cluster with Connect Gateway

This end to end example aims to showcase accessing a Private GKE Cluster outside of the VPC via [Connect Gateway](https://cloud.google.com/anthos/multicluster-management/gateway).

The Connect Gateway makes it easy to connect, authenticate and authorize to the cluster 

This example deploys a Autopilot GKE cluster and register the cluster to a [Fleet](https://cloud.google.com/anthos/multicluster-management/fleet-overview). 

## Setup

To deploy this example:

1. Run `terraform init`.

2. Create a `terraform.tfvars` to provide values for `project_id`, `network_name` . Optionally override any variables if necessary.

3. Run `terraform apply`.

4. After apply is complete, connect to the GKE cluster via gcloud command. Run the 
 command  `terraform output cluster_membership_id` to get the membership name for the GKE cluster .Alternatively the membership ID can be accessed via the below gcloud command as well

 ```sh
gcloud container fleet memberships list
 ```

5. Use the following command to get the kubeconfig you need to interact with your specified cluster, replacing MEMBERSHIP_NAME with your cluster's fleet membership name. This command returns a special Connect gateway-specific kubeconfig that lets you connect to the cluster through the gateway.
   
   ```sh
   gcloud container fleet memberships get-credentials MEMBERSHIP_NAME
   ```

6. You can now run `kubectl` commands .

   ```sh
    kubectl get pods --all-namespaces
   ```

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The name of the cluster (required) | `string` | `"gke-autopilot-private-1"` | no |
| maintenance\_end\_time | Time window specified for recurring maintenance operations in RFC3339 format | `string` | `"2023-02-08T05:00:00Z"` | no |
| maintenance\_recurrence | Frequency of the recurring maintenance window in RFC5545 format | `string` | `"FREQ=WEEKLY;BYDAY=MO,TU,WE,TH"` | no |
| maintenance\_start\_time | Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `"2023-02-08T00:00:00Z"` | no |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| network\_name | The VPC network to host the cluster in (required) | `string` | `""` | no |
| network\_project\_id | The GCP project housing the VPC network to host the cluster in | `any` | n/a | yes |
| pods\_range\_name | The name of the secondary subnet ip range to use for pods | `string` | n/a | yes |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region the cluster in | `string` | `"us-central1"` | no |
| subnet\_name | The subnetwork to host the cluster in (required) | `string` | `""` | no |
| svc\_range\_name | The name of the secondary subnet range to use for services | `string` | n/a | yes |
| user\_permissions | Configure RBAC role for the user | <pre>list(object({<br>    user      = string<br>    rbac_role = string<br>  }))</pre> | <pre>[<br>  {<br>    "rbac_role": "cluster-admin",<br>    "user": "user:exampleuser@example.com"<br>  },<br>  {<br>    "rbac_role": "cluster-viewer",<br>    "user": "serviceAccount:EXAMPLE_SA@GCP_PROJECT_ID.iam.gserviceaccount.com"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| cluster\_membership\_id | The ID of the hub membership |
| kubernetes\_endpoint | n/a |
| name | Cluster name |
| service\_account | The default service account used for running nodes. |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
