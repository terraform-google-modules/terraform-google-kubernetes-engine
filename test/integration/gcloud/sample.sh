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


#################################################################
#   PLEASE FILL THE VARIABLES WITH VALID VALUES FOR TESTING     #
#   DO NOT REMOVE ANY OF THE VARIABLES                          #
#################################################################

## These values you *MUST* modify to match your environment
export PROJECT_ID="gke-test-integration"
export NETWORK="vpc-01"
export SUBNETWORK="us-east4-01"
export IP_RANGE_PODS="us-east4-01-gke-01-pod"
export IP_RANGE_SERVICES="us-east4-01-gke-01-service"
export CREDENTIALS_PATH="$HOME/sa-key.json"

## These values you can potentially leave at the defaults
export CLUSTER_NAME="int-test-cluster-01"
export REGION="us-east4"
export KUBERNETES_VERSION="1.10.5-gke.4"
export NODE_SERVICE_ACCOUNT=""
export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS_PATH
