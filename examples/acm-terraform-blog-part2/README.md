# Enable ACM features with Terraform - Part 2

This is Part2 of the tutorial to accompany a short series of  blog articles explaining how to enable [Anthos Config Management (ACM)](https://cloud.google.com/anthos/config-management) with Terraform.

In the [previous article](../acm-terraform-blog-part1), we'll explain how to use Teraform to create a cluster and manage its config from git via [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview).

This article will build on that to add guard rails for the cluster via [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller). We will focus on enabling an ongoing audit of cluster resources using the Policy Controller's built in [Policy Library](http://cloud/anthos-config-management/docs/reference/constraint-template-library) and a bundle of constraints enforcings [CIS Kubernetes Benchmark v.1.5.1](https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks).

Subsequent articles will discuss other aspects of ACM to manage your GCP infrastrcuture.

## Enforce Cluster Guardrails with ACM Policy Controller

1. Set a variables for the project from [part1](../acm-terraform-blog-part1). We will re-use that project but create a new cluster since we cleaned up at the end of the first section. If you are working in a different project, enable required GCP APIs, as described in [part1/README.md](../part1/README.md).

    ```bash
    PROJECT_ID = [PROJECT_ID]
    ```

1. As before, cluster using terraform using defaults other than the project. The main difference in the [terraform](terraform) files is that we turn on [PolicyController](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) and also install the build in [Policy Libary](https://cloud.google.com/anthos-config-management/docs/reference/constraint-template-library).

    ```bash
    # obtain user access credentials to use for Terraform commands
    gcloud auth application-default login

    # continue in /terraform directory
    cd terraform
    export TF_VAR_project=$PROJECT_ID
    terraform init
    terraform plan
    terraform apply
    ```
    NOTE: if you get an error due to default network not being present, run `gcloud compute networks create default --subnet-mode=auto` and retry the commands.

1. To verify things have sync'ed and the policy controller is installed, you can again use `gcloud` to check status:

    ```bash
    gcloud alpha container hub config-management status --project $PROJECT_ID
    ```

    As things initialize, you may see a few transient `error: KNV1021: No CustomResourceDefinition is defined` messages. This occurs when constraints from the repo are sync'ed before Policy Controller has had a chance to load the appropriate template from the policy library. It will eventually reconcile.

    After a short time, in addition to the `Status` showing as `SYNCED` and the `Last_Synced_Token` matching the repo, there should also be a value of `INSTALLED` for `Policy_Controller`.

1. One difference you may notice from [part1](../acm-terraform-blog-part1) is that in the [config-root/cis-k8s-1.5.1](config-root/cis-k8s-1.5.1) directory. This is a bundle of Policy Controller constraints that were pulled into the repo from [acm-policy-controller-library repo](https://github.com/GoogleCloudPlatform/acm-policy-controller-library/tree/master/bundles/cis-k8s-1.5.1) using `kpt pkg get` command. Kpt is a helpful kubernetes config tool documented at [kpt.dev](https://kpt.dev/). We'll use Kpt tool directly in part3 of this tutorial. The goal of this bundle is to audit and enforce [CIS Benchmarks for Kubernetes](https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks). At the moment, they have been deployed in `dryrun` mode so we can use them to audit the cluster.

    To see the audit status first we get credentials for `kubectl` in the same way we did this in [part1](../acm-terraform-blog-part1):

    ```bash
    # get values from cluster that was created
    export CLUSTER_ZONE=$(terraform output -raw cluster_location)
    export CLUSTER_NAME=$(terraform output -raw cluster_name)

    # then get creditials for it
    gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID

    ```

    Now, let's look at the violations in the status of the constraints we have active. One handy way to do this is to dump the constraints in json so we can filter for violations using `jq`.

    ```bash
    kubectl get constraint -o json | jq -C '.items[]| select(.status.violations)| .kind,.status.violations'
    ```

    Seems like there is a LOT to clean up!

