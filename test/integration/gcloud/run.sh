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

function export_vars() {
  export CLUSTER_TYPE="$1"
  export TEST_ID="modules_gke_integration_gcloud_${RANDOM}"
  export KUBECONFIG="${TEMPDIR}/${CLUSTER_TYPE}/${TEST_ID}.kubeconfig"
  if [[ $CLUSTER_TYPE = "regional" ]]; then
    export CLUSTER_REGIONAL="true"
    export CLUSTER_LOCATION="$REGIONAL_CLUSTER_LOCATION"
    export CLUSTER_NAME="$REGIONAL_CLUSTER_NAME"
    export IP_RANGE_PODS="$REGIONAL_IP_RANGE_PODS"
    export IP_RANGE_SERVICES="$REGIONAL_IP_RANGE_SERVICES"
  else
    export CLUSTER_REGIONAL="false"
    export CLUSTER_LOCATION="$ZONAL_CLUSTER_LOCATION"
    export CLUSTER_NAME="$ZONAL_CLUSTER_NAME"
    export IP_RANGE_PODS="$ZONAL_IP_RANGE_PODS"
    export IP_RANGE_SERVICES="$ZONAL_IP_RANGE_SERVICES"
    export ZONE="$ZONAL_ZONE"
    export ADDITIONAL_ZONES="$ZONAL_ADDITIONAL_ZONES"
  fi
}

# Activate test working directory
function make_testdir() {
  CLUSTER_TYPE="$1"
  mkdir -p "${TEMPDIR}/${CLUSTER_TYPE}"
  cp -r "${TESTDIR}"/* "${TEMPDIR}/${CLUSTER_TYPE}/"
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
  cat <<EOF > main.tf
locals {
  credentials_file_path    = "$CREDENTIALS_PATH"
}

provider "google" {
  credentials              = "\${file(local.credentials_file_path)}"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://\${module.gke.endpoint}"
  token                  = "\${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "\${base64decode(module.gke.ca_certificate)}"
}

data "google_client_config" "default" {}

module "gke" {
  source               = "../../../../"
  project_id           = "$PROJECT_ID"
  name                 = "$CLUSTER_NAME"
  description          = "Test GKE cluster"
  regional             = $CLUSTER_REGIONAL
  region               = "$REGION"
  zone                 = "$ZONE"
  additional_zones     = [$ADDITIONAL_ZONES]
  kubernetes_version   = "$KUBERNETES_VERSION"
  node_service_account = "$NODE_SERVICE_ACCOUNT"
  network              = "$NETWORK"
  subnetwork           = "$SUBNETWORK"
  ip_range_pods        = "$IP_RANGE_PODS"
  ip_range_services    = "$IP_RANGE_SERVICES"

  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true

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

  non_masquerade_cidrs = [
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

resource "kubernetes_pod" "nginx-example" {
  metadata {
    name = "nginx-example"

    labels {
      maintained_by = "terraform"
      app           = "nginx-example"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "nginx-example"
    }
  }

  depends_on = ["module.gke"]
}

resource "kubernetes_service" "nginx-example" {
  metadata {
    name = "terraform-example"
  }

  spec {
    selector {
      app = "\${kubernetes_pod.nginx-example.metadata.0.labels.app}"
    }

    session_affinity = "ClientIP"

    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }

  depends_on = ["module.gke"]
}

EOF
}

# Creates the outputs.tf file
function create_outputs_file() {
  echo "Creating outputs.tf file"
  cat <<'EOF' > outputs.tf
output "name_example" {
  value       = "${module.gke.name}"
}

output "location_example" {
  value       = "${module.gke.location}"
}

output "region_example" {
  value       = "${module.gke.region}"
}

output "zones_example" {
  value       = "${module.gke.zones}"
}

output "endpoint_example" {
  value       = "${module.gke.endpoint}"
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

output "network_policy_example" {
  value = "${module.gke.network_policy_enabled}"
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

# For use in integration tests
output "module_path" {
    value       = "${path.module}/../../../../"
}

output "client_token" {
    value       = "${base64encode(data.google_client_config.default.access_token)}"
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
make_testdir regional
make_testdir zonal

cd "$TEMPDIR/regional" || exit
activate_config
export_vars regional
create_main_tf_file regional
create_outputs_file regional
run_bats

cd "$TEMPDIR/zonal" || exit
activate_config
export_vars zonal
create_main_tf_file zonal
create_outputs_file zonal
run_bats

# # # Clean the environment
cd - || exit
clean_workdir
echo "Integration test finished"
