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

set -e

PROJECT=$1
CLUSTER_NAME=$2
gcloud_command="gcloud container clusters list --project=$PROJECT --format=json"
jq_query=".[] | select(.name==\"$CLUSTER_NAME\") | .status"

function check_cluster_readiness() {
    current_status=$($gcloud_command | jq -r "$jq_query")
    echo "Current status is ${current_status}"
    while [[ "${current_status}" == "RECONCILING" ]]; do
        printf "."
        sleep 5
        current_status=$($gcloud_command | jq -r "$jq_query")
    done
}

echo "Waiting for cluster $2 in project $1 to reconcile..."
check_cluster_readiness

# a second check is needed as the READY state can flap back to RECONCILING on
# new clusters: https://github.com/GoogleCloudPlatform/gke-stateful-applications-demo/blob/3261509a3dbb9f0b4c9538f462469669116fb689/README.md#troubleshooting
echo "Confirming RUNNING state in 60 seconds..."
sleep 60
check_cluster_readiness
echo "Cluster is ready!"
