# Project Cleanup Utility

This is a simple utility that scans a GCP organization for projects matching certain criteria, and enqueues such projects for deletion. Currently supported criteria are the combination of:

- **Age:** Only projects older than the configured age, in hours, will be marked for deletion.
- **Key-Value Pair:** Only projects whose labels contain the provided key-value pair will be marked for deletion.

## Environment Configuration

The following environment variables may be specified to configure the cleanup utility:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `TARGET_TAG_NAME` | The tag name to match on for identifying projects to delete | string | n/a | yes |
| `TARGET_TAG_VALUE` | The tag value to match on for identifying projects to delete | string | n/a | yes |
| `MAX_PROJECT_AGE_HOURS` | The project age, in hours, at which point deletion should be considered | integer | n/a | yes |
# Node Pool Cluster

This example illustrates how to create a cluster with multiple custom node-pool configurations with node labels, taints, and network tags.

[^]: (autogen_docs_start)

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
