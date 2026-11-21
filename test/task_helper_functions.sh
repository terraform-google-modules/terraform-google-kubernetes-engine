#!/usr/bin/env bash
# Copyright 2026 Google LLC
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

# Exclude metadata.yaml from diff to avoid false positive failure
# when blueprint metadata contains manually populated null defaultValues.
function check_generate_modules() {
  if [[ -e /workspace/autogen_modules.json ]]; then
    local tempdir rval rc
    setup_trap_handler
    tempdir=$(mktemp -d)
    rval=0
    echo "Checking submodule's files generation"
    rsync -axh \
      --exclude '*/.terraform' \
      --exclude '*/.kitchen' \
      /workspace "${tempdir}" >/dev/null 2>/dev/null
    cd "${tempdir}/workspace" || exit 1
    generate_modules >/dev/null 2>/dev/null
    generate_docs >/dev/null 2>/dev/null
    diff -r \
      --exclude=".terraform" \
      --exclude=".kitchen" \
      --exclude=".git" \
      --exclude="*metadata.yaml" \
      /workspace "${tempdir}/workspace"
    rc=$?
    if [[ "${rc}" -ne 0 ]]; then
      echo "Error: submodule's files generation has not been run, please run the"
      echo "'make build' command and commit changes"
      ((rval++))
    fi
    cd /workspace || exit 1
    rm -Rf "${tempdir}"
    return $((rval))
  fi
}
