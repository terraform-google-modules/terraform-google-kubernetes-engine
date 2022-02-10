# Enable ACM features with Terraform - Part 3

This is part three of the tutorial to accompany a short series of blog articles explaining how to enable [Anthos Config Management (ACM)](https://cloud.google.com/anthos/config-management) with Terraform.

In the [first part](../acm-terraform-blog-part1), we explained how to use Terraform to create a cluster and manage its config from git via [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview).

In the [second part](../acm-terraform-blog-part2) we added guard rails for the cluster configuration via [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller).

In this article we'll demonstrate how, using Config Connector, you can provision your GCP cloud resources following the same Kubernetes-native model.

## Provision GCP resources

1. Set the variable for the project from [part two](../acm-terraform-blog-part2). We will re-use that project but create a new cluster since we cleaned up at the end of the first section. If you are working in a different project, enable required GCP APIs, as described in [part one](../part1/README.md).

    ```bash
    PROJECT_ID = [PROJECT_ID]
    ```
1. Note that [wordpress-bundle.yaml](./config-root/wordpress-bundle) was updated to use GCP MySQL database. Also we added [configconnector.yaml](./config-root/configconnector.yaml) to initialize the instance of Config Connector add-on on the cluster.

1. Use [kpt](https://kpt.dev) to customize the `config-root` directory that will be configured as the source of the objects installed on the cluster.

    ```bash
    kpt fn eval --include-meta-resources --image gcr.io/kpt-fn/set-project-id:v0.1 ./config-root -- "project-id=$PROJECT_ID"
    kpt fn render ./config-root
    ```
1. Submit the updated configuration into your branch.
1. Ensure that `sync_repo` and `sync_branch` variables are updated in [terraform.tfvars](./terraform/terraform.tfvars)
1. Before running Terraform, notice the changes in [gke.tf](./terraform/gke.tf):
     - We are using the `[beta-public-cluster](../modules/beta-public-cluster)` module
     - `config_connector` variable is set to true
     - We are using `workload-identity` module to create a Google Service Account and connect it to a Kubernetes Service Account that is running in Config Connector `cnrm-system` namespace, allowing Config Connector to create GCP resource.
1. As as in the previous part, create the cluster using Terraform:

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
    NOTE: if you get an error due to the default network not being present, run `gcloud compute networks create default --subnet-mode=auto` and retry the commands.

1. To verify things have synced and Policy Controller is installed, you can again use `gcloud` to check status:

    ```bash
    gcloud alpha container hub config-management status --project $PROJECT_ID
    ```

    As things initialize, you may see a few transient `error: KNV1021: No CustomResourceDefinition is defined` messages. This occurs when constraints from the repo are synced before Policy Controller has had a chance to load the appropriate template from the policy library. It will eventually reconcile.

    After a short time, in addition to the `Status` showing as `SYNCED` and the `Last_Synced_Token` matching the repo, there should also be a value of `INSTALLED` for `Policy_Controller`.


1. Connect your kubectl instance to the newly created cluster:

    ```bash
    # get values from cluster that was created
    export CLUSTER_ZONE=$(terraform output -raw cluster_location)
    export CLUSTER_NAME=$(terraform output -raw cluster_name)

    # then get creditials for it
    gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID

    ```

1. Verify that Config Connector addon is installed and configured:
    ```bash
    kubectl wait -n cnrm-system --for=condition=Ready pod --all
    ```

    Note: The controller Pod can take several minutes to start. Once Config Connector is installed correctly, the output is similar to the following:

    ```bash
    pod/cnrm-controller-manager-0 condition met
    ```
1.  It will take a while for the SQL database to be created. You can check on the status:
    ```bash
    kubectl describe sqlinstance -n wp
    ```

1.  Finally, validate that Wordpress powered Cloud SQL database was created:

    ```bash
    curl -L $( kubectl get service wordpress-external -n wp -o=json | \
            jq -r '.status["loadBalancer"]["ingress"][0]["ip"]')
