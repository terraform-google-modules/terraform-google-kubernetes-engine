#!/usr/bin/env bash
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

is_configsync_ready() {
    # Check if config-management-system namespace exists
    kubectl --context "$1" get namespace config-management-system &> /dev/null
    export exit_code=$?
    while [ ! " ${exit_code} " -eq 0 ]
        do
            sleep 5
            echo -e "Waiting for namespace config-mangement-system in cluster $1 to be created..."
            kubectl --context "$1" get namespace config-management-system &> /dev/null
            export exit_code=$?
        done
    echo -e "Namespace config-management-system in cluster $1 created."

    # Once namespace is created, check if config-managment pods are ready
    kubectl --context "$1" -n config-management-system wait --timeout 60s --for=condition=Ready pod --all &> /dev/null
    export exit_code=$?

    while [ ! " ${exit_code} " -eq 0 ]
        do
            sleep 5
            echo -e "Waiting for config-management pods in cluster $1 to become ready..."
            kubectl --context "$1" -n config-management-system wait --timeout 60s --for=condition=Ready pod --all &> /dev/null
            export exit_code=$?
        done

    echo -e "Config-management pods in cluster $1 are ready."
    return
}

if [ "$#" -lt 3 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3
USE_EXISTING_CONTEXT=$4

# Check if we need to use the current context
if [ -z ${USE_EXISTING_CONTEXT+x} ]; then
    # GKE Cluster. Use the GKE cluster context
    is_configsync_ready gke_"${PROJECT_ID}"_"${CLUSTER_LOCATION}"_"${CLUSTER_NAME}"
else
    echo "USE_EXISTING_CONTEXT variable is set. Using current context to wait for deployment to be ready."
    # Get the current context. This can be used for non GKE Clusters
    CURRENT_CONTEXT=$(kubectl config current-context)
    is_configsync_ready "${CURRENT_CONTEXT}"
fi
