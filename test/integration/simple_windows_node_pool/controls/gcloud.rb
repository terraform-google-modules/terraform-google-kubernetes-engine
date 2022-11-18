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

project_id = attribute('project_id')
location = attribute('location')
cluster_name = attribute('cluster_name')
service_account = attribute('service_account')

control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command("gcloud beta --project=#{project_id} container clusters --zone=#{location} describe #{cluster_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "cluster" do
      it "is running" do
        expect(data['status']).to eq 'RUNNING'
      end

      it "is regional" do
        expect(data['location']).to match(/^.*[1-9]-[a-z]$/)
      end

      it "is single zoned" do
        expect(data['locations'].size).to eq 1
      end

      it "has the release channel set to REGULAR " do
        expect(data['releaseChannel']['channel']).to eq "REGULAR"
      end
    end

    describe "node pool" do
      let(:node_pools) { data['nodePools'].reject { |p| p['name'] == "default-pool" } }

      it "has 2 node pools" do
        expect(node_pools.count).to eq 2
      end

      describe "pool-01" do
        it "exists" do
          expect(data['nodePools']).to include(
            including(
              "name" => "pool-01",
            )
          )
        end

        it "uses an automatically created service account" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "config" => including(
                "serviceAccount" => service_account,
              ),
            ),
          )
        end

        it "has the node count set to 1" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "initialNodeCount" => 1,
            )
          )
        end

        it "is the expected machine type" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "config" => including(
                "machineType" => "n2-standard-2",
              ),
            )
          )
        end

        it "has the expected network tags" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "config" => including(
                "tags" => match_array([
                  "gke-#{cluster_name}",
                  "gke-#{cluster_name}-pool-01",
                ]),
              ),
            )
          )
        end

        it "has autoupgrade enabled" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "management" => including(
                "autoUpgrade" => true,
              ),
            )
          )
        end
      end

      describe "win-pool-01" do
        it "exists" do
          expect(data['nodePools']).to include(
            including(
              "name" => "win-pool-01",
            )
          )
        end

        it "uses an automatically created service account" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "serviceAccount" => service_account,
              ),
            ),
          )
        end

        it "has the node count set to 1" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "initialNodeCount" => 1,
            )
          )
        end

        it "is the expected machine type" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "machineType" => "n2-standard-2",
              ),
            )
          )
        end

        it "has the expected network tags" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "tags" => match_array([
                  "gke-#{cluster_name}",
                  "gke-#{cluster_name}-win-pool-01",
                ]),
              ),
            )
          )
        end

        it "has autoupgrade enabled" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "management" => including(
                "autoUpgrade" => true,
              ),
            )
          )
        end

        it "uses the windows_ltsc image" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "imageType" => "WINDOWS_LTSC_CONTAINERD",
              ),
            ),
          )
        end
      end
    end
  end
end
