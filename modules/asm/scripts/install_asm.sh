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

if [ "$#" -lt 3 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3
ASM_RESOURCES="asm-dir"
BASE_DIR="asm-base-dir"
# check for needed binaries
# kustomize is a requirement for installing ASM and is not available via gcloud. Safely exit if not available.
if [[ -z $(command -v kustomize) ]]; then
  echo "kustomize is unavailable. Skipping ASM installation. Please install kustomize, add to PATH and rerun terraform apply."
  exit 1
fi
# # check docker which is optionally used for validating asm yaml using gcr.io/kustomize-functions/validate-asm:v0.1.0
# if [[ $(command -v docker) ]]; then
#   echo "Docker is available. ASM yaml validation will be performed."
# else
#   echo "ASM yaml validation will be skipped as Docker is unavailable"
#   SKIP_ASM_VALIDATION=true
# fi
mkdir -p $ASM_RESOURCES
pushd $ASM_RESOURCES
gcloud config set project "${PROJECT_ID}"
if [[ -d ./asm-patch ]]; then
    echo "ASM patch directory exists. Skipping download..."
else
    echo "Downloading ASM patch"
    kpt pkg get https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git/asm-patch@release-1.5-asm .
fi
gcloud beta anthos export "${CLUSTER_NAME}" --output-directory ${BASE_DIR} --project "${PROJECT_ID}" --location "${CLUSTER_LOCATION}"
kpt cfg set asm-patch/ base-dir ../${BASE_DIR}
kpt cfg set asm-patch/ gcloud.core.project "${PROJECT_ID}"
kpt cfg set asm-patch/ gcloud.container.cluster "${CLUSTER_NAME}"
kpt cfg set asm-patch/ gcloud.compute.location "${CLUSTER_LOCATION}"
kpt cfg list-setters asm-patch/
pushd ${BASE_DIR} && kustomize create --autodetect --namespace "${PROJECT_ID}" && popd
pushd asm-patch && kustomize build -o ../${BASE_DIR}/all.yaml && popd
# # skip validate as we should investigate if we can check this without having to resort to dind
# if [[ ${SKIP_ASM_VALIDATION} ]]; then
#  echo "Skipping ASM validation..."
# else
#  echo "Running ASM validation..."
#  kpt fn source ${BASE_DIR} | kpt fn run --image gcr.io/kustomize-functions/validate-asm:v0.1.0
# fi
gcloud beta anthos apply ${BASE_DIR}
kubectl wait --for=condition=available --timeout=600s deployment --all -n istio-system
