# Safer Cluster Access with IAP Bastion Host

This end to end example aims to showcase access patterns to a [Safer Cluster](../../modules/safer-cluster/README.md), which is a hardened GKE Private Cluster, through a bastion host utilizing [Identity Awareness Proxy](https://cloud.google.com/iap/) without an external ip address. Access to this cluster's control plane is restricted to the bastion host's internal IP using [authorized networks](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks#overview).

Additionally we deploy a [tinyproxy](https://tinyproxy.github.io/) daemon which allows `kubectl` commands to be piped through the bastion host allowing ease of development from a local machine with the security of GKE Private Clusters.

## Setup

To deploy this example:

1. Run `terraform init`.

2. Create a `terraform.tfvars` to provide values for `project_id`, `bastion_members`. Optionally override any variables if necessary.

3. Run `terraform apply`.

4. After apply is complete, generate kubeconfig for the private cluster. _The command with the right parameters will displayed as the Terraform output `get_credentials_command`._

   ```sh
   gcloud container clusters get-credentials --project $PROJECT_ID --zone $ZONE --internal-ip $CLUSTER_NAME
   ```

5. SSH to the Bastion Host while port forwarding to the bastion host through an IAP tunnel. _The command with the right parameters will displayed by running `terraform output bastion_ssh_command`._

   ```sh
   gcloud beta compute ssh $BASTION_VM_NAME --tunnel-through-iap --project $PROJECT_ID --zone $ZONE -- -L8888:127.0.0.1:8888
   ```

6. You can now run `kubectl` commands though the proxy. _An example command will displayed as the Terraform output `bastion_kubectl_command`._

   ```sh
   HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces
   ```

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_members | List of users, groups, SAs who need access to the bastion host | `list(string)` | `[]` | no |
| cluster\_name | The name of the cluster | `string` | `"safer-cluster-iap-bastion"` | no |
| ip\_range\_pods\_name | The secondary ip range to use for pods | `string` | `"ip-range-pods"` | no |
| ip\_range\_services\_name | The secondary ip range to use for pods | `string` | `"ip-range-svc"` | no |
| network\_name | The name of the network being created to host the cluster in | `string` | `"safer-cluster-network"` | no |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| subnet\_ip | The cidr range of the subnet | `string` | `"10.10.10.0/24"` | no |
| subnet\_name | The name of the subnet being created to host the cluster in | `string` | `"safer-cluster-subnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_kubectl\_command | kubectl command using the local proxy once the bastion\_ssh command is running |
| bastion\_name | Name of the bastion host |
| bastion\_ssh\_command | gcloud command to ssh and port forward to the bastion host command |
| bastion\_zone | Location of bastion host |
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| cluster\_name | Cluster name |
| endpoint | Cluster endpoint |
| get\_credentials\_command | gcloud get-credentials command to generate kubeconfig for the private cluster |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| master\_authorized\_networks\_config | Networks from which access to master is permitted |
| network\_name | The name of the VPC being created |
| region | Subnet/Router/Bastion Host region |
| router\_name | Name of the router that was created |
| subnet\_name | The name of the VPC subnet being created |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
