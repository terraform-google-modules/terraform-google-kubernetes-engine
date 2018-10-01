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

require_relative '../../../../test/support/google_cloud.rb'

# Test the name output
describe command('terraform output name_example') do
  its('stdout.strip') { should eq ENV['CLUSTER_NAME'] }
end

# Test the location output
describe command('terraform output type_example') do
  its('stdout.strip') { should eq ENV['CLUSTER_TYPE'] }
end

# Test the location output
describe command('terraform output location_example') do
  its('stdout.strip') { should eq ENV['CLUSTER_LOCATION'] }
end

# Test the region output
describe command('terraform output region_example') do
  its('stdout.strip') { should eq ENV['REGION'] }
end

# Test the zones output
describe command('terraform output -json zones_example | jq -cre \'.value\'') do
  if ENV['ZONES'] != ''
    its('stdout.strip') { should eq '[' + ENV['ZONES'] + ']' }
  else
    its('stdout.strip') { should eq google_compute_service.get_region(ENV['PROJECT_ID'], ENV['REGION']).zones.map { |z| z.split("/").last }.to_json }
  end
end

# Test the endpoint output
describe command('terraform output endpoint_example') do
  its('stdout.strip') { should_not eq '' }
end

# Test the ca_certificate output
describe command('terraform output ca_certificate_example') do
  its('stdout.strip') { should_not eq '' }
end

# Test the min_master_version output
describe command('terraform output min_master_version_example') do
  its('stdout.strip') { should eq ENV['KUBERNETES_VERSION'] }
end

# Test the master_version output
describe command('terraform output master_version_example') do
  its('stdout.strip') { should eq ENV['KUBERNETES_VERSION'] }
end

# Test the network_policy output
describe command('terraform output network_policy_example') do
  its('stdout.strip') { should eq 'true' }
end

# Test the http_load_balancing_enabled output
describe command('terraform output http_load_balancing_example') do
  its('stdout.strip') { should eq 'false' }
end

# Test the horizontal_pod_autoscaling_enabled output
describe command('terraform output horizontal_pod_autoscaling_example') do
  its('stdout.strip') { should eq 'true' }
end

# Test the kubernetes_dashboard_enabled output
describe command('terraform output kubernetes_dashboard_example') do
  its('stdout.strip') { should eq 'true' }
end

# Test the node_pools_names output
describe command('terraform output node_pools_names_example') do
  its('stdout.strip') { should eq 'pool-01,' }
end

# Test the node_pools_versions output
describe command('terraform output node_pools_versions_example') do
  its('stdout.strip') { should eq ENV['KUBERNETES_VERSION'] + ',' }
end
