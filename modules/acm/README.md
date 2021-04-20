# Terraform Kubernetes Engine ACM Submodule

This module installs [Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/) (ACM) in a Kubernetes cluster.

Specifically, this module automates the following steps for [installing ACM](https://cloud.google.com/anthos-config-management/docs/how-to/installing):
1. Enabling the ACM feature on hub.
2. Installing the ACM Operator on your cluster.
3. Optionally, generating an SSH key for accessing Git and providing it to the Operator
4. Configuring the Operator to connect to your ACM repository

## Usage

There is a [full example](../../examples/simple_zonal_with_acm) provided. Simple usage is as follows:

```tf
module "acm" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/acm"

  project_id       = "my-project-id"
  cluster_name     = "my-cluster-name"
  location         = module.gke.location
  cluster_endpoint = module.gke.endpoint

  sync_repo        = "git@github.com:GoogleCloudPlatform/csp-config-management.git"
  sync_branch      = "1.0.0"
  policy_dir       = "foo-corp"
}
```

To deploy this config:
1. Run `terraform apply`
2. Inspect the `git_creds_public` [output](#outputs) to retrieve the public key used for accessing Git. Whitelist this key for access to your Git repo. Instructions for some popular Git hosting providers are included for convenience:

  * [Cloud Souce Repositories](https://cloud.google.com/source-repositories/docs/authentication#ssh)
  * [Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html)
  * [GitHub](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
  * [Gitlab](https://docs.gitlab.com/ee/ssh/)

## Whitelisting
Note that installing Anthos Config Management [requires](https://cloud.google.com/anthos-config-management/docs/how-to/installing#local_environment) an active Anthos license.
By default, this module will attempt to download the ACM operator from Google directly—meaning your Terraform service account needs to be whitelisted for ACM access. If this is an issue, you can predownload the operator yourself then set the `operator_path` variable to point to the file location.

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_endpoint | Kubernetes cluster endpoint. | `string` | n/a | yes |
| cluster\_name | GCP cluster Name used to reach cluster and which becomes the cluster name in the Config Sync kubernetes custom resource. | `string` | n/a | yes |
| create\_ssh\_key | Controls whether a key will be generated for Git authentication | `bool` | `true` | no |
| enable\_log\_denies | Whether to enable logging of all denies and dryrun failures for ACM Policy Controller. | `bool` | `false` | no |
| enable\_multi\_repo | Whether to use ACM Config Sync [multi-repo mode](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/multi-repo). | `bool` | `false` | no |
| enable\_policy\_controller | Whether to enable the ACM Policy Controller on the cluster | `bool` | `true` | no |
| hierarchy\_controller | Configurations for Hierarchy Controller. See [Hierarchy Controller docs](https://cloud.google.com/anthos-config-management/docs/how-to/installing-hierarchy-controller) for more details | `map(any)` | `null` | no |
| install\_template\_library | Whether to install the default Policy Controller template library | `bool` | `true` | no |
| location | GCP location used to reach cluster. | `string` | n/a | yes |
| operator\_path | Path to the operator yaml config. If unset, will download from GCS releases. | `string` | `null` | no |
| policy\_dir | Subfolder containing configs in ACM Git repo. If un-set, uses Config Management default. | `string` | `""` | no |
| project\_id | GCP project\_id used to reach cluster. | `string` | n/a | yes |
| secret\_type | git authentication secret type, is passed through to ConfigManagement spec.git.secretType. Overriden to value 'ssh' if `create_ssh_key` is true | `string` | `"ssh"` | no |
| service\_account\_key\_file | Path to service account key file to auth as for running `gcloud container clusters get-credentials`. | `string` | `""` | no |
| source\_format | Configures a non-hierarchical repo if set to 'unstructured'. Uses [ACM defaults](https://cloud.google.com/anthos-config-management/docs/how-to/installing#configuring-config-management-operator) when unset. | `string` | `""` | no |
| ssh\_auth\_key | Key for Git authentication. Overrides 'create\_ssh\_key' variable. Can be set using 'file(path/to/file)'-function. | `string` | `null` | no |
| sync\_branch | ACM repo Git branch. If un-set, uses Config Management default. | `string` | `""` | no |
| sync\_repo | ACM Git repo address | `string` | n/a | yes |
| sync\_revision | ACM repo Git revision. If un-set, uses Config Management default. | `string` | `""` | no |
| use\_existing\_context | Use existing kubecontext to auth kube-api. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| git\_creds\_public | Public key of SSH keypair to allow the Anthos Config Management Operator to authenticate to your Git repository. |
| wait | An output to use when you want to depend on cmd finishing |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
