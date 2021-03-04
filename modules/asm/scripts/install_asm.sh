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

if [ "$#" -lt 4 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3
ASM_VERSION=$4
MODE="install"

#download the correct version of the install_asm script
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_VERSION}" > install_asm
chmod u+x install_asm

#run the script with appropriate flags
./install_asm --verbose --project_id "${PROJECT_ID}" --cluster_name "${CLUSTER_NAME}" --cluster_location "${CLUSTER_LOCATION}" --mode "${MODE}" --enable_cluster_labels --enable_cluster_roles
