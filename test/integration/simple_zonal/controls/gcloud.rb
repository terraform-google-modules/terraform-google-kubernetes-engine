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

# Test the cluster is in running status
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json| jq -cre \'.status\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq 'RUNNING' }
end

# Test the cluster has the expected initial cluster version
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.initialClusterVersion\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq ENV['KUBERNETES_VERSION'] }
end

# Test the cluster is in the expected network
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.network\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq ENV['NETWORK'] }
end

# Test the cluster is in the expected subnetwork
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.subnetwork\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq ENV['SUBNETWORK'] }
end

# Test the cluster has the expected secondary ip range for pods
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.ipAllocationPolicy.clusterSecondaryRangeName\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq ENV['IP_RANGE_PODS'] }
end

# Test the cluster has the expected secondary ip range for services
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.ipAllocationPolicy.servicesSecondaryRangeName\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq ENV['IP_RANGE_SERVICES'] }
end

# Test the cluster has the expected addon settings
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.addonsConfig\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '{"horizontalPodAutoscaling":{},"httpLoadBalancing":{"disabled":true},"kubernetesDashboard":{},"networkPolicyConfig":{}}' }
end

# Test default pool has no initial node count
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "default-pool") | .initialNodeCount\'') do
  its('exit_status') { should eq 1 }
  its('stdout.strip') { should eq 'null' }
end

# Test default pool has not auto scaling enabled
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "default-pool") | .autoscaling.enabled\'') do
  its('exit_status') { should eq 1 }
  its('stdout.strip') { should eq 'null' }
end

# Test pool-01 is expected version
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .version\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq ENV['KUBERNETES_VERSION'] }
end

# Test pool-01 has auto scaling enabled
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .autoscaling.enabled\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq 'true' }
end

# Test pool-01 has expected min node count
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .autoscaling.minNodeCount\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '1' }
end

# Test pool-01 has expected max node count
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .autoscaling.maxNodeCount\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '2' }
end

# Test pool-01 is expected machine type
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .config.machineType\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq 'n1-standard-1' }
end

# Test pool-01 has expected disk size
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .config.diskSizeGb\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '30' }
end

# Test pool-01 has expected labels
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .config.labels\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '{"all_pools_label":"something","cluster_name":"' + ENV['CLUSTER_NAME'] + '","node_pool":"pool-01","pool_01_another_label":"no","pool_01_label":"yes"}' }
end

# Test pool-01 has expected network tags
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .config.tags\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '["gke-' + ENV['CLUSTER_NAME'] + '","gke-' + ENV['CLUSTER_NAME'] + '-pool-01","all-node-network-tag","pool-01-network-tag"]' }
end

# Test pool-01 has auto repair enabled
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .management.autoRepair\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq 'true' }
end

# Test pool-01 has auto upgrade disabled
describe command('gcloud --project=${PROJECT_ID} container clusters --zone=${CLUSTER_LOCATION} describe ${CLUSTER_NAME} --format=json | jq -cre \'.nodePools[] | select(.name == "pool-01") | .management.autoUpgrade\'') do
  its('exit_status') { should eq 1 }
  its('stdout.strip') { should eq 'null' }
end
