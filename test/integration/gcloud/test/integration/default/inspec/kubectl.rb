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

# Test pool-01 has expected taints
describe command('$(terraform output module_path)/scripts/kubectl_wrapper.sh https://$(terraform output endpoint_example) $(terraform output client_token | base64 --decode) $(terraform output ca_certificate_example) kubectl get nodes -o json -l node_pool=pool-01 | jq -cre \'.items[0].spec.taints\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq '[{"effect":"PreferNoSchedule","key":"all_pools_taint","value":"true"},{"effect":"PreferNoSchedule","key":"pool_01_taint","value":"true"},{"effect":"PreferNoSchedule","key":"pool_01_another_taint","value":"true"}]' }
end

# Test kube dns configmap created" {
describe command('$(terraform output module_path)/scripts/kubectl_wrapper.sh https://$(terraform output endpoint_example) $(terraform output client_token | base64 --decode) $(terraform output ca_certificate_example) kubectl -n kube-system get configmap -o json kube-dns | jq -cre \'.metadata.labels.maintained_by\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq 'terraform' }
end

# Test ip masq agent configmap created" {
describe command('$(terraform output module_path)/scripts/kubectl_wrapper.sh https://$(terraform output endpoint_example) $(terraform output client_token | base64 --decode) $(terraform output ca_certificate_example) kubectl -n kube-system get configmap -o json ip-masq-agent | jq -cre \'.metadata.labels.maintained_by\'') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should eq 'terraform' }
end

# Test that the nginx example service is reachable" {
describe command('curl -Ifs -m 10 $($(terraform output module_path)/scripts/kubectl_wrapper.sh https://$(terraform output endpoint_example) $(terraform output client_token | base64 --decode) $(terraform output ca_certificate_example) kubectl get service terraform-example -o json | jq -cre \'.status.loadBalancer.ingress[0].ip\'):8080') do
  its('exit_status') { should eq 0 }
  its('stdout.strip') { should include 'HTTP/1.1 200 OK' }
  its('stdout.strip') { should include 'Server: nginx' }
end
