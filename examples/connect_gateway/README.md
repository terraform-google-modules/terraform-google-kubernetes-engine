#

## Limitations

1. Hub registration must be done via `gcloud`. Using the Terraform resource does not currently install the Connect Agent.
2. You must currently explicitly add [RBAC for the Connect Agent](https://cloud.google.com/anthos/multicluster-management/gateway/setup#kubectl) to impersonate users.