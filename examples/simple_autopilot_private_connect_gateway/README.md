# Simple Regional Autopilot Cluster configured with Connect Gateway

This example illustrates how to create a simple autopilot cluster with beta features along with Connect Gateway to access the Private Autopilot Cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in | `string` | `"pentagon-324205"` | no |
| region | The region the cluster in | `string` | `"us-central1"` | no |
| user\_permissions | Configure RBAC role for the user | <pre>list(object({<br>    user      = string<br>    rbac_role = string<br>  }))</pre> | <pre>[<br>  {<br>    "rbac_role": "cluster-admin",<br>    "user": "user:exampleuser@example.com"<br>  },<br>  {<br>    "rbac_role": "cluster-viewer",<br>    "user": "serviceAccount:EXAMPLE_SA@GCP_PROJECT_ID.iam.gserviceaccount.com"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| cluster\_membership\_id | The ID of the hub membership |
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

## Setup

To deploy this example:

1. Run `terraform init`.

2. Create a `terraform.tfvars` to provide values for `project_id`, `network_name` . Optionally override any variables if necessary.

3. Run `terraform apply`.

4. After apply is complete, connect to the GKE cluster via gcloud command. Run the command `terraform output cluster_membership_id` to get the membership name for the GKE cluster .Alternatively the membership ID can be accessed via the below gcloud command as well.

 ```sh
gcloud container fleet memberships list
 ```

5. Use the following command to get the kubeconfig you need to interact with your specified cluster, replacing MEMBERSHIP_NAME with your cluster's fleet membership name. This command returns a special Connect gateway-specific kubeconfig that lets you connect to the cluster through the gateway.
   ```sh
   gcloud container fleet memberships get-credentials MEMBERSHIP_NAME
   ```
6. You can now run `kubectl` commands.

   ```sh
    kubectl get pods --all-namespaces
   ```
