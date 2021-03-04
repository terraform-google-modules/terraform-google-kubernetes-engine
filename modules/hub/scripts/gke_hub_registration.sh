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

set -e

if [ "$#" -lt 5 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

GKE_CLUSTER_FLAG=$1
MEMBERSHIP_NAME=$2
SERVICE_ACCOUNT_KEY=$3
CLUSTER_URI=$4
HUB_PROJECT_ID=$5
LABELS=$6

#write temp key, cleanup at exit
tmp_file=$(mktemp)
# shellcheck disable=SC2064
trap "rm -rf $tmp_file" EXIT
base64 --help | grep "\--decode" && B64_ARG="--decode" || B64_ARG="-d"
echo "${SERVICE_ACCOUNT_KEY}" | base64 ${B64_ARG} > "$tmp_file"

if [[ ${GKE_CLUSTER_FLAG} == 1 ]]; then
    echo "Registering GKE Cluster."
    gcloud container hub memberships register "${MEMBERSHIP_NAME}" --gke-uri="${CLUSTER_URI}" --service-account-key-file="${tmp_file}" --project="${HUB_PROJECT_ID}" --quiet
else
    echo "Registering a non-GKE Cluster. Using current-context to register Hub membership."
    #Get the kubeconfig
    CONTEXT=$(kubectl config current-context)
    gcloud container hub memberships register "${MEMBERSHIP_NAME}" --context="${CONTEXT}" --service-account-key-file="${tmp_file}" --project="${HUB_PROJECT_ID}" --quiet
fi


# Add labels to the registered cluster
if [ -z ${LABELS+x} ]; then
    echo "No hub labels to apply."
else
    gcloud container hub memberships update "${MEMBERSHIP_NAME}" --update-labels "$LABELS" --project="${HUB_PROJECT_ID}"
fi
