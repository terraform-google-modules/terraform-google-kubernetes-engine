# Upgrading to v30.0
The v30.0 release of *kubernetes-engine* is a backwards incompatible
release.

### Default cluster service account permissions modified

When `create_service_account` is `true`, the service account will now be created with `Kubernetes Engine Default Node Service Account` role instead of `Kubernetes Engine Node Service Account` roles which is deprecated now.
This is the Google recommended least privileged role to be used for the service account attached to the GKE Nodes.
