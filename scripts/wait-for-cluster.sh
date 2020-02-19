#!/bin/bash
# Copyright 2019 Google LLC
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

# shellcheck disable=SC2034
if [ -n "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
    export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="${GOOGLE_APPLICATION_CREDENTIALS}"
fi

PROJECT=$1
CLUSTER_NAME=$2

echo "Waiting for cluster $CLUSTER_NAME in project $PROJECT to reconcile..."

current_status=$(gcloud container clusters list --project="$PROJECT" --filter=name:"$CLUSTER_NAME" --format="value(status)")

while [[ "$current_status" == "RECONCILING" ]]; do
    printf "."
    sleep 5
    current_status=$(gcloud container clusters list --project="$PROJECT" --filter=name:"$CLUSTER_NAME" --format="value(status)")
done

echo "Cluster is ready!"
