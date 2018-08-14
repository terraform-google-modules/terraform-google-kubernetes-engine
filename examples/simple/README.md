# Simple Cluster

This example illustrates how to create a simple cluster.

Expected variables:
- `project_id`
- `region`
- `network`
- `subnetwork`
- `ip_range_pods`
- `ip_range_services`
- `node_service_account` - Only needed if you've deleted the default service account from your project

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
