#!/usr/bin/env bats

# #################################### #
#             Terraform tests          #
# #################################### #

@test "Ensure that Terraform configures the dirs and download the plugins" {

  run terraform init
  [ "$status" -eq 0 ]
}

@test "Ensure that Terraform updates the plugins" {

  run terraform get
  [ "$status" -eq 0 ]
}

@test "Terraform plan, ensure connection and creation of resources" {

  run terraform plan
  [ "$status" -eq 0 ]
  [[ "$output" =~ 5\ to\ add ]]
  [[ "$output" =~ 0\ to\ change ]]
  [[ "$output" =~ 0\ to\ destroy ]]
}

@test "Terraform apply" {

  run terraform apply -auto-approve
  [ "$status" -eq 0 ]
  [[ "$output" =~ 5\ added ]]
  [[ "$output" =~ 0\ changed ]]
  [[ "$output" =~ 0\ destroyed ]]
}

@test "Terraform plan enable network policy" {

  run terraform plan
  [ "$status" -eq 0 ]
  [[ "$output" =~ 0\ to\ add ]]
  [[ "$output" =~ 1\ to\ change ]]
  [[ "$output" =~ 0\ to\ destroy ]]
}

@test "Terraform apply" {

  run terraform apply -auto-approve
  [ "$status" -eq 0 ]
  [[ "$output" =~ 0\ added ]]
  [[ "$output" =~ 1\ changed ]]
  [[ "$output" =~ 0\ destroyed ]]
}

# #################################### #
#             gcloud tests             #
# #################################### #

@test "Test the api is activated" {

  run gcloud --project=${PROJECT_ID} services list
  [ "$status" -eq 0 ]
  [[ "$output" = *"container.googleapis.com"* ]]
}

@test "Test the cluster is in running status" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json| jq -cre '.status'"
  [ "$status" -eq 0 ]
  [[ "$output" = "RUNNING" ]]
}

@test "Test the cluster has the expected initial cluster version" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.initialClusterVersion'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$KUBERNETES_VERSION" ]]
}

@test "Test the cluster is in the expected region" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.zone'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$REGION" ]]
}

@test "Test the cluster is on the expected network" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.network'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$NETWORK" ]]
}

@test "Test the cluster is on the expected subnetwork" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.subnetwork'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$SUBNETWORK" ]]
}

@test "Test the cluster has the expected secondary ip range for pods" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.ipAllocationPolicy.clusterSecondaryRangeName'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$IP_RANGE_PODS" ]]
}

@test "Test the cluster has the expected secondary ip range for services" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.ipAllocationPolicy.servicesSecondaryRangeName'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$IP_RANGE_SERVICES" ]]
}

@test "Test the cluster has the expected addon settings" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.addonsConfig'"
  [ "$status" -eq 0 ]
  [[ "$output" = "{\"horizontalPodAutoscaling\":{},\"httpLoadBalancing\":{\"disabled\":true},\"kubernetesDashboard\":{},\"networkPolicyConfig\":{}}" ]]
}

@test "Test default pool has no initial node count" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"default-pool\") | .initialNodeCount'"
  [ "$status" -eq 1 ]
  [[ "$output" = "null" ]]
}

@test "Test default pool has not auto scaling enabled" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"default-pool\") | .autoscaling.enabled'"
  [ "$status" -eq 1 ]
  [[ "$output" = "null" ]]
}

@test "Test pool-01 is expected version" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .version'"
  [ "$status" -eq 0 ]
  [[ "$output" = "$KUBERNETES_VERSION" ]]
}

@test "Test pool-01 has auto scaling enabled" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .autoscaling.enabled'"
  [ "$status" -eq 0 ]
  [[ "$output" = "true" ]]
}

@test "Test pool-01 has expected min node count" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .autoscaling.minNodeCount'"
  [ "$status" -eq 0 ]
  [[ "$output" = "1" ]]
}

@test "Test pool-01 has expected max node count" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .autoscaling.maxNodeCount'"
  [ "$status" -eq 0 ]
  [[ "$output" = "2" ]]
}

@test "Test pool-01 is expected machine type" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .config.machineType'"
  [ "$status" -eq 0 ]
  [[ "$output" = "n1-standard-1" ]]
}

@test "Test pool-01 has expected disk size" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .config.diskSizeGb'"
  [ "$status" -eq 0 ]
  [[ "$output" = "30" ]]
}

@test "Test pool-01 has expected labels" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .config.labels'"
  [ "$status" -eq 0 ]
  [[ "$output" = "{\"all_pools_label\":\"something\",\"cluster_name\":\"$CLUSTER_NAME\",\"node_pool\":\"pool-01\",\"pool_01_another_label\":\"no\",\"pool_01_label\":\"yes\"}" ]]
}

@test "Test pool-01 has expected network tags" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .config.tags'"
  [ "$status" -eq 0 ]
  [[ "$output" = "[\"gke-$CLUSTER_NAME\",\"gke-$CLUSTER_NAME-pool-01\",\"all-node-network-tag\",\"pool-01-network-tag\"]" ]]
}

@test "Test pool-01 has auto repair enabled" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .management.autoRepair'"
  [ "$status" -eq 0 ]
  [[ "$output" = "true" ]]
}

@test "Test pool-01 has auto upgrade disabled" {

  run bash -c "gcloud --project=${PROJECT_ID} container clusters --region=${REGION} describe ${CLUSTER_NAME} --format=json | jq -cre '.nodePools[] | select(.name == \"pool-01\") | .management.autoUpgrade'"
  [ "$status" -eq 1 ]
  [[ "$output" = "null" ]]
}

@test "Test getting kubectl credentials" {

  run gcloud --project=${PROJECT_ID} container clusters --region=${REGION} get-credentials ${CLUSTER_NAME}
  [ "$status" -eq 0 ]
  [[ "$output" = *"kubeconfig entry generated for ${CLUSTER_NAME}."* ]]
}

# #################################### #
#            kubectl tests             #
# #################################### #

@test "Test pool-01 has expected taints" {

  run bash -c "kubectl get nodes -o json -l node_pool=pool-01 | jq -cre '.items[0].spec.taints'"
  [ "$status" -eq 0 ]
  [[ "$output" = "[{\"effect\":\"PreferNoSchedule\",\"key\":\"all_pools_taint\",\"value\":\"true\"},{\"effect\":\"PreferNoSchedule\",\"key\":\"pool_01_taint\",\"value\":\"true\"},{\"effect\":\"PreferNoSchedule\",\"key\":\"pool_01_another_taint\",\"value\":\"true\"}]" ]]
}

@test "Test kube dns configmap created" {

  run bash -c "kubectl -n kube-system get configmap -o json kube-dns | jq -cre '.metadata.labels.maintained_by'"
  [ "$status" -eq 0 ]
  [[ "$output" = "terraform" ]]
}

@test "Test ip masq agent configmap created" {

  run bash -c "kubectl -n kube-system get configmap -o json ip-masq-agent | jq -cre '.metadata.labels.maintained_by'"
  [ "$status" -eq 0 ]
  [[ "$output" = "terraform" ]]
}

# #################################### #
#         Terraform plan test          #
# #################################### #

@test "Terraform plan, ensure no change" {

  run terraform plan
  [ "$status" -eq 0 ]
  [[ "$output" = *"No changes. Infrastructure is up-to-date."* ]]
}

# #################################### #
#      Terraform destroy test          #
# #################################### #

@test "Terraform destroy" {

  run terraform destroy -force
  [ "$status" -eq 0 ]
  [[ "$output" =~ 5\ destroyed ]]
}
