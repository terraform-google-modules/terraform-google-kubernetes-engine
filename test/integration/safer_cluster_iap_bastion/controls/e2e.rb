# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

test_command = attribute('test_command')
cluster_version = attribute('cluster_version')
# pre run ssh command so that ssh-keygen can run
%x( #{test_command} )
control "e2e" do
    title "SSH into VM and verify connectivity to GKE"
    describe command(test_command) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
    let!(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
          {}
        end
      end
      describe "gke version" do
            it "is correct" do
            expect(data['gitVersion']).to eq "v#{cluster_version}"
            end
        end
    end
end
