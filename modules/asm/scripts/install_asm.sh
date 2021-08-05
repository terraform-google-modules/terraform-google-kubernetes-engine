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

if [ "$#" -lt 5 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

PROJECT_ID=${1}
CLUSTER_NAME=${2}
CLUSTER_LOCATION=${3}
ASM_VERSION=${4}
MODE=${5}
MCP=${6}
SKIP_VALIDATION=${7}
OPTIONS_LIST=${8}
CUSTOM_OVERLAYS_LIST=${9}
ENABLE_ALL=${10}
ENABLE_CLUSTER_ROLES=${11}
ENABLE_CLUSTER_LABELS=${12}
ENABLE_GCP_COMPONENTS=${13}
ENABLE_REGISTRATION=${14}
OUTDIR=${15}
CA=${16}
CA_CERT=${17}
CA_KEY=${18}
ROOT_CERT=${19}
CERT_CHAIN=${20}
SERVICE_ACCOUNT=${21}
KEY_FILE=${22}
ASM_GIT_TAG=${23}
REVISION_NAME=${24}
ENABLE_NAMESPACE_CREATION=${25}

# Set SKIP_VALIDATION variable
if [[ ${SKIP_VALIDATION} = "true" ]]; then
    export _CI_NO_VALIDATE=1
else
    export _CI_NO_VALIDATE=0
fi

# Create bash arrays from options and custom_overlays lists
if [[ ${OPTIONS_LIST} ]]; then
    IFS=',' read -r -a OPTIONS <<< "${OPTIONS_LIST}"
elif [[ ${OPTIONS_LIST} = "" ]]; then
    read -r -a OPTIONS <<< "none"
fi

if [[ ${CUSTOM_OVERLAYS_LIST} ]]; then
    IFS=',' read -r -a CUSTOM_OVERLAYS <<< "${CUSTOM_OVERLAYS_LIST}"
else
    read -r -a CUSTOM_OVERLAYS <<< "none"
fi

# Echo all values
echo -e "MODE is $MODE"
echo -e "MCP is $MCP"
echo -e "ASM_VERSION is $ASM_VERSION"
echo -e "ASM_GIT_TAG is $ASM_GIT_TAG"
echo -e "SKIP_VALIDATION is $SKIP_VALIDATION"
echo -e "_CI_NO_VALIDATE is $_CI_NO_VALIDATE"
echo -e "OPTIONS_LIST is ${OPTIONS_LIST}"
echo -e "OPTIONS array length is ${#OPTIONS[@]}"
# Create options command snippet
item="${OPTIONS[*]}";OPTIONS_COMMAND=$(echo "--option" "${item// / --option }")
echo -e "OPTIONS_COMMAND is $OPTIONS_COMMAND"
echo -e "CUSTOM_OVERLAYS array length is ${#CUSTOM_OVERLAYS[@]}"
# Create custom_overlays command snippet
if [[ "${CUSTOM_OVERLAYS[*]}" == "none" ]]; then
    CUSTOM_OVERLAYS_COMMAND="--custom_overlay none"
else
    item="${CUSTOM_OVERLAYS[*]}";CUSTOM_OVERLAYS_COMMAND=$(echo "--custom_overlay" "$(pwd)/${item// / --custom_overlay $(pwd)/}")
fi
echo -e "CUSTOM_OVERLAYS_COMMAND is $CUSTOM_OVERLAYS_COMMAND"
echo -e "ENABLE_ALL is $ENABLE_ALL"
echo -e "ENABLE_CLUSTER_ROLES is $ENABLE_CLUSTER_ROLES"
echo -e "ENABLE_CLUSTER_LABELS is $ENABLE_CLUSTER_LABELS"
echo -e "ENABLE_GCP_COMPONENTS is $ENABLE_GCP_COMPONENTS"
echo -e "ENABLE_REGISTRATION is $ENABLE_REGISTRATION"
echo -e "ENABLE_NAMESPACE_CREATION is $ENABLE_NAMESPACE_CREATION"
echo -e "OUTDIR is $OUTDIR"
echo -e "SERVICE_ACCOUNT is $SERVICE_ACCOUNT"
echo -e "KEY_FILE is $KEY_FILE"
echo -e "REVISION_NAME is $REVISION_NAME"
echo -e "CA is $CA"
echo -e "CA_CERT is $CA_CERT"
echo -e "CA_KEY is $CA_KEY"
echo -e "ROOT_CERT is $ROOT_CERT"
echo -e "CERT_CHAIN is $CERT_CHAIN"
#download the correct version of the install_asm script
if [[ "${ASM_GIT_TAG}" = "none" ]]; then
    echo -e "Downloading install_asm with latest git tag..."
    curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_VERSION}" > install_asm_"${ASM_VERSION}"
    chmod u+x install_asm_"${ASM_VERSION}"
else
    ASM_GIT_TAG_FIXED=$(sed 's/+/-/g' <<<"$ASM_GIT_TAG")
    echo -e "Downloading install_asm with git tag $ASM_GIT_TAG..."
    curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_GIT_TAG_FIXED}" > install_asm_"${ASM_VERSION}"
    chmod u+x install_asm_"${ASM_VERSION}"
fi

# Craft MCP section for install_asm
if [[ "${MCP}" = true ]]; then
    MCP_COMMAND_SNIPPET="--managed"
else
    MCP_COMMAND_SNIPPET=""
fi

# Craft service_account section for install_asm
if [[ "${SERVICE_ACCOUNT}" = "none" ]]; then
    SERVICE_ACCOUNT_COMMAND_SNIPPET=""
else
    SERVICE_ACCOUNT_COMMAND_SNIPPET="--service_account ${SERVICE_ACCOUNT}"
fi

# Craft key_file section for install_asm
if [[ "${KEY_FILE}" = "none" ]]; then
    KEY_FILE_COMMAND_SNIPPET=""
else
    KEY_FILE_COMMAND_SNIPPET="--key_file $(pwd)/${KEY_FILE}"
fi

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

if [[ "${ENABLE_CLUSTER_ROLES}" = false ]]; then
    ENABLE_CLUSTER_ROLES_COMMAND_SNIPPET=""
else
    ENABLE_CLUSTER_ROLES_COMMAND_SNIPPET="--enable_cluster_roles"
fi

if [[ "${ENABLE_CLUSTER_LABELS}" = false ]]; then
    ENABLE_CLUSTER_LABELS_COMMAND_SNIPPET=""
else
    ENABLE_CLUSTER_LABELS_COMMAND_SNIPPET="--enable_cluster_labels"
fi

if [[ "${ENABLE_GCP_COMPONENTS}" = false ]]; then
    ENABLE_GCP_COMPONENTS_COMMAND_SNIPPET=""
else
    ENABLE_GCP_COMPONENTS_COMMAND_SNIPPET="--enable_gcp_components"
fi

if [[ "${ENABLE_REGISTRATION}" = false ]]; then
    ENABLE_REGISTRATION_COMMAND_SNIPPET=""
else
    ENABLE_REGISTRATION_COMMAND_SNIPPET="--enable_registration"
fi

if [[ "${ENABLE_NAMESPACE_CREATION}" = true ]]; then
    ENABLE_NAMESPACE_CREATION_COMMAND_SNIPPET="--enable_namespace_creation"
else
    ENABLE_NAMESPACE_CREATION_COMMAND_SNIPPET=""
fi

if [[ "${OUTDIR}" = "none" ]]; then
    OUTDIR_COMMAND_SNIPPET=""
else
    OUTDIR_COMMAND_SNIPPET="--output_dir ${OUTDIR}"
    mkdir -p "${OUTDIR}"
fi

if [[ "${CA}" == "citadel" ]]; then
    CA_COMMAND_SNIPPET="--ca citadel"
else
    CA_COMMAND_SNIPPET=""
fi

if [[ "${CA_CERT}" == "none" ]]; then
    CA_CERTS_COMMAND_SNIPPET=""
else
    CA_CERTS_COMMAND_SNIPPET="--ca_cert ${CA_CERT} --ca_key ${CA_KEY} --root_cert ${ROOT_CERT} --cert_chain ${CERT_CHAIN}"
fi

# Echo the command before executing
echo -e "install_asm_${ASM_VERSION} --verbose --project_id ${PROJECT_ID} --cluster_name ${CLUSTER_NAME} --cluster_location ${CLUSTER_LOCATION} --mode ${MODE} ${MCP_COMMAND_SNIPPET} ${OPTIONS_COMMAND_SNIPPET} ${CUSTOM_OVERLAYS_COMMAND_SNIPPET} ${OUTDIR_COMMAND_SNIPPET} ${ENABLE_ALL_COMMAND_SNIPPET} ${ENABLE_CLUSTER_ROLES_COMMAND_SNIPPET} ${ENABLE_CLUSTER_LABELS_COMMAND_SNIPPET} ${ENABLE_GCP_COMPONENTS_COMMAND_SNIPPET} ${ENABLE_REGISTRATION_COMMAND_SNIPPET} ${ENABLE_NAMESPACE_CREATION_COMMAND_SNIPPET} ${CA_COMMAND_SNIPPET} ${CA_CERTS_COMMAND_SNIPPET} ${SERVICE_ACCOUNT_COMMAND_SNIPPET} ${KEY_FILE_COMMAND_SNIPPET} ${REVISION_NAME_COMMAND_SNIPPET}"

# run the script with appropriate flags
# shellcheck disable=SC2086
./install_asm_${ASM_VERSION} --verbose --project_id ${PROJECT_ID} --cluster_name ${CLUSTER_NAME} --cluster_location ${CLUSTER_LOCATION} --mode ${MODE} ${MCP_COMMAND_SNIPPET} ${OPTIONS_COMMAND_SNIPPET} ${CUSTOM_OVERLAYS_COMMAND_SNIPPET} ${OUTDIR_COMMAND_SNIPPET} ${ENABLE_ALL_COMMAND_SNIPPET} ${ENABLE_CLUSTER_ROLES_COMMAND_SNIPPET} ${ENABLE_CLUSTER_LABELS_COMMAND_SNIPPET} ${ENABLE_GCP_COMPONENTS_COMMAND_SNIPPET} ${ENABLE_REGISTRATION_COMMAND_SNIPPET} ${ENABLE_NAMESPACE_CREATION_COMMAND_SNIPPET} ${CA_COMMAND_SNIPPET} ${CA_CERTS_COMMAND_SNIPPET} ${SERVICE_ACCOUNT_COMMAND_SNIPPET} ${KEY_FILE_COMMAND_SNIPPET}  ${REVISION_NAME_COMMAND_SNIPPET}
