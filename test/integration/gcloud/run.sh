#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TEMPDIR=$(pwd)/test/integration/tmp
TESTDIR=${BASH_SOURCE%/*}
export TEST_ID="modules_gke_integration_gcloud_${RANDOM}"
export KUBECONFIG="${TEMPDIR}/${TEST_ID}.kubeconfig"

# Activate test working directory
function make_testdir() {
  mkdir -p "$TEMPDIR"
  cp -r "$TESTDIR"/* "$TEMPDIR"
}

# Activate test config
function activate_config() {
  # shellcheck disable=SC1091
  source config.sh
  echo "$PROJECT_NAME"
}

# Cleans the workdir
function clean_workdir() {
  #rm -rf "$TEMPDIR"

  export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=""
  unset CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE

}

# Creates the main.tf file for Terraform
function create_main_tf_file() {
  echo "Creating main.tf file"
  touch main.tf
  cat <<EOF > main.tf
locals {
  credentials_file_path    = "$CREDENTIALS_PATH"
}

provider "google" {
  credentials              = "\${file(local.credentials_file_path)}"
}

module "gke" {
  source = "../../../"
  region = "$REGION"
  kubernetes_version = "$KUBERNETES_VERSION"

  credentials_path = "\${local.credentials_file_path}"

  node_service_account = "$NODE_SERVICE_ACCOUNT"

  cluster_name        = "$CLUSTER_NAME"
  cluster_description = "Test GKE cluster"

  project_id = "$PROJECT_ID"
  network    = "$NETWORK"
  subnetwork = "$SUBNETWORK"

  network_policy = true

  ip_range_pods     = "$IP_RANGE_PODS"
  ip_range_services = "$IP_RANGE_SERVICES"

  stub_domains {
    "example.com" = [
      "10.254.154.11",
      "10.254.154.12",
    ]

    "testola.com" = [
      "10.254.154.11",
      "10.254.154.12",
    ]
  }

  ip_masq_non_masquerade_cidrs = [
    "10.0.0.0/8",
    "192.168.20.0/24",
    "192.168.21.0/24",
  ]

  node_pools = [
    {
      name         = "pool-01"
      machine_type = "n1-standard-1"
      image_type   = "COS"
      initial_node_count = 2
      min_count    = 1
      max_count    = 2
      auto_upgrade = false
      disk_size_gb = 30
      disk_type    = "pd-standard"
    },
  ]
  node_pools_labels = {
    all = {
      all_pools_label = "something"
    }

    pool-01 = {
      pool_01_label         = "yes"
      pool_01_another_label = "no"
    }
  }
  node_pools_taints = {
    all = [
      {
        key    = "all_pools_taint"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    pool-01 = [
      {
        key    = "pool_01_taint"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
      {
        key    = "pool_01_another_taint"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
  node_pools_tags = {
    all = [
      "all-node-network-tag",
    ]

    pool-01 = [
      "pool-01-network-tag",
    ]
  }
}
EOF
}

# Creates the outputs.tf file
function create_outputs_file() {
  echo "Creating outputs.tf file"
  touch outputs.tf
  cat <<'EOF' > outputs.tf
output "cluster_name_example" {
  value       = "${module.gke.cluster_name}"
}

output "region_example" {
  value       = "${module.gke.region}"
}

output "endpoint_example" {
  value       = "${module.gke.ca_certificate}"
}

output "ca_certificate_example" {
  value       = "${module.gke.ca_certificate}"
}

output "min_master_version_example" {
    value       = "${module.gke.min_master_version}"
}

output "master_version_example" {
    value       = "${module.gke.master_version}"
}

output "node_version_example" {
    value       = "${module.gke.node_version}"
}

output "http_load_balancing_example" {
    value       = "${module.gke.http_load_balancing_enabled}"
}

output "horizontal_pod_autoscaling_example" {
    value       = "${module.gke.horizontal_pod_autoscaling_enabled}"
}

output "kubernetes_dashboard_example" {
    value       = "${module.gke.kubernetes_dashboard_enabled}"
}

output "node_pools_names_example" {
    value       = "${module.gke.node_pools_names}"
}

EOF
}

# Execute bats tests
function run_bats() {
  # Call to bats
  echo "Tests to execute: $(bats integration.bats -c)"
  bats integration.bats
}

# Preparing environment
make_testdir
cd "$TEMPDIR" || exit
activate_config
create_main_tf_file
create_outputs_file

# Call to bats
run_bats

# # # Clean the environment
cd - || exit
clean_workdir
echo "Integration test finished"
