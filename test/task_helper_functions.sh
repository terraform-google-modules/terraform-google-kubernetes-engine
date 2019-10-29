#!/usr/bin/env bash

# Copyright 2019 Google LLC
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

function generate() {
  pip3 install --user -r /workspace/helpers/generate_modules/requirements.txt
  /workspace/helpers/generate_modules/generate_modules.py
}

# Changed from using git-diff, to aviod errors on CI:
# fatal: not a git repository (or any parent up to mount point /)
function check_generate() {
  local tempdir rval rc
  setup_trap_handler
  tempdir=$(mktemp -d)
  rval=0
  echo "Checking submodule's files generation"
  rsync -axh \
    --exclude '*/.terraform' \
    --exclude '*/.kitchen' \
    --exclude '*/.git' \
    /workspace "${tempdir}" >/dev/null 2>/dev/null
  cd "${tempdir}" || exit 1
  generate >/dev/null 2>/dev/null
  diff -r \
    --exclude=".terraform" \
    --exclude=".kitchen" \
    --exclude=".git" \
    /workspace "${tempdir}/workspace"
  rc=$?
  if [[ "${rc}" -ne 0 ]]; then
    echo "Error: submodule's files generation has not been run, please run the"
    echo "'source /workspace/helpers/generate.sh && generate' commands and commit the above changes."
    ((rval++))
  fi
  cd /workspace || exit 1
  rm -Rf "${tempdir}"
  return $((rval))
}

find_files() {
  local pth="$1"
  shift
    find "${pth}" '(' \
    -path '*/.git' -o \
    -path '*/.terraform' -o \
    -path '*/.kitchen' -o \
    -path './autogen' -o \
    -path './test/fixtures/all_examples' -o \
    -path './test/fixtures/shared' ')' \
    -prune -o -type f "$@"
}
