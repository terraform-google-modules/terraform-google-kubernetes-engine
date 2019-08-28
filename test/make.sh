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

# Please note that this file was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template).
# Please make sure to contribute relevant changes upstream!

# Create a temporary directory that's auto-cleaned, even if the process aborts.
DELETE_AT_EXIT="$(mktemp -d)"
finish() {
  [[ -d "${DELETE_AT_EXIT}" ]] && rm -rf "${DELETE_AT_EXIT}"
}
trap finish EXIT
# Create a temporary file in the auto-cleaned up directory while avoiding
# overwriting TMPDIR for other processes.
# shellcheck disable=SC2120
# (Arguments may be passed, e.g. maketemp -d)
maketemp() {
  TMPDIR="${DELETE_AT_EXIT}" mktemp "$@"
}

# find_files is a helper to exclude .git directories and match only regular
# files to avoid double-processing symlinks.
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

# Compatibility with both GNU and BSD style xargs.
compat_xargs() {
  local compat=() rval
  # Test if xargs is GNU or BSD style.  GNU xargs will succeed with status 0
  # when given --no-run-if-empty and no input on STDIN.  BSD xargs will fail and
  # exit status non-zero If xargs fails, assume it is BSD style and proceed.
  # stderr is silently redirected to avoid console log spam.
  if xargs --no-run-if-empty </dev/null 2>/dev/null; then
    compat=("--no-run-if-empty")
  fi
  xargs "${compat[@]}" "$@"
  rval="$?"
  if [[ -z "${NOWARN:-}" ]] && [[ "${rval}" -gt 0 ]]; then
    echo "Warning: compat_xargs $* failed with exit code ${rval}" >&2
  fi
  return "${rval}"
}

# This function makes sure that the required files for
# releasing to OSS are present
function basefiles() {
  local fn required_files="LICENSE README.md"
  echo "Checking for required files ${required_files}"
  for fn in ${required_files}; do
    test -f "${fn}" || echo "Missing required file ${fn}"
  done
}

# This function runs 'terraform validate' and 'terraform fmt'
# against all directory paths which contain *.tf files.
function check_terraform() {
  local rval=125
  # fmt is before validate for faster feedback, validate requires terraform
  # init which takes time.
  echo "Running terraform fmt"
  find_files . -name "*.tf" -print0 \
    | compat_xargs -0 -n1 dirname \
    | sort -u \
    | compat_xargs -t -n1 terraform fmt -diff -check=true -write=false
  rval="$?"
  if [[ "${rval}" -gt 0 ]]; then
    echo "Error: terraform fmt failed with exit code ${rval}" >&2
    echo "Check the output for diffs and correct using terraform fmt <dir>" >&2
    return "${rval}"
  fi
  echo "Running terraform validate"
  find_files . -not -path "./test/fixtures/shared/*" -name "*.tf" -print0 \
    | compat_xargs -0 -n1 dirname \
    | sort -u \
    | compat_xargs -t -n1 helpers/terraform_validate
}

# This function runs 'go fmt' and 'go vet' on every file
# that ends in '.go'
function golang() {
  echo "Running go fmt and go vet"
  find_files . -name "*.go" -print0 | compat_xargs -0 -n1 go fmt
  find_files . -name "*.go" -print0 | compat_xargs -0 -n1 go vet
}

# This function runs the flake8 linter on every file
# ending in '.py'
function check_python() {
  echo "Running flake8"
  find_files . -name "*.py" -print0 | compat_xargs -0 flake8
  return 0
}

# This function runs the shellcheck linter on every
# file ending in '.sh'
function check_shell() {
  echo "Running shellcheck"
  find_files . -name "*.sh" -print0 | compat_xargs -0 shellcheck -x
}

# This function makes sure that there is no trailing whitespace
# in any files in the project.
# There are some exclusions
function check_trailing_whitespace() {
  local rc
  echo "Checking for trailing whitespace"
  find_files . -print \
    | grep -v -E '\.(pyc|png)$' \
    | NOWARN=1 compat_xargs grep -H -n '[[:blank:]]$'
  rc=$?
  if [[ ${rc} -eq 0 ]]; then
    return 1
  fi
}

function generate() {
  pip3 install --user -r ./helpers/generate_modules/requirements.txt
  ./helpers/generate_modules/generate_modules.py
}

function generate_docs() {
  echo "Generating markdown docs with terraform-docs"
  local pth helper_dir rval
  helper_dir="$(pwd)/helpers"
  while read -r pth; do
    if [[ -e "${pth}/README.md" ]]; then
      (cd "${pth}" || return 3; "${helper_dir}"/terraform_docs .;)
      rval="$?"
      if [[ "${rval}" -gt 0 ]]; then
        echo "Error: terraform_docs in ${pth} exit code: ${rval}" >&2
        return "${rval}"
      fi
    else
      echo "Skipping ${pth} because README.md does not exist."
    fi
  done < <(find_files . -name '*.tf' -print0 \
    | compat_xargs -0 -n1 dirname \
    | sort -u)
}

function check_generate() {
  TMPDIR=$(mktemp -d)
  git worktree add --detach "$TMPDIR" >/dev/null
  cd "$TMPDIR" || exit 1

  generate >/dev/null
  generate_docs >/dev/null

  git diff --stat --exit-code >/dev/null
  rc=$?
  cd - >/dev/null || exit 1

  if [[ $rc -ne 0 ]]; then
    echo '"make generate" creates a diff, run "make generate" and commit the results'
  fi
  rm -rf "$TMPDIR"
  git worktree prune >/dev/null

  echo "Code was generated properly"

  exit $rc
}

function check_generate_docs() {
  TMPDIR=$(mktemp -d)
  git worktree add --detach "$TMPDIR" >/dev/null
  cd "$TMPDIR" || exit 1

  generate_docs >/dev/null
  git diff --stat --exit-code >/dev/null
  rc=$?
  cd - >/dev/null || exit 1

  if [[ $rc -ne 0 ]]; then
    echo '"make generate_docs" creates a diff, run "make generate_docs" and commit the results'
  fi
  rm -rf "$TMPDIR"
  git worktree prune >/dev/null

  echo "Docs were generated properly"

  exit $rc
}

function prepare_test_variables() {
  echo "Preparing terraform.tfvars files for integration tests"
  #shellcheck disable=2044
  for i in $(find ./test/fixtures -type f -name terraform.tfvars.sample); do
    destination=${i/%.sample/}
    if [ ! -f "${destination}" ]; then
      cp "${i}" "${destination}"
      echo "${destination} has been created. Please edit it to reflect your GCP configuration."
    fi
  done
}

function check_headers() {
  echo "Checking file headers"
  # Use the exclusion behavior of find_files
  find_files . -type f -print0 \
    | compat_xargs -0 python test/verify_boilerplate.py
}
