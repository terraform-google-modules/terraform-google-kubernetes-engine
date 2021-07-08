# Simple Zonal Cluster

This example illustrates how to create a simple cluster and install [Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/).

It incorporates the standard cluster module and the [ACM install module](../../modules/acm).

## Verifying Success

After applying the Terraform configuration, you can run the following commands to verify that your cluster has synced correctly:

1. Check ACM install status:

    ```
    gcloud config set project $(terraform output --raw project_id)
    gcloud alpha container hub config-management status
    ```

2. Connect to the cluster:

    ```
    gcloud container clusters get-credentials $(terraform output --raw cluster_name) --zone=$(terraform output --raw location)
    ```

3. Confirm the `shipping-dev` namespace was created:

    ```
    kubectl describe ns shipping-dev
    ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| zone | The zone to host the cluster in | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| acm\_git\_creds\_public | Public key of SSH keypair to allow the Anthos Operator to authenticate to your Git repository. |
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint | n/a |
| location | n/a |
| master\_kubernetes\_version | The master Kubernetes version |
| network | n/a |
| project\_id | Standard test outputs |
| region | n/a |
| service\_account | The default service account used for running nodes. |
| subnetwork | n/a |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
