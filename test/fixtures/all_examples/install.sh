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

#############################################
# Install fixture data into an example case #
#############################################
BASEDIR=$(dirname "$0")
EXAMPLE=${1}

if [ -z "${EXAMPLE}" ]; then
  echo "Must specify an example to install fixtures into. Aborting."
  exit 1
fi

if [ ! -d "${BASEDIR}/../../../examples/${EXAMPLE}" ]; then
  echo "Example ${EXAMPLE} does not exist. Aborting."
  exit 1
fi

_example_path="${BASEDIR}/../../../examples/${EXAMPLE}"
mv "${_example_path}/variables.tf" "${_example_path}/variables.tf.disabled"
cp "${BASEDIR}/fixture_data.tf.fixture" "${_example_path}/fixture_data.tf"
cp "${BASEDIR}/fixture_outputs.tf.fixture" "${_example_path}/fixture_outputs.tf"
