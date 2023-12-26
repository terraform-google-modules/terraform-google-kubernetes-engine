# Upgrading to v30.0
The v30.0 release of *kubernetes-engine* is a backwards incompatible
release.

### Default cluster service account permissions modified

When `create_service_account` is `true`, the service account will now be created with the `Logs Writer`, `Monitoring Metric Writer`, `Monitoring Viewer` and `Stackdriver Resource Metadata Writer` roles instead of the deprecated `Kubernetes Engine Node Service Account` role.
