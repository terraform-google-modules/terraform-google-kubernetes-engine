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

if [ "$#" -lt 6 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3
ASM_DIR=$5
ASM_VERSION=$5
INSTALL_MODE=$6

mkdir -p "$ASM_DIR"

curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"$ASM_VERSION" > install_asm
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"$ASM_VERSION".sha256 > install_asm.sha256
sha256sum -c --ignore-missing install_asm.sha256
chmod +x install_asm

echo "Calling install_asm with mode $INSTALL_MODE"
## Install asm using install_asm script
./install_asm \
  --project_id "$PROJECT_ID" \
  --cluster_name "$CLUSTER_NAME" \
  --cluster_location "$CLUSTER_LOCATION" \
  --mode "$INSTALL_MODE" \
  --output_dir "$ASM_DIR" \
  --enable_all
