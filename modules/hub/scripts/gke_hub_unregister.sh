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

if [ "$#" -lt 4 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

GKE_CLUSTER_FLAG=$1
MEMBERSHIP_NAME=$2
CLUSTER_URI=$3
HUB_PROJECT_ID=$4

if [[ ${GKE_CLUSTER_FLAG} == 1 ]]; then
    echo "Un-Registering GKE Cluster."
    gcloud container hub memberships unregister "${MEMBERSHIP_NAME}" --gke-uri="${CLUSTER_URI}" --project "${HUB_PROJECT_ID}"
else
    echo "Un-Registering a non-GKE Cluster. Using current-context to unregister Hub membership."
    #Get Current context
    CONTEXT=$(kubectl config current-context)
    gcloud container hub memberships unregister "${MEMBERSHIP_NAME}" --context="${CONTEXT}" --project="${HUB_PROJECT_ID}"
fi
