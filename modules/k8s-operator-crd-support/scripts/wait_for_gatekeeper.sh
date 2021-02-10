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

is_deployment_ready() {
    kubectl --context "$1" -n "$2" get deploy "$3" &> /dev/null
    export exit_code=$?
    while [ ! " ${exit_code} " -eq 0 ]
        do
            sleep 5
            echo -e "Waiting for deployment $3 in cluster $1 to be created..."
            kubectl --context "$1" -n "$2" get deploy "$3" &> /dev/null
            export exit_code=$?
        done
    echo -e "Deployment $3 in cluster $1 created."

    # Once deployment is created, check for deployment status.availableReplicas is greater than 0
    availableReplicas=$(kubectl --context "$1" -n "$2" get deploy "$3" -o json | jq -r '.status.availableReplicas')
    while [[ " ${availableReplicas} " == " null " ]]
        do
            sleep 5
            echo -e "Waiting for deployment $3 in cluster $1 to become ready..."
            availableReplicas=$(kubectl --context "$1" -n "$2" get deploy "$3" -o json | jq -r '.status.availableReplicas')
        done

    echo -e "$3 in cluster $1 is ready with replicas ${availableReplicas}."
    return "${availableReplicas}"
}

is_service_ready() {
    kubectl --context "$1" -n "$2" get service "$3" &> /dev/null
    export exit_code=$?
    while [ ! " ${exit_code} " -eq 0 ]
        do
            sleep 5
            echo -e "Waiting for service $3 in cluster $1 to be created..."
            kubectl --context "$1" -n "$2" get service "$3" &> /dev/null
            export exit_code=$?
        done
    echo -e "Service $3 in cluster $1 created."

    # Once service is created, check endpoints is greater than 0
    kubectl --context "$1" -n "$2" get endpoints "$3"
    export exit_code=$?

    while [ ! " ${exit_code} " -eq 0 ]
        do
            sleep 5
            echo -e "Waiting for endpoints for service $3 in cluster $1 to become ready..."
            kubectl --context "$1" -n "$2" get endpoints "$3"
            export exit_code=$?
        done

    echo -e "Service $3 in cluster $1 is ready with endpoints."
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

# Gatekeeper causes issues if not ready

# Check if we need to use the current context
if [ -z ${USE_EXISTING_CONTEXT+x} ]; then
    # GKE Cluster. Use the GKE cluster context
    is_deployment_ready gke_"${PROJECT_ID}"_"${CLUSTER_LOCATION}"_"${CLUSTER_NAME}" gatekeeper-system gatekeeper-controller-manager
    is_service_ready gke_"${PROJECT_ID}"_"${CLUSTER_LOCATION}"_"${CLUSTER_NAME}" gatekeeper-system gatekeeper-webhook-service
else
    echo "USE_EXISTING_CONTEXT variable is set. Using current context to wait for deployment to be ready."
    # Get the current context. This can be used for non GKE Clusters
    CURRENT_CONTEXT=$(kubectl config current-context)
    is_deployment_ready "${CURRENT_CONTEXT}" gatekeeper-system gatekeeper-controller-manager
    is_service_ready "${CURRENT_CONTEXT}" gatekeeper-system gatekeeper-webhook-service
fi
