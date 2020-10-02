## 
# Windows nodepool with private cluster

This example illustrates how to create a private GKE cluster with windows nodepool

- gke : Actual deployment files
- modules : Calling modules folder contains nodepool and cluster code



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project| The project ID to host the cluster in | string | n/a | yes |
| region | The region to host the cluster in | string | n/a | yes | 
| zones | The zone to host the cluster in | string | n/a | yes | 
| network | The VPC network to host the cluster in | string | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | string | n/a | yes |
| gke_cluster_master_version | GKE Cluster master kubernetes version | string | n/a | yes |
| gke_cluster_min_master_version | GKE Cluster master kubernetes version | string | n/a | yes |
| name | A suffix to append to the default cluster name | string | `""` | no |
| service\_account | Service account to associate to the nodes in the cluster | string | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | string | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | string | n/a | yes |
| regional | Options to make set the cluster regional true/false | string | n/a | yes |
| gce_labels | Lables added to cluster | List | | n/a | yes |
| node_pool_01 | Default node pool setting (linux) | List | | n/a | yes |
| node_pool_02 | Second node pool setting (Windows )| List | | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Cluster name |
| region |  |


To provision this example, run the following from within this directory:
- cd /gke
- Edit terraform.tfvars file
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
