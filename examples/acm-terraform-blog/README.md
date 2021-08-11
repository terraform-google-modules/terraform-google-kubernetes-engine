# Examples to accompany the GCP blog highlighting Terraform support for ACM GKE features
The contents of this folder will be used for examples to accompany a short series of  blog articles explaining how to enable [Anthos Config Management (ACM)](https://cloud.google.com/anthos/config-management) with Terraform. 

The [first part](./part1) explains how to use teraform to create a cluster and manage its config from git via [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview). 

[Part two](./part2) will build on that to add guard rails for the cluster via [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller). We will focus on enabling an ongoing audit of cluster resources using the Policy Controller's built in [Policy Library](http://cloud/anthos-config-management/docs/reference/constraint-template-library) and a bundle of constraints enforcings [CIS Kubernetes Benchmark v.1.5.1](https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks).

Subsequent articles will discuss other aspects of ACM to manage your GCP infrastrcuture.

The structure of the folder is as follows:

```bash
ROOT
├── README.md
├── part1
│   ├── README.md
│   ├── config-root
│   │   └── wordpress-bundle.yaml
│   └── terraform
│       ├── variables.tf
│       └── main.tf
└── part2
    ├── README.md
    ├── config-root
    │   ├── wordpress-bundle.yaml
    │   ├── audit-config.yaml
    │   └── cis-k8s-1.5.1
    │       └── *.yaml
    └── terraform
        ├── variables.tf
        └── main.tf
```