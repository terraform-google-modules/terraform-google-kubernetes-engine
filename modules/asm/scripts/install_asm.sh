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

PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3
ASM_VERSION=$4
MODE=$5
SKIP_VALIDATION=$6
OPTIONS_LIST=$7
CUSTOM_OVERLAYS_LIST=$8
ENABLE_ALL=$9
OUTDIR=${10}
CA=${11}
CA_CERT=${12}
CA_KEY=${13}
ROOT_CERT=${14}
CERT_CHAIN=${15}

# Set SKIP_VALIDATION variable
if [[ ${SKIP_VALIDATION} = "true" ]]; then 
    export _CI_NO_VALIDATE=1
else 
    export _CI_NO_VALIDATE=0
fi

# Create bash arrays from options and custom_overlays lists
if [[ ${OPTIONS_LIST} ]]; then
    IFS=',' read -r -a OPTIONS <<< "${OPTIONS_LIST}"
fi

if [[ ${CUSTOM_OVERLAYS_LIST} ]]; then
    IFS=',' read -r -a CUSTOM_OVERLAYS <<< "${CUSTOM_OVERLAYS_LIST}"
fi

# Echo all values
echo -e "MODE is $MODE"
echo -e "ASM_VERSION is $ASM_VERSION"
echo -e "SKIP_VALIDATION is $SKIP_VALIDATION"
echo -e "_CI_NO_VALIDATE is $_CI_NO_VALIDATE"
echo -e "OPTIONS is ${OPTIONS[@]}"
echo -e "OPTIONS array length is ${#OPTIONS[@]}"
# Create options command snippet
item="${OPTIONS[@]}";OPTIONS_COMMAND=$(echo "--option" ${item// / --option })
echo -e "OPTIONS_COMMAND is $OPTIONS_COMMAND"
echo -e "CUSTOM_OVERLAYS is ${CUSTOM_OVERLAYS[@]}"
echo -e "CUSTOM_OVERLAYS array length is ${#CUSTOM_OVERLAYS[@]}"
# Create custom_overlays command snippet
item="${CUSTOM_OVERLAYS[@]}";CUSTOM_OVERLAYS_COMMAND=$(echo "--custom_overlay" ${item// / --custom_overlay })
echo -e "CUSTOM_OVERLAYS_COMMAND is $CUSTOM_OVERLAYS_COMMAND"
echo -e "ENABLE_ALL is $ENABLE_ALL"
echo -e "OUTDIR is $OUTDIR"

#download the correct version of the install_asm script
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_VERSION}" > install_asm_"${ASM_VERSION}"
chmod u+x install_asm_"${ASM_VERSION}"

# Craft options section for install_asm
if [[ "${OPTIONS_COMMAND}" = "--option none" ]]; then
    OPTIONS_COMMAND_SNIPPET=""
else
    OPTIONS_COMMAND_SNIPPET="${OPTIONS_COMMAND}"
fi

if [[ "${CUSTOM_OVERLAYS_COMMAND}" = "--custom_overlay none" ]]; then
    CUSTOM_OVERLAYS_COMMAND_SNIPPET=""
else
    CUSTOM_OVERLAYS_COMMAND_SNIPPET="${CUSTOM_OVERLAYS_COMMAND}"
fi

if [[ "${ENABLE_ALL}" = false ]]; then
    ENABLE_ALL_COMMAND_SNIPPET=""
else
    ENABLE_ALL_COMMAND_SNIPPET="--enable_all"
fi

if [[ "${OUTDIR}" = "none" ]]; then
    OUTDIR_COMMAND_SNIPPET=""
else
    OUTDIR_COMMAND_SNIPPET="--output_dir ${OUTDIR}"
    mkdir -p ${OUTDIR}
fi

if [[ "${CA}" = "citadel" ]]; then
    CA_COMMAND_SNIPPET="--ca citadel --ca_cert ${CA_CERT} --ca_key ${CA_KEY} --root_cert ${ROOT_CERT} --cert_chain ${CERT_CHAIN}"
else
    CA_COMMAND_SNIPPET=""
fi

# Echo the command before executing
echo -e "install_asm_${ASM_VERSION} --verbose --project_id ${PROJECT_ID} --cluster_name ${CLUSTER_NAME} --cluster_location ${CLUSTER_LOCATION} --mode ${MODE} ${OPTIONS_COMMAND_SNIPPET} ${CUSTOM_OVERLAYS_COMMAND_SNIPPET} ${OUTDIR_COMMAND_SNIPPET} ${ENABLE_ALL_COMMAND_SNIPPET} ${CA_COMMAND_SNIPPET}"

# #run the script with appropriate flags
./install_asm_${ASM_VERSION} --verbose --project_id ${PROJECT_ID} --cluster_name ${CLUSTER_NAME} --cluster_location ${CLUSTER_LOCATION} --mode ${MODE} ${OPTIONS_COMMAND_SNIPPET} ${CUSTOM_OVERLAYS_COMMAND_SNIPPET} ${OUTDIR_COMMAND_SNIPPET} ${ENABLE_ALL_COMMAND_SNIPPET} ${CA_COMMAND_SNIPPET}
