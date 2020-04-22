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
## Outputs
 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
