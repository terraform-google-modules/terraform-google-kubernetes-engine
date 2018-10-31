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
export CREDENTIALS_PATH="$HOME/sa-key.json"
export NETWORK="vpc-01"
export SUBNETWORK="us-east4-01"
export REGIONAL_IP_RANGE_PODS="us-east4-01-gke-01-pod"
export REGIONAL_IP_RANGE_SERVICES="us-east4-01-gke-01-service"
export ZONAL_IP_RANGE_PODS="us-east4-01-gke-02-pod"
export ZONAL_IP_RANGE_SERVICES="us-east4-01-gke-02-service"

## These values you can potentially leave at the defaults
export CLUSTER_NAME="int-test-cluster-01"
export REGION="us-east4"
export ZONE="us-east4-a"
export ADDITIONAL_ZONES='"us-east4-b","us-east4-c"'
export KUBERNETES_VERSION="1.10.6-gke.2"
export NODE_POOL_SERVICE_ACCOUNT=""
export REGIONAL_CLUSTER_NAME="int-test-regional-01"
export REGIONAL_LOCATION="$REGION"
export ZONAL_CLUSTER_NAME="int-test-zonal-01"
export ZONAL_LOCATION="$ZONE"
export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS_PATH
export GOOGLE_APPLICATION_CREDENTIALS=$CREDENTIALS_PATH
