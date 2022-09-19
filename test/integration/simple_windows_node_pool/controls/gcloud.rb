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
        expect(data['location']).to match(/^.*[1-9]$/)
      end

      it "is single zoned" do
        expect(data['locations'].size).to eq 1
      end

      it "uses public nodes and master endpoint" do
        expect(data['privateClusterConfig']).to eq nil
      end

      it "has the expected addon settings" do
        expect(data['addonsConfig']).to include(
          "horizontalPodAutoscaling" => {},
          "httpLoadBalancing" => {},
          "kubernetesDashboard" => {
            "disabled" => true,
          },
          "kalmConfig" => {},
          "configConnectorConfig" => {},
          "networkPolicyConfig" => {
            "disabled" => true,
          },
          "istioConfig" => {"auth"=>"AUTH_MUTUAL_TLS"},
          "cloudRunConfig" => including(
              "loadBalancerType" => "LOAD_BALANCER_TYPE_EXTERNAL",
            ),
          "dnsCacheConfig" => {
            "enabled" => true,
          },
          "gcePersistentDiskCsiDriverConfig" => {
            "enabled" => true,
          }
        )
      end

      it "has the expected datapathProvider config" do
        expect(data['networkConfig']).to include(
          "datapathProvider" => "ADVANCED_DATAPATH"
        )
      end

      it "has the expected binaryAuthorization config" do
        expect(data['binaryAuthorization']).to eq({
          "evaluationMode" => "PROJECT_SINGLETON_POLICY_ENFORCE",
        })
      end

      it "has the expected podSecurityPolicyConfig config" do
        expect(data['podSecurityPolicyConfig']).to eq({
          "enabled" => true,
        })
      end

      it "has the expected databaseEncryption config" do
        expect(data['databaseEncryption']).to eq({
          "state" => 'ENCRYPTED',
          "keyName" => attribute('database_encryption_key_name'),
        })
      end

      it "has the expected identityServiceConfig config" do
        expect(data['identityServiceConfig']).to eq({
          "enabled" => true,
        })
      end

      it "has the expected logging config" do
        expect(data['loggingConfig']['componentConfig']['enableComponents']).to match_array([
          "SYSTEM_COMPONENTS"
        ])
      end

      it "has the expected monitoring config" do
        expect(data['monitoringConfig']['componentConfig']['enableComponents']).to match_array([
          "WORKLOADS",
          "SYSTEM_COMPONENTS"
        ])
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

        it "has autoscaling enabled" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "autoscaling" => including(
                "enabled" => true,
              ),
            )
          )
        end

        it "has the expected minimum node count" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "autoscaling" => including(
                "minNodeCount" => 1,
              ),
            )
          )
        end

        it "has the expected maximum node count" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "autoscaling" => including(
                "maxNodeCount" => 2,
              ),
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

        it "has the expected disk size" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "config" => including(
                "diskSizeGb" => 100,
              ),
            )
          )
        end

        it "has the expected labels" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "config" => including(
                "labels" => including(
                  "cluster_name" => cluster_name,
                  "node_pool" => "pool-01",
                ),
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

        it "has autorepair enabled" do
          expect(node_pools).to include(
            including(
              "name" => "pool-01",
              "management" => including(
                "autoRepair" => true,
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

        it "has autoscaling enabled" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "autoscaling" => including(
                "enabled" => true,
              ),
            )
          )
        end

        it "has the expected minimum node count" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "autoscaling" => including(
                "minNodeCount" => 1,
              ),
            )
          )
        end

        it "has the expected maximum node count" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "autoscaling" => including(
                "maxNodeCount" => 2,
              ),
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

        it "has the expected disk size" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "diskSizeGb" => 100,
              ),
            )
          )
        end

        it "has the expected labels" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "labels" => including(
                  "cluster_name" => cluster_name,
                  "node_pool" => "win-pool-01",
                ),
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

        it "has autorepair enabled" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "management" => including(
                "autoRepair" => true,
              ),
            )
          )
        end

        it "uses the windows_ltsc image" do
          expect(node_pools).to include(
            including(
              "name" => "win-pool-01",
              "config" => including(
                "imageType" => "WINDOWS_LTSC",
              ),
            ),
          )
        end
      end
    end
  end
end
