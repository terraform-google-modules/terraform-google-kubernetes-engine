#!/usr/bin/env bash
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
CLUSTER_LOCATION=$3
IMPERSONATE_SERVICE_ACCOUNT=$4

echo "Waiting for cluster $PROJECT/$CLUSTER_LOCATION/$CLUSTER_NAME to reconcile..."

while
    # if cluster location is set, use it in filter
  if [ -z "${CLUSTER_LOCATION}" ]; then
    current_status=$(gcloud container clusters list --project="$PROJECT" --filter="name=$CLUSTER_NAME" --format="value(status)" --impersonate-service-account="$IMPERSONATE_SERVICE_ACCOUNT")
  else
    current_status=$(gcloud container clusters list --project="$PROJECT" --filter="name=$CLUSTER_NAME AND location=$CLUSTER_LOCATION" --format="value(status)" --impersonate-service-account="$IMPERSONATE_SERVICE_ACCOUNT")
  fi
  if [ -z "${current_status}" ]; then
    echo "Unable to get status for $PROJECT/$CLUSTER_LOCATION/$CLUSTER_NAME"
    exit 1
  fi
  [[ "${current_status}" != "RUNNING" ]]
do printf ".";sleep 5; done

echo "Cluster is ready!"
