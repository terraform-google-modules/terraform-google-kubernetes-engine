#!/usr/bin/env bash

# Copyright 2022 Google LLC
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

if [ "$#" -lt 1 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

REVISION_NAME=$1; shift

if ! kubectl delete controlplanerevision -n istio-system "${REVISION_NAME}" ; then
  echo "ControlPlaneRevision ${REVISION_NAME} not found"
fi
