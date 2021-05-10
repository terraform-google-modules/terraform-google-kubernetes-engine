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
ASM_CONFIG_OUTPUT_PATH=$5
MANAGED=${6:-false}
ENABLE_ALL=${7:-false}
ENABLE_CLUSTER_LABELS=${8:-false}
ENABLE_CLUSTER_ROLES=${9:-false}
ENABLE_GCP_APIS=${10:-false}
ENABLE_GCP_IAM_ROLES=${11:-false}
ENABLE_GCP_COMPONENTS=${12:-false}
ENABLE_REGISTRATION=${13:-false}
DISABLE_CANNONICAL_SERVICE=${14:-false}
CUSTOM_OVERLAY_FILE=${15}
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

# Add the --output_dir param if ASM_CONFIG_OUTPUT_PATH is not empty
if [[ -n "${ASM_CONFIG_OUTPUT_PATH}" ]]; then
    params+=("--output_dir ${ASM_CONFIG_OUTPUT_PATH}")
fi

# Add the --managed param if MANAGED is set to true
if [[ "${MANAGED}" == true ]]; then
    params+=("--managed")
fi

# Add the --enable_all param if ENABLE_ALL is set to true
# Otherwise the script will check value of all "ENABLE_*" variables and add them to the command line if they are set to true
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

# Add --disable_canonical_service param if DISABLE_CANNONICAL_SERVICE is set to true
if [[ "${DISABLE_CANNONICAL_SERVICE}" == true ]]; then
    params+=("--disable_canonical_service")
fi

# Add --custom_overlay param if file set with DISABLE_CANNONICAL_SERVICE variable exists
if [[ -f "${CUSTOM_OVERLAY_FILE}" ]]; then
    params+=("--custom_overlay ${CUSTOM_OVERLAY_FILE}")
fi

# Run the script with appropriate flags
echo "Running ./install_asm" "${params[@]}"

# Disable shell linting. Other forms will prevent the command to work
# shellcheck disable=SC2046,SC2116
./install_asm $(echo "${params[@]}")
