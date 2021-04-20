# Terraform Kubernetes Engine Config Sync Submodule

This module installs [Config Sync](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync) in a Kubernetes cluster.

Specifically, this module automates the following steps for [installing Config
Sync](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/installing):
1. Installing the Config Sync Operator manifest onto your cluster.
2. Using an existing or generating a new SSH key for accessing Git and providing it to the Operator
3. Configuring the Operator to connect to your git repository

## Usage

The following is an example minimal usage. Please see the
[variables.tf](variables.tf) file for more details and expected values and
types.

```tf
module "config_sync" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/config-sync"

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
2. Inspect the `git_creds_public` [output](#outputs) to retrieve the public key
   used for accessing Git. Whitelist this key for access to your Git
   repo. Instructions for some popular Git hosting providers are included for
   convenience:

  * [Cloud Souce Repositories](https://cloud.google.com/source-repositories/docs/authentication#ssh)
  * [Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html)
  * [GitHub](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
  * [Gitlab](https://docs.gitlab.com/ee/ssh/)


 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_endpoint | Kubernetes cluster endpoint. | `string` | n/a | yes |
| cluster\_name | GCP cluster name used to reach cluster and which becomes the cluster name in the Config Sync kubernetes custom resource. | `string` | n/a | yes |
| create\_ssh\_key | Controls whether a key will be generated for Git authentication | `bool` | `true` | no |
| enable\_multi\_repo | Whether to use ACM Config Sync [multi-repo mode](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/multi-repo). | `bool` | `false` | no |
| hierarchy\_controller | Configurations for Hierarchy Controller. See [Hierarchy Controller docs](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/installing-hierarchy-controller) for more details. | `map(any)` | `null` | no |
| location | GCP location used to reach cluster. | `string` | n/a | yes |
| operator\_path | Path to the operator yaml config. If unset, will download from GCS releases. | `string` | `null` | no |
| policy\_dir | Subfolder containing configs in ACM Git repo. If un-set, uses Config Management default. | `string` | `""` | no |
| project\_id | GCP project\_id used to reach cluster. | `string` | n/a | yes |
| secret\_type | credential secret type, passed through to ConfigManagement spec.git.secretType. Overriden to value 'ssh' if `create_ssh_key` is true | `string` | n/a | yes |
| source\_format | Configures a non-hierarchical repo if set to 'unstructured'. Uses [Config Sync defaults](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/installing#configuring-config-management-operator) when unset. | `string` | `""` | no |
| ssh\_auth\_key | Key for Git authentication. Overrides 'create\_ssh\_key' variable. Can be set using 'file(path/to/file)'-function. | `string` | `null` | no |
| sync\_branch | ACM repo Git branch. If un-set, uses Config Management default. | `string` | `""` | no |
| sync\_repo | ACM Git repo address | `string` | n/a | yes |
| sync\_revision | ACM repo Git revision. If un-set, uses Config Management default. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| git\_creds\_public | Public key of SSH keypair to allow the Config Sync Operator to authenticate to your Git repository. |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
