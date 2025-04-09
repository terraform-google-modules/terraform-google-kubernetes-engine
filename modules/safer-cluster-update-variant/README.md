# Safer Cluster: How to setup a GKE Kubernetes cluster with reduced exposure

This module defines an opinionated setup of GKE
cluster. We outline project configurations, cluster settings, and basic K8s
objects that permit a safer-than-default configuration.

## Module Usage

The module fixes a set of parameters to values suggested in the
[GKE hardening guide](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster),
the CIS framework, and other best practices.

The motivation for each setting, and its relation to harderning guides or other recommendations
is outline in `main.tf` as comments over individual settings. When security-relevant settings
are available for configuration, recommendations on their settings are documented in the `variables.tf` file.

## Project Setup and Cloud IAM policy for GKE

### Applications and Clusters

-   Different applications that access data with different sensitivity and do
    not need to communicate with each other (e.g., dev and prod instances of the
    same application) should be placed in different clusters.

    -   This approach will limit the blast radius of errors. An security problem
        in dev shouldn't impact production data.

-   If applications need to communicate (e.g., a frontend system calling
    a backend), we suggest placing the two applications in the same cluster, in
    different namespaces.

    -   Placing them in the same cluster will provide fast network
        communication, and the different namespaces will be configured to
        provide some administrative isolation. Istio will be used to encrypt and
        control communication between applications.

-   We suggest to store user or business data persistently in managed storage
    services that are inventoried and controlled by centralized teams.
    (e.g., GCP storage services within a GCP organization).

    -   Storing user or business data securely requires satisfying a large set of
        requirements, such as data inventory, which might be harder to satisfy at
        scale when data is stored opaquely within a cluster. Services like Cloud
        Asset Inventory provide centralized teams ability to enumerate data stores.

### Project Setup

We suggest a GKE setup composed of multiple projects to separate responsibilities
between cluster operators, which need to administer the cluster; and product
developers, which mostly just want to deploy and debug applications.

-   *Cluster Projects (`project_id`):* GKE clusters storing sensitive data should have their
    own projects, so that they can be administered independently (e.g., dev cluster;
    production clusters; staging clusters should go in different projects.)

-   *Shared GCR projects (`registry_project_ids`):* all clusters can share the same
    GCR projects.

    -   Easier to share images between environments. The same image could be
        progressively rolled-out in dev, staging, and then production.
    -   Easier to manage service account permissions: GCR requires authorizing
        service accounts to access certain buckets, which are created only after
        images are published. When the only service run by the project is GCR,
        we can safely give project-wide read permissions to all buckets.

-   (optional) *Data Projects:* When the same cluster is shared by different
    applications managed by different teams, we suggest separating the data for
    each application by placing storage resources for each team in different
    projects (e.g., a Spanner instance for application A in one project, GCS
    bucket for application B in a different project).

    -   This permits to control administrative access to the data more tightly,
        as Cloud IAM policies for accessing the data can be managed by each
        application team, rather than the team managing the cluster
        infrastructure.

Exception to such a setup:

-   When not using Shared VPCs, resources that require direct network connectivity
    (e.g., a Cloud SQL instance), need to be placed in the same VPC (hence, project)
    as the clusters from which connections are made.

### Google Service Accounts

We use GKE Workload Identity (BETA) to associate a GCP identity to each workload,
and limit the permissions associated with the cluster nodes.

The Safer Cluster setup relies on several service accounts:

-   The module generates a service account to run nodes. Such a service account
    has only permissions of sending logging data, metrics, and downloading containers
    from the given GCR project. The following settings in the module will create
    a service account with the above properties:

```
create_service_account = true
registry_project_ids = [<the project id for your GCR project>]
grant_registry_access = true
```

-   A service account *for each application* running on the cluster (e.g.,
    `myproduct-sa@myproduct-prod.iam.gserviceaccount.com`). These service
    accounts should be associated to the permissions required for running the
    application, such as access to databases.

```
- email: myproduct
  displayName: Google Service Account for containers running in the myproduct k8s namespace
  policy:
    # GKE workload identity authorization. This authorizes the Kubernetes Service Account
    # myproduct/default from this project's identity namespace to impersonate the service account.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
    bindings:
    - members:
      - serviceAccount:product-prod.svc.id.goog[myproduct/default]
      role: roles/iam.workloadIdentityUser
```

We suggest running different applications in different namespaces within the cluster. Each namespace
should be assigned to its own GCP service account to better define the Cloud IAM permissions required
for the application.

If you are using more than 2 projects in your setup, you can consider creating
the service account in a different project to keep application and
infrastructure separate. For example, service accounts could be created in each team's project,
while the cluster runs in a centrally controlled project.

<section class="zippy">
*Why?*

Separating the permissions associated with the infrastructure GKE nodes and the
application provides a simpler way to scale up the cluster: multiple applications
could be run in the same cluster, and each of them can run with tailored permissions
that limit the impact of compromises.

Such a separation of identities is enabled by a GKE feature called Workload
Identity. The feature provides additional advantages such as a better protection
of the node's metadata server against attackers.

</section>

### Cloud IAM Permissions for the GKE Cluster

We suggest to mainly rely on Kubernetes RBAC to manage access control, and use
Cloud IAM to give users only the ability of configuring `kubectl` credentials.

Engineers operating applications on the cluster should only be assigned the
Cloud IAM permission `roles/container.clusterViewer`. This role allows them to
obtain credentials for the cluster, but provides no further access to the
cluster objects. All cluster objects are protected by RBAC configurations,
defined below.

<section class="zippy">
*Why?*

Both Cloud IAM and RBAC can be used to control access to GKE clusters. Those two
systems are combined as a "OR": an action is authorized if the necessary
permissions are provided by either RBAC _OR_ Cloud IAM

However, Cloud IAM permissions are defined for a project: user get assigned the
same permissions over all clusters and all namespaces within each cluster. Such
a setup makes it hard to separate responsibilities between teams in charge of
managing clusters, and teams in charge of products.

By relying on RBAC instead of Cloud IAM, we have a finer-grained control of the
permissions provided to engineers, and permits to restrict permissions to only
certain namespaces.

</section>

You can add the following binding to the `myproduct-prod` project.

```
- members:
  role: roles/container.clusterViewer`
  - group:<produdct team group>
  - group:<cluster team group>
```

The permissions won't allow engineers to SSH into nodes as part of the regular
development workflow. Such permissions should be granted only to the cluster
team, and used only in case of emergency.

While RBAC permissions should be sufficient for most cases, we also suggest to
create an emergency superuser role that can be used, given a proper
justification, for resolving cases where regular permissions are insufficient.
For simplicity, we suggest using `roles/container.admin` and
`roles/compute.admin`, until more narrow roles can be defined given your usage.

```
- members:
  role: roles/container.admin
  - group:<oncall for cluster tean>
- members:
  role: roles/compute.admin
  - group:<oncall for cluster tean>
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
