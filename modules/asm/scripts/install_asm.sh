#!/usr/bin/env bash

# Copyright 2021 Google LLC
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
MANAGED=${5:-false}
ENABLE_ALL=${6:-false}
ENABLE_CLUSTER_LABELS=${7:-false}
ENABLE_CLUSTER_ROLES=${8:-false}
ENABLE_GCP_APIS=${9:-false}
ENABLE_GCP_IAM_ROLES=${10:-false}
ENABLE_GCP_COMPONENTS=${11:-false}
ENABLE_REGISTRATION=${12:-false}
DISABLE_CANNONICAL_SERVICE=${13:-false}
MODE="install"

# Download the correct version of the install_asm script
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_VERSION}" > install_asm
chmod u+x install_asm

declare -a params=(
    "--verbose"
    "--project_id ${PROJECT_ID}"
    "--cluster_name ${CLUSTER_NAME}"
    "--cluster_location ${CLUSTER_LOCATION}"
    "--mode ${MODE}"
)

# Add the --managed param if MANAGED is set to true
if [[ "${MANAGED}" == true ]]; then
    params+=("--managed")
fi

if [[ "${ENABLE_ALL}" == true ]]; then
    params+=("--enable_all")
else
    if [[ "${ENABLE_CLUSTER_LABELS}" == true ]]; then
        params+=("--enable_cluster_labels")
    fi
    if [[ "${ENABLE_CLUSTER_ROLES}" == true ]]; then
        params+=("--enable_cluster_roles")
    fi
    if [[ "${ENABLE_GCP_APIS}" == true ]]; then
        params+=("--enable_gcp_apis")
    fi
    if [[ "${ENABLE_GCP_IAM_ROLES}" == true ]]; then
        params+=("--enable_gcp_iam_roles")
    fi
    if [[ "${ENABLE_GCP_COMPONENTS}" == true ]]; then
        params+=("--enable_gcp_components")
    fi
    if [[ "${ENABLE_REGISTRATION}" == true ]]; then
        params+=("--enable_registration")
    fi
fi

if [[ "${DISABLE_CANNONICAL_SERVICE}" == true ]]; then
    params+=("--disable_canonical_service")
fi

# Run the script with appropriate flags
echo "Running ./install_asm" "${params[@]}"

# Disable shell linting. Other forms will prevent the command to work
# shellcheck disable=SC2046,SC2116
./install_asm $(echo "${params[@]}")
