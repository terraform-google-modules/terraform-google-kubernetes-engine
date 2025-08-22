# Upgrading to v38.0
The v38.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 6.42 or higher of the Google Cloud Platform Providers.

### Update variant random ID keepers updated

The v38.0 release updates the keepers for the update variant modules. This will force a recreation of the nodepools. To avoid this, it is possible to edit the remote state of the `random_id` resource to add the new attributes.
