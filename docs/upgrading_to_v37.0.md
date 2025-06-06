# Upgrading to v37.0
The v37.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 6.38 or higher of the Google Cloud Platform Providers.

### Private Cluster DNS Allow External Traffic
DNS allow external traffic is now controlled solely by `dns_allow_external_traffic` for private clusters.
To enable, set `dns_allow_external_traffic` to `true`.

```diff
  module "cluster" {
-   version          = "~> 36.0"
+   version          = "~> 37.0"

+   dns_allow_external_traffic = true
}
```
