# Enable ACM features with Terraform - Part 1

This is Part1 of the tutorial to accompany a short series of  blog articles explaining how to enable [Anthos Config Management (ACM)](https://cloud.google.com/anthos/config-management) with Terraform.

In this tutorial, we'll explain how to use Teraform to create a cluster and manage its config from git via [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview).

[Next part](../acm-terraform-blog-part2) will build on that to add guard rails for the cluster via [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller). We will focus on enabling an ongoing audit of cluster resources using the Policy Controller's built in [Policy Library](http://cloud/anthos-config-management/docs/reference/constraint-template-library) and a bundle of constraints enforcings [CIS Kubernetes Benchmark v.1.5.1](https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks).

Subsequent articles will discuss other aspects of ACM to manage your GCP infrastrcuture.

## Enable Config Sync on the cluster with Terraform

1. Clone this repo
1. Set variables that will be used in multiple commands:

    ```bash
    FOLDER_ID = [FOLDER]
    BILLING_ACCOUNT = [BILLING_ACCOUNT]
    PROJECT_ID = [PROJECT_ID]
    ```

1. Create project:

    ```bash
    gcloud auth login
    gcloud projects create $PROJECT_ID --name=$PROJECT_ID --folder=$FOLDER_ID
    gcloud alpha billing projects link $PROJECT_ID --billing-account $BILLING_ACCOUNT
    gcloud config set project $PROJECT_ID
    ```

1. Create cluster using terraform using defaults other than the project:

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

1. To verify things have sync'ed, you can use `gcloud` to check status:

    ```bash
    gcloud alpha container hub config-management status --project $PROJECT_ID
    ```

    In the output, notice that the `Status` will eventually show as `SYNCED` and the `Last_Synced_Token` will match the repo hash.

1. To see wordpress itself, you can use the kubectl proxy to connect to the service:

    ```bash
    # get values from cluster that was created
    export CLUSTER_ZONE=$(terraform output -raw cluster_location)
    export CLUSTER_NAME=$(terraform output -raw cluster_name)

    # then get creditials for it and proxy to the wordpress service to see it running
    gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID
    kubectl proxy --port 8888 &

    # curl or use the browser
    curl http://127.0.0.1:8888/api/v1/namespaces/wp/services/wordpress/proxy/wp-admin/install.php

    ```

1. Finally, let's clean up. First, don't forget to foreground the proxy again to kill it. Also, apply `terraform destroy` to remove the GCP resources that were deployed to the project.

   ```bash
    fg # ctrl-c

    terraform destroy -var=project=$PROJECT_ID
    ```
