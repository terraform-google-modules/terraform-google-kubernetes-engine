#! /usr/bin/env bash

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

set -eou

run_pipelines() {
  if [[ ! -d .concourse/logs ]]; then
    mkdir -p .concourse/logs
  fi

  for file in test/ci/tasks/*; do
    tmp="$(mktemp -d)"
    awk -v input="${SERVICE_ACCOUNT_JSON}" 'NR == 1, /<INSERT_KEY_JSON>/ { sub(/<INSERT_KEY_JSON>/, input) } 1' "${file}" | sed '11,49s/^/      /' | tee "${tmp}/$(basename "${file}")"
    fly -t cft execute -c "${tmp}/$(basename "${file}")" >.concourse/logs/"$(basename "${file%.yml}").log" 2>&1 &
  done
}

main() {
  run_pipelines
}

main "$@"
