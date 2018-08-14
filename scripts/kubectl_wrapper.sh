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

PROJECT_ID=$1
CREDENTIALS=$2
LOCATION=$3
CLUSTER_NAME=$4

shift 4

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS

RANDOM_ID="${RANDOM}_${RANDOM}"
export TMPDIR="/tmp/kubectl_wrapper_${CLUSTER_NAME}_${RANDOM_ID}"

function cleanup {
    rm -rf "${TMPDIR}"
    echo "CLEANUP"
}
trap cleanup EXIT

mkdir "${TMPDIR}"

export KUBECONFIG="${TMPDIR}/config"

gcloud --project="${PROJECT_ID}" container clusters --zone="${LOCATION}" get-credentials "${CLUSTER_NAME}"

"$@"
