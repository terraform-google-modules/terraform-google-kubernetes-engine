# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [17.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v17.0.0...v17.1.0) (2021-10-27)


### Features

* Add support for CPU quota configs for node pools ([#1032](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1032)) ([80252f3](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/80252f3ffaa4c3e4eba7a180673f6108c46f7483))


### Bug Fixes

* add missing required_providers on workload identity module ([#1035](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1035)) ([04f7502](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/04f75029b7ff7d661832e91ac2ce9a24a990d34e))
* adds metadata to the default node pool ([#1018](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1018)) ([660ddc9](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/660ddc9afc9ed8a308d9388a08eff3c36af551a0))

## [17.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v16.1.0...v17.0.0) (2021-09-28)


### ⚠ BREAKING CHANGES

* Minimum beta provider version increased to v3.79.0.

### Features

* Add support for gVisor per node pool ([#1001](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1001)) ([850c418](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/850c4181ec936f08c1617e4947f85e99c4de74ee))
* Add support for setting additional `pod_range` to beta node pools ([#984](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/984)) ([9d1274f](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9d1274f9dc7cf3ed8d22690c7cd0fda08265da84))
* Promote authenticator_security_group to GA modules ([#989](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/989)) ([6042fd6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6042fd68d4562d9ecc5b7d8b8ac0ad41f153e4b2))


### Bug Fixes

* Delete bundle.hcl ([#981](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/981)) ([b910639](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b9106391e458a69091b497f135cfdc10efdcbdf0))
* Use provided gcp_given_name for workload identity ([#1003](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1003)) ([d72e595](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d72e59510f9be06a7e183449b253af04a7ca2c98)), closes [#1002](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1002)
* WI GCP SA output ([#1009](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1009)) ([b431aa5](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b431aa5d7dc1f0809107429e0d4f19bb7c2ac83f))

## [16.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v16.0.1...v16.1.0) (2021-08-14)


### Features

* add enable_namespace_creation flag for ASM module ([#968](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/968)) ([8764b76](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8764b76a25be911501e6f30bc498fc2bda03ea84))


### Bug Fixes

* Use provided k8s service account name when setting up workload identity ([#972](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/972)) ([e00286f](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e00286fc23b5718587d630f1766d33559608250d))
* WI conditionally invoke data source if using external GSA ([#974](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/974)) ([b208d5c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b208d5cbd2ffd10e7889150428bb17bc1486c686))

### [16.0.1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v16.0.0...v16.0.1) (2021-07-23)


### Bug Fixes

* restore Workload Identity GSA resource name ([#960](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/960)) ([8dbda1a](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8dbda1a9e81e512ff94839cd19066922a7dbb520))

## [16.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v15.0.2...v16.0.0) (2021-07-23)


### ⚠ BREAKING CHANGES

* add gpu node autoscaling support (#807) (#944)

### Features

* add gpu node autoscaling support ([#807](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/807)) ([#944](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/944)) ([e53a949](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e53a949347417c1025eb433bc61c2a3e62e3df1c))
* ASM CA option without providing CA_CERT maps and adding revision_name flag  ([#952](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/952)) ([64b782c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/64b782cb02b18dc6454b1bacb25cdef3ab8b2c8d))
* Enables an existing GSA to be used when setting up Workload Identity ([#955](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/955)) ([712fc54](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/712fc54983eccd072b49a7d75078334ef11baef4))

### [15.0.2](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v15.0.1...v15.0.2) (2021-07-02)


### Bug Fixes

* nap default image in test ([#946](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/946)) ([b12fdb6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b12fdb6611664cb0c63307a9b36b57c555b98178))
* update ASM mode var description ([#910](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/910)) ([a9be73c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a9be73c07a740e597525bf5cf69b17a6752dd756))
* updated GCP APIs in ASM module ([#937](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/937)) ([0c5f363](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0c5f36355471f56e210acfc74aa11d2924c8f28d))

### [15.0.1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v15.0.0...v15.0.1) (2021-06-14)


### Bug Fixes

* Fix typo in local variable ([#925](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/925)) ([d60eec6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d60eec63598a8ff2d39505cd68268cba2af8843b))
* Remove kustomize requirement for ASM ([#930](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/930)) ([389521b](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/389521b77ec3b85380a3155ffd06ae2d4312230e))

## [15.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v14.3.0...v15.0.0) (2021-06-08)


### ⚠ BREAKING CHANGES

* Updated ASM terraform module for 1.8 and 1.9 (#895)
* K8s provider upgrade (#892)
* Add multi-repo support for Config Sync (#872)
* Add support for `enable_l4_ilb_subsetting` flag (#896)
* For beta modules, support for google-beta provider versions older than v3.63 has been removed.

### Features

* Add multi-repo support for Config Sync ([#872](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/872)) ([23da103](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/23da1035cf55bb4a2e371c905387d040a3748ac5))
* Add support for `enable_l4_ilb_subsetting` flag ([#896](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/896)) ([7531f90](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7531f90c943e01238180f0afdc3f0d43b0f04c59))
* Add use local_ssd_ephemeral_count attribute in node_pool config on beta clusters ([#902](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/902)) ([9335262](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/93352625dadf045ea1156f2fc0aab84a8c9a731a))
* K8s provider upgrade ([#892](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/892)) ([9172b3e](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9172b3eaeeb806caca29aa1e3e83e58a26df57b1))
* Updated ASM terraform module for 1.8 and 1.9 ([#895](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/895)) ([e2ba8d2](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e2ba8d221b743e8d092fc2f8e09fd392c882190b))


### Bug Fixes

* Add ability to impersonate service accounts in kubectl for all submodules ([#903](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/903)) ([fc43485](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/fc43485af5cce4a257a40110ffe72df55e13d67b))
* asm destroy ([#922](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/922)) ([f3ddbf5](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f3ddbf5dd298ce2e6c9c858faf68131d62ae9ddb))
* Asm overlay path ([#921](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/921)) ([5d3dc52](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5d3dc52096aa51c5f16f17778ebdd7f0e91d4b19))
* **docs:** Describe `ADVANCED_DATAPATH` in more detail ([#907](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/907)) ([c32c5d1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c32c5d162c5a7ca52a563ecf3e5557c3c4bd32ba))
* Ensure the ASM module's destroy command removes all ASM components ([#918](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/918)) ([00c2b71](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/00c2b719f592455982d8c1eb008b2c40fba98e54))
* switch ASM API and IAM flags to use native resources ([#914](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/914)) ([ff71123](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ff71123a9a238dc2c061ebc25816eb7de9ca433b))

## [14.3.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v14.2.0...v14.3.0) (2021-05-05)


### Features

* Introduce add_master_webhook_firewall_rules flag to add webhooks ([#882](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/882)) ([8a5dcb8](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8a5dcb8ed0c38e5f89eaa4b370f65c431d1c6bb8))
* **workload-identity:** add entire GSA in output ([#887](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/887)) ([734ce5d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/734ce5d285c517a33c9f1881390a1b8f59df0dd1))


### Bug Fixes

* Add cluster ID to outputs ([#886](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/886)) ([fc34eb6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/fc34eb64a1bc117503573894353854a32ff88402))
* Remove data google_client_config from all modules as it is no longer used within modules ([#875](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/875)) ([687dc71](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/687dc719b0596c892b4143656fea7570da90f372))
* Remove unused local kubectl wrapper scripts ([#876](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/876)) ([110adb6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/110adb6ba085a028ae4fa6505959ebef464272a3))

## [14.2.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v14.1.0...v14.2.0) (2021-04-16)


### Features

* Add managed ctrl plane option to ASM module ([#864](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/864)) ([7034f68](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7034f6821904e432b622c76085daa1f226f3a576))


### Bug Fixes

* Correct ConfigManagement hierarchyController definition ([#861](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/861)) ([062bd5e](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/062bd5eb93bdd2ea2e7c3f98324aa0f793e22163))

## [14.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v14.0.1...v14.1.0) (2021-04-01)


### Features

* Default to using cos_containerd image for GKE Sandbox clusters ([#854](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/854)) ([1a2c26e](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/1a2c26e7ebb5d5e553ceb47e5464f59ff96db4bb))

### [14.0.1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v14.0.0...v14.0.1) (2021-03-12)


### Bug Fixes

* Revert attribution fix ([#845](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/845)) ([c398144](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c3981445e1cf886a80f785560aef2f79d6dc4126))

## [14.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v13.1.0...v14.0.0) (2021-03-09)


### ⚠ BREAKING CHANGES

* Added support for multi-project GKE Hub registration (#840)
* The `network_policy` variable now defaults to `false`.
* Replaced `registry_project_id` with `registry_project_ids` list.
* Add support for asm v1.8 to the asm module (#824)

### Features

* Add dataplane-v2 provisioning support ([#753](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/753)) ([d1fbef4](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d1fbef4c9a88f8bf6d1f7e3e8cb9e87811a8a8b0))
* Add new property to explicitly return GKE private_endpoint for auth module ([#841](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/841)) ([1b99c07](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/1b99c078af8cc86a2199bc933ec2da88a4406f87))
* Add support for asm v1.8 to the asm module ([#824](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/824)) ([923eff4](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/923eff44f29b234105c68f183872665deaeaf31a))
* Added support for multi-project GKE Hub registration ([#840](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/840)) ([6dc1eb1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6dc1eb1a79b9ee73873a37d817e3cdc37f8c294e))
* Require actively enabling network policy ([#809](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/809)) ([3354205](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/33542057d8c648d585e81afbe72eec0ca84a4fee))


### Bug Fixes

* Fix attribution for safer cluster modules ([#830](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/830)) ([bb7c3ce](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/bb7c3cee0f81a634a8e9dff7d141ada0cc8cb691))
* Remove deprecated variable "registry_project_id" ([#832](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/832)) ([83eae98](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/83eae9823a6453fa5f6787af8184f306ca53a134))

## [13.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v13.0.0...v13.1.0) (2021-02-16)


### Features

* Add support for creating "shadow" firewall rules for logging purposes ([#741](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/741)) ([259dbfb](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/259dbfbd9eb486710d909d2dc43a54b979d710cf))
* Add support for multiple registry projects ([#815](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/815)) ([5562cd6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5562cd6c993166aa6b0f89b53b618a95f0b14e72))
* Add support for TPUs on beta clusters ([#810](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/810)) ([fff0078](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/fff007887483803101145be79e8f83c6dd288e0e))


### Bug Fixes

* Allow creating zonal clusters when region is not set. ([#806](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/806)) ([f32dea7](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f32dea7003e1a8f32c5f7ecd4e64fdcde8f44956))

## [13.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v12.3.0...v13.0.0) (2021-01-29)


### ⚠ BREAKING CHANGES

* Minimum Terraform core version increased to 0.13.
* dynamic operator yaml (#693)
* Using in-cluster features now requires additional provider configuration. See the upgrade guide for details.

### Features

* Add maintenance exclusions support ([#781](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/781)) ([0abbf41](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0abbf416d393dcae29661ded789a642bb5a9c3f8))
* Add nodepool taints to keepers for update-variant ([#717](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/717)) ([372a11c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/372a11c781479e0387231acfda4a724cdd46cc65))
* add support for Linux node config ([#782](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/782)) ([98826e6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/98826e6029d5510d38121f446c2056ef44ece385))
* Add Terraform 0.13 constraint and module attribution ([#792](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/792)) ([32db990](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/32db990ce7072c310e2b2c954a1f8a06d5de4349))
* Add the option to disable Kubernetes SA annotation in workload-identity. ([#787](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/787)) ([4e4ce02](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4e4ce0287b6169a4554daa93138191844a100496))
* dynamic operator yaml ([#693](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/693)) ([b1cce30](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b1cce3091214389813fd40885f41590f7177edc6))
* Hub registration using kubeconfig and labels support ([#785](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/785)) ([6a29e62](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6a29e6246de05cc01d518eecc15c9e1c21cb8ba9))
* remove wait for cluster script ([#801](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/801)) ([356ed6d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/356ed6d9b31648518c450bc5ed3f542f0a043a26))
* Set auto-provisioned node pools to use configured service account ([#639](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/639)) ([4a61f76](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4a61f7627946489b9ff7e6c0ae978c38c95c5adf))
* Support for ACM for non GKE clusters ([#786](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/786)) ([aa551d5](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/aa551d5b1fdc7bfa0d88bf4562ef5fbfe9da6122))


### Bug Fixes

* Move provider version constraint to required_providers block ([#774](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/774)) ([825f287](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/825f287351b1b7a8c832150072371452ff498bd2))
* Remove provider config from module to be TF 0.13 compatible ([#777](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/777)) ([81b0a94](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/81b0a9491d51546eedc6c1aabd368dc085c16b5e))

## [12.4.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v12.3.0...v12.4.0) (2021-10-18)


### Features

* Backport of [#1001](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1001). Add support for gVisor per node pool ([#1001](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1001)) ([850c418](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/850c4181ec936f08c1617e4947f85e99c4de74ee))

## [12.3.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v12.2.0...v12.3.0) (2020-12-09)


### Features

* Add instance_group_urls output ([#618](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/618)) ([5623d51](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5623d51885b5d3ed44b29264ae86b5d537feb506))
* Enable vertical autoscaling in GA modules ([#758](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/758)) ([2e4f36a](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/2e4f36aef7da1840303ff0a445acc6b560aa8a7c))

## [12.2.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v12.1.0...v12.2.0) (2020-12-04)


### Features

* Add option for CPU manager policy ([#749](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/749)) ([721f846](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/721f846b117e36808c559ed7459561d4beca9e66))
* added notification_config block to beta submodules ([#752](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/752)) ([4a85321](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4a85321214247a1b83e751c45dfd71f4e3c017b1))
* Enable ACM feature on hub ([#722](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/722)) ([c199dae](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c199dae1503e05acecf138e07a892ab22f548b80))
* Grant roles/artifactregistry.reader to created service account when grant_registry_access is true ([#748](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/748)) ([166fb24](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/166fb24220958745567b0fc15f037d3663a7bd0b))


### Bug Fixes

* Make bash scripts more portable by referencing `/usr/bin/env` ([#756](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/756)) ([24d6af6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/24d6af65d6ed58b3ee32a5b26f360a2fd8594ddd))
* Remove max Terraform version constraint, allowing 0.14 compatibility ([#757](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/757)) ([eb95de9](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/eb95de9c63fc98f1fc09554ac8a3e0ed681488ea))

## [12.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v12.0.0...v12.1.0) (2020-11-10)


### Features

* Add cluster_telemetry var to beta submodules ([#728](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/728)) ([e8291f0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e8291f03a1a91c43425177151c8e78d218eed2f1))
* Add support for Cloud Run load balancer configuration ([#740](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/740)) ([685a2db](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/685a2db99f5943c2f74f931cde6923e596896d02))
* Support service account impersonation for wait-for-cluster script ([#729](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/729)) ([75a56f1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/75a56f11c8387cdd8cb4cf9e80024af07d34a92f))


### Bug Fixes

* fallback to name if location is not set ([#736](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/736)) ([63d7f5e](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/63d7f5e7128c9505cc08b9469d6854e9d825ed4b))
* multiple cluster wait-for-cluster.sh ([#734](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/734)) ([6682911](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/66829118db2e1fe946c79d0493bf83ed912b1837))
* Updating the Binary Authorization submodule to allow Terraform 0.13 ([#726](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/726)) ([df98cf9](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/df98cf9ade438bd26d7c2182f2e83f0415a24d53))

## [12.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v11.1.0...v12.0.0) (2020-10-16)


### ⚠ BREAKING CHANGES

* This is a backwards-incompatible release. See the [upgrade guide](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/docs/upgrading_to_v12.0.md) for details.
* GKE Hub functionality has been removed from ASM module(#665). Users can leverage Hub module for this functionality.
* Removed the gcloud_skip_download variable and defaulted to never downloading gcloud. ([#712](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/712)) ([f84e838](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f84e838bf8c8d01f8f60176a2b3140800cf3ec3b))


### Features

* ACM - Wait for gatekeeper & Hub: expose module_depends_on ([#689](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/689)) ([26ea28d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/26ea28db52ce5797da043a1c56dfb4575f49dac8))
* add node_pool_taints to all the modules ([#705](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/705)) ([68e8eec](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/68e8eecaec2d31d19924dec6b4dabc56e2010f0e))
* allow passing roles to created Workload Identity service account ([#708](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/708)) ([e761dce](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e761dcebbe43673842e7f955efcf2cc49e4572fd))
* Expose service account variable on ASM submodule ([#658](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/658)) ([182dded](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/182dded476ddd8eb6f95a800f7a5bb6541c9fcbe))
* hub make decode work with -d or --decode ([#671](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/671)) ([0b5bd3d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0b5bd3d7a1f079ab98bc294f64a4f6b27ee34fc7))
* Hub submodule - add option to use existing service account to register clusters. ([#678](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/678)) ([9f84cec](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9f84cec2b7c28863b79d9eb2586be5bad83252b4))
* Promote previously beta features to GA modules ([#709](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/709)) ([2cb4fae](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/2cb4fae57cb580daba6dc64c7564dcaa7df4efd6)), closes [#708](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/708)
* **ACM:** fix bug when not using `ssh` secret type for ACM submodule ([#679](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/679)) ([716867c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/716867cecbc080674410f9170a0268d193a1da83))
* make wait-for-cluster more robust ([#676](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/676)) ([dffb047](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/dffb04774f81cd0a9e2459c411eb75cde8b705d2))


### Bug Fixes

* Correct WI module source in docs ([#701](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/701)) ([f31b1f4](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f31b1f4b8cd78968c9fbafc48835b14985ecbb26))
* Enable auto-upgrade in beta clusters with a release channel ([#682](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/682)) ([21f95db](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/21f95db0a7737c922224bedf9af255934da5bd6c))
* Fix broken link in README.md ([#691](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/691)) ([6f0e749](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6f0e7494f80af70850e50e35e004516a9e92b85f))
* Fix skip_provisioners enabled flag for wait_for_cluster ([#669](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/669)) ([e293a43](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e293a43d7327d9055fa73aacdf0b977ba0481c48))
* remove hub from asm module ([#670](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/670)) ([6f419c3](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6f419c3f048b4cdaa4d954bf9df1fbd87a0749ae))
* set project number for ASM install ([#692](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/692)) ([c5d1e4d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c5d1e4db2034b4395055322c28abd30248609cba))
* Shorten GSA account_id if necessary ([#666](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/666)) ([0225458](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/02254587d9cf01f138a4096673967402a9ab00fc))

## [11.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v11.0.0...v11.1.0) (2020-09-04)


### Features

* Add variable disable_default_snat ([#625](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/625)) ([19a9e9c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/19a9e9c57b94d1332867a6c29b052e99785e2820))
* Update fields for ACM and Config Sync to bring them to feature parity ([#635](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/635)) ([7fc3b48](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7fc3b488ed6db60fdc081258146270da4dda7ab9))

## [11.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v10.0.0...v11.0.0) (2020-08-10)


### ⚠ BREAKING CHANGES

* In-cluster resources have been updated to use the [kubectl wrapper](https://github.com/terraform-google-modules/terraform-google-gcloud/tree/master/modules/kubectl-wrapper) module. See the [upgrade guide](./docs/upgrading_to_v11.0.md) for details.

### Features

* Add support for enabling master_global_access, which is turned on by default. ([#601](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/601)) ([8a9f904](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8a9f9041c8f18ff7a873873e9b19e03dcdfe7d2a))
* Allow user to customize ASM install with different directories and versions ([#620](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/620)) ([d542c5c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d542c5cc99bf8b47d82c320ad6c9853cfbb1e11c))
* Update modules to use new kubectl module ([#602](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/602)) ([794da61](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/794da61825739bab80cbed486b5e919f79478667))


### Bug Fixes

* Bumped gcloud module to 1.3.0 ([#612](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/612)) ([4d33759](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4d33759bb6e913586f9d0e2705d6eb2fb6c43a23))
* relax version to allow 0.13 ([#621](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/621)) ([dd96aa5](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/dd96aa595090bbd02f6b38fc682ea3de74aca531))

## [10.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v9.4.0...v10.0.0) (2020-07-10)


### ⚠ BREAKING CHANGES

See the [upgrade guide](./docs/upgrading_to_v10.0.md) for details.

* The default machine type has been changed to `e2-medium`. If you want the old default, you should specify it explicitly: `machine_type = "n1-standard-2"`.
* Pod security policy enablement has been changed to use a simple boolean flag (`var. enable_pod_security_policy`)

### Features

* add configconnector to safer variant ([#581](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/581)) ([4b3f609](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4b3f60985ac90265c79a4c5378f8a688f642de96))
* Added variable for service dependency in binary_authorization sub module ([#584](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/584)) ([e3e5458](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e3e5458106bce5e3cc9995c2bc630f476439f71a))
* Changed default node pool machine type to e2-medium ([#597](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/597)) ([1de41ef](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/1de41efafaee7abafbb6b83dc0cb687306bb4d87))


### Bug Fixes

* Compatibility for new asm release with 299.0.0 ([#589](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/589)) ([a5213c4](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a5213c4693dc0494bf70d72d72f875cc318f5fb7))
* Explicitly specify VPC-native clusters for beta modules. ([#598](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/598)) ([d9f7782](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d9f7782235ad43081e745d9d33e7de07b38259d5))
* Simplified pod security policy interface. ([6069ece](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6069ece9cd12acbbba8ff16ab0cbc9b17bc47985))
* Typo in autogen/safer-cluster/README.md ([#596](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/596)) ([ebdf57d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ebdf57dc178e43799f673e1aaa1dba33aa96bcf5))

## [9.4.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v9.3.0...v9.4.0) (2020-06-25)


### Features

* Add ASM install submodule ([#538](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/538)) ([6ff27f9](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6ff27f9da146f8d0d37c8d536b863369bc82d4ab))
* Add bool option for automount_service_account_token ([#571](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/571)) ([002cfb1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/002cfb1a6f2214092adf066611b9be481d066b17))
* Add firewall support safer-cluster modules ([#570](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/570)) ([7ce3c49](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7ce3c497e4c6ddaf2da393d03d82b7f43ab329ee))


### Bug Fixes

* Enhance WI module usability with existing KSA ([#557](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/557)) ([cf3273d](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/cf3273df8428bfed36db76d54ec90aec022c55d5))
* Restore gcloud wait_for_cluster ([#568](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/568)) ([0bcf3ca](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0bcf3ca0dfebcdd99084d43eb6833bb7e55ae434))
* Use gcloud module for scripts, closes [#401](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/401) ([#404](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/404)) ([65172de](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/65172dea06923cb8f2771d06cba5e9ef2547d9da))

## [9.3.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v9.2.0...v9.3.0) (2020-06-11)


### Features

* Add Beta Public Module Update Variant ([#546](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/546)) ([d9f1ea8](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d9f1ea8b50caef249a25a73cd59b9a22183c2922))
* Add ConfigConnector configuration option (beta) ([#547](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/547)) ([672adf9](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/672adf9a94089d2c9dcdd5d2666fcd5a8b4875c3))


### Bug Fixes

* Correct ACM param defaults ([#536](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/536)) ([0b92d27](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0b92d273cc14eb7c7dfe13dbb76e04a33065de04))

## [9.2.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v9.1.0...v9.2.0) (2020-05-27)


### Features

* Add submodule for creating a binary authentication attestor ([#530](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/530)) ([cc30fbb](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/cc30fbbbbcf232c6535156f1e596995e1bd2dcaf))
* Add support for KALM config ([#528](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/528)) ([6bf1178](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6bf1178e3b367a6cc5b9d22adadeb18d1569aff7))


### Bug Fixes

* Add additional guardrails for disabled workload identity. ([#542](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/542)) ([43c4349](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/43c4349788d46a1e973254f4efb87366eb873765))

## [9.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v9.0.0...v9.1.0) (2020-05-15)


### Features

* Add boot disk kms key variable ([#516](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/516)) ([9195f0f](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9195f0fee88a1a58880a5cb768c76acc15c3ee33))
* Expose gce_pd_csi_driver for Safer Cluster modules [#503](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/503) ([#514](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/514)) ([d4e7dc6](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d4e7dc6a585770474ea4cdee3452cf98b404c6e2))


### Bug Fixes

* Update auth module to handle empty clusters ([#521](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/521)) ([dd2afca](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/dd2afca273e32b37b5bcbd98ad42e4f0b633c43a))

## [9.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v8.1.0...v9.0.0) (2020-05-07)


### ⚠ BREAKING CHANGES

See the [upgrade guide](./docs/upgrading_to_v9.0.md) for details.

* Beta clusters have changed the default to use the GKE_METADATA_SERVER, to use the old option set `node_metadata = "SECURE"`.
* Minimum provider change increased to 3.19.
* The ACM module has been refactored and resources will be recreated. This will show up in Terraform plans but is a safe no-op for Kubernetes.
* For the safer cluster module, you must now specify `release_channel` instead of `kubernetes_version`.

### Features

* [safer-cluster] Replace "kubernetes_version" with "release_channel" ([#487](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/487)) ([5791ac1](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5791ac1f64cbd9355a9e2ee96f29d1c5b8686d60))
* Add an `auth` submodule outputting a `kubeconfig` ([#469](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/469)) ([a5ace36](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a5ace360e42ff393a4d49c5018c7ea947b322404))
* Add config sync module ([#493](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/493)) ([c090d5b](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c090d5bd97e954562f5a1f94227e7b9e21724d4b))
* Add fully configurable resource usage export block in GA and upgrade GCP provider ([#491](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/491)) ([54eca6b](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/54eca6b6469517495711c54dab3413003a58a410))
* Add GCE PD CSI Driver beta support ([#497](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/497)) ([d96afa7](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d96afa79fa97f88e8866b54c46c253efd9481ec5))
* Add support for setting firewall rules ([#470](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/470)) ([16bdd6e](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/16bdd6e6310ae248991462494f50876b99a36bbe))
* Enable GKE_METADATA_SERVER as default node_metadata for beta-clusters ([#490](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/490)) ([#512](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/512)) ([8e14762](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8e147627ad53f6a169b38dbd2797bd55a4792c5d))
* Expose the grant_registry_access variable in safer-cluster ([#509](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/509)) ([0961613](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0961613d7e8be391422e5a411801e2737280c2c3))


### Bug Fixes

* Correct identity namespace output for beta clusters ([#500](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/500)) ([c783659](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c783659bb9922d7f8231ac8ba584a4dc805a8288)), closes [#489](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/489)

## [8.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v8.0.0...v8.1.0) (2020-04-10)


### Features

* Add peering_name output for private clusters and increase minimum provider version to 3.14 ([#484](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/484)) ([ff6b5cc](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ff6b5cc24f47b292a4a7a89eda75bb9ffe8ea411))
* Add support for enabling Nodelocal dns cache (var.dns_cache) ([#477](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/477)) ([de8e1d5](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/de8e1d5bdedd22533abcfd11660eb64a5a55f804))


### Bug Fixes

* Add stackdriver.resourceMetadata.writer role for SA to prevent monitoring errors ([#485](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/485)) ([07de70b](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/07de70b0ee3641e6be5e6052a898a9d7eb49a815))

## [8.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v7.3.0...v8.0.0) (2020-04-07)

v8.0.0 is a backwards-incompatible release. Please see the [upgrading guide](./docs/upgrading_to_v8.0.md).

### ⚠ BREAKING CHANGES

* Beta clusters now have Workload Identity enabled by default. To disable Workload Identity, set `identity_namespace = null`
* Beta clusters now have shielded nodes enabled by default. To disable, set `enable_shielded_nodes = false`.

### Features

* Add support for setting var.istio_auth ([#462](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/462)) ([fff4272](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/fff4272b31641814ede6d64d66673060f5daa027))
* Added support for specifying autoscaling_profile in var.cluster_autoscaling ([#456](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/456)) ([1ac2c5c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/1ac2c5c1a090eeb8cd07f88902770637378d1ec8))
* Enable WI and shielded nodes by default in beta clusters ([#441](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/441)) ([704962b](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/704962b1b5408bed8e4102df198eb843b7e8d1d1))
* Rollout default_max_pods_per_node setting to GA modules ([#439](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/439)) ([36ddbbb](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/36ddbbb82d6861689d734e76eeab7c0d162351ce))


### Bug Fixes

* Correct bug in passing var.zones for safer cluster modules ([#474](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/474)) ([7660b51](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7660b5156a740d59958e472ee2faa1637215bf06))
* Fix CI for Workload Identity ([#460](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/460)) ([025f8b7](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/025f8b7eae93651a2c23ef770654782222cd61b7))
* Remove unused variable `service_account` in safer-cluster to avoid confusion ([#448](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/448)) ([a30e7cd](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a30e7cd339f71bbfee5885f12326cf77717daf74))
* update and pin kubernetes provider to >= 1.11.1 ([#453](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/453)) ([418d9b3](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/418d9b30863ed67638bef87602de3910169e1195))
* Use gcloud module for ACM submodule, will force reinstall of ACM ([#442](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/442)) ([9737190](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/97371905789f34ab8e7cda4cd32e17b36fb661c6)), closes [#454](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/454)

## [7.3.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v7.2.0...v7.3.0) (2020-02-19)


### Features

* Add enable_kubernetes_alpha flag for beta clusters ([#437](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/437)) ([f6f7370](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f6f7370a1f8a97604ba5613e40607345d7bc519f))


### Bug Fixes

* Rolled back to basic path routing for networks ([#434](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/434)) ([8571f61](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8571f61dcd35eb4bd06febea9d14b0ed409b2d0e))

## [7.2.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v7.1.0...v7.2.0) (2020-02-11)


### Features

* Add master_ipv4_cidr_block output for private clusters ([#427](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/427)) ([2cc64c8](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/2cc64c8d1e2384ec72f92589c76f5efe378b479d))
* Allow workload identity submodule to update existing k8s SA. ([#430](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/430)) ([51fba38](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/51fba381e67bae686bd709fa2ffaf9d4377866f1))


### Bug Fixes

* Pin Kubernetes provider to 1.10 ([#432](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/432)) ([21d09ae](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/21d09aebb37843e90ac5902c47e0b0439f3924c4))

## [7.1.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v7.0.0...v7.1.0) (2020-02-07)


### Features

* Add new Workload identity [submodule](./modules/workload-identity) ([#417](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/417)) ([b4bcfb9](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b4bcfb9dd45d5f338b8b8366e7a6fc996c1973ae))


### Bug Fixes

* Change for_each splat syntax on update variants, closes [#414](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/414) ([#415](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/415)) ([a20425f](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a20425f74b084ef58abb1560662ef1d83f3beee5))
* If release_channel is active, set min_master_version to null ([#412](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/412)) ([4c7b399](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4c7b3997d4e9ef38ef7c7fd629b7a1ff5ca0418e))
* Prevents "Invalid index" when creating private cluster ([#422](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/422)) ([cc53d1c](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/cc53d1c5464ed4dfbc1e2c166aeaa93a2f79b561)), closes [#419](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/419)
* Stop warning about deprecated external references from destroy provisioners. ([#420](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/420)) ([c8fde26](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c8fde26dace1311163bee74fe61e67aa705a2245))

## [7.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v6.2.0...v7.0.0) (2020-01-29)


### ⚠ BREAKING CHANGES

* Minimum beta provider version increased to 3.1 to allow surge upgrades.
* Beta clusters now have surge upgrades turned on by default. This behavior can be tuned using the max_surge and max_unavailable inputs.
* Moves node pool state location to allow using for_each on them, see the [upgrade guide](./docs/upgrading_to_v7.0.md) for details.

### Features

* Add a service activation module ([#146](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/146)) ([658ea51](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/658ea516965b18d7c161f89ede32b29e6113fd00))
* Enable Surge Upgrades by specifying max_surge and max_unavailable (Beta) ([#394](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/394)) ([e4abe78](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e4abe78279ef100aeb6e4ddc0bde58cabc90acc0))
* Move to using for_each for node pools ([#257](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/257)) ([7d0c9aa](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7d0c9aaa9c815b933ada882f274b9b1293b59716))


### Bug Fixes
* Change pod_security_policy_config type to list(object()) ([#408](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/408)) ([a99352a](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a99352affaa48b42a653d399685abd1395614685))
* Removed dependency on jq from wait-for-cluster.sh script ([#402](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/402)) ([d2a5e28](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d2a5e28004963062bacc79687ff4fc14826639ee))

## [v6.2.0] - 2019-12-27

### Fixed

- **Breaking**: Changed default logging and monitoring providers to new Stackdriver versions. [#384](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/387)

### Changed
- Updated to support Google Provider version 3.x [#381](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/381)

## [v6.1.1] - 2019-12-04

### Fixed

- Fix endpoint output for private clusters where `private_nodes=false`. [#365](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/365)

## [v6.1.0] - 2019-12-03

### Added
- Support for using a pre-existing Service Account with the ACM submodule. [#346](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/346)

### Fixed
- Compute region output for zonal clusters. [#362](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/362)

## [v6.0.1] - 2019-12-02

### Fixed

- The required Google provider constraint has been relaxed to `~> 2.18` (>= 2.18, <3.0). [#359]

## [v6.0.0] - 2019-11-28

v6.0.0 is a backwards-incompatible release. Please see the [upgrading guide](./docs/upgrading_to_v6.0.md).

### Added

* Support for Shielded Nodes beta feature via `enabled_shielded_nodes` variable. [#300]
* Support for setting node_locations on node pools. [#303]
* Fix for specifying  `node_count` on node pools when autoscaling is disabled. [#311]
* Added submodule for installing Anthos Config Management. [#268]
* Support for `local_ssd_count` in node pool configuration. [#339]
* Wait for cluster to be ready before returning endpoint. [#340]
* `safer-cluster` submodule. [#315]
* `simple_regional_with_networking` example. [#195]
* `release_channel` variable for beta submodules. [#271]
* The `node_locations` attribute to the `node_pools` object for beta submodules. [#290]
* `private_zonal_with_networking` example. [#308]
* `regional_private_node_pool_oauth_scopes` example. [#321]
* The `cluster_autoscaling` variable for beta submodules. [#93]
* The `master_authorized_networks` variable. [#354]

### Changed

* The `node_pool_labels`, `node_pool_tags`, and `node_pool_taints` variables have defaults and can be overridden within the
  `node_pools` object. [#3]
* `upstream_nameservers` variable is typed as a list of strings. [#350]
* The `network_policy` variable defaults to `true`. [#138]

### Removed

* **Breaking**: Removed support for enabling the Kubernetes dashboard, as this is deprecated on GKE. [#337]
* **Breaking**: Removed support for versions of the Google provider and the Google Beta provider older than 2.18. [#261]
* **Breaking**: Removed the `master_authorized_networks_config` variable. [#354]

### Fixed

* `identity_namespace` output depends on the `google_container_cluster.primary` resource. [#301]
* Idempotency of the beta submodules. [#326]

## [v5.1.1] - 2019-10-25

### Fixed

* Fixed bug with setting up sandboxing on nodes. [#286]

## [v5.1.0] - 2019-10-24

### Added

* Added ability to skip local-exec provisioners. [#258]
* Added [private](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/private-cluster-update-variant) and [beta private](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-private-cluster-update-variant) variants which allow node pools to be created before being destroyed. [#256]
* Add a parameter `registry_project_id` to allow connecting to registries in other projects. [#273]

### Changed

* Made `region` variable optional for zonal clusters. [#247]
* Made default metadata, labels, and tags optional. [#282]

### Fixed

* Authenticate gcloud in wait-for-cluster.sh using value of `GOOGLE_APPLICATION_CREDENTIALS`. [#284] [#285]

## [v5.0.0] - 2019-09-25
v5.0.0 is a backwards-incompatible release. Please see the [upgrading guide](./docs/upgrading_to_v5.0.md).

The v5.0.0 module requires using the [2.12 version](https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#2120-august-01-2019) of the Google provider.

### Changed

* **Breaking**: Enabled metadata-concealment by default [#248]
* All beta functionality removed from non-beta clusters, moved `node_pool_taints` to beta modules [#228]

### Added
* Added support for resource usage export config [#238]
* Added `sandbox_enabled` variable to use GKE Sandbox [#241]
* Added `grant_registry_access` variable to grant Container Registry access to created SA [#236]
* Support for Intranode Visbiility (IV) and Veritical Pod Autoscaling (VPA) beta features [#216]
* Support for Workload Identity beta feature [#234]
* Support for Google Groups based RBAC beta feature [#217]
* Support for disabling node pool autoscaling by setting `autoscaling` to `false` within the node pool variable. [#250]

### Fixed

* Fixed issue with passing a dynamically created Service Account to the module. [#27]

## [v4.1.0] 2019-07-24

### Added

* Support for GCE cluster resource_labels. [#210]

### Changed

* `endpoint` output depends on cluster and node pool resources to avoid a race condition. [#214]

## [v4.0.0] 2019-07-12

### Changed

* Supported version of Terraform is 0.12. [#177]

## [v3.0.0] - 2019-07-08
v3.0.0 is a breaking release. Refer to the
[Upgrading to v3.0 guide][upgrading-to-v3.0] for details.

### Added

* Add configuration flag for enable BinAuthZ Admission controller [#160] [#188]
* Add configuration flag for `pod_security_policy_config` [#163] [#188]
* Support for a guest accelerator in node pool configuration. [#197]
* Support to scale the default node cluster. [#149]
* Support for configuring the network policy provider. [#159]
* Support for database encryption. [#165]
* Submodules for public and private clusters with beta features. [#124] [#188] [#203]
* Support for configuring cluster IPv4 CIDRs. [#193]
* Support for configuring IP Masquerade. [#187]
* Support for v2.9 of the Google providers. [#198]
* Support for upstreamNameservers. [#207]

### Fixed

* Dropped support for versions of the Google provider earlier than v2.9; these versions multiple
  incompatibilities with the module. [#198]

## [v2.1.0] - 2019-05-30

### Added

* Support for v2.6 and v2.7 of the Google providers. [#152]
* `deploy_using_private_endpoint` variable on `private-cluster`
  submodule. [#136]

### Fixed

* The dependency on jq has been documented in the README. [#151]

## [v2.0.1] - 2019-05-01

### Fixed

* Explicitly pinned supported version of Terraform Google provider to
  2.3. [#148]

## [v2.0.0] - 2019-04-12
v2.0.0 is a breaking release. Refer to the
[Upgrading to v2.0 guide][upgrading-to-v2.0] for details.

### Added

* Add `basic_auth_username` set to `""` by default. [#40]
* Add `basic_auth_password` set to `""` by default. [#40]
* Add `issue_client_certificate` set to `false` by default. [#40]
* Add `node_pool_oauth_scopes` which enables overriding the default
  node pool OAuth scopes. [#94]

### Changed

* The `service_account` variable defaults  to `"create"` which causes a
  cluster-specific service account to be created.
* Disabled Basic Authentication by default. [#40]

## [v1.0.1] - 2019-04-04

### Added

* Note about using Terraform with private clusters. [#121]

### Changed

* Optimized dependency between node pools and primary cluster. [#77]
* Removed `credentials_path` variables from examples. [#89]

### Fixed

* Fix empty zone list. [#132]

## [v1.0.0] - 2019-03-25
Version 1.0.0 of this module introduces a breaking change: adding the `disable-legacy-endpoints` metadata field to all node pools. This metadata is required by GKE and [determines whether the `/0.1/` and `/v1beta1/` paths are available in the nodes' metadata server](https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata#disable-legacy-apis). If your applications do not require access to the node's metadata server, you can leave the default value of `true` provided by the module. If your applications require access to the metadata server, be sure to read the linked documentation to see if you need to set the value for this field to `false` to allow your applications access to the above metadata server paths.

In either case, upgrading to module version `v1.0.0` will trigger a recreation of all node pools in the cluster.

### Added
* Allow creation of service accounts. [#80]
* Add support for private clusters via submodule. [#69]
* Add `remove_default_node_pool` set to `false` by default. Fixes [#15]. [#55]
* Allow arbitrary key-value pairs to be set on node pool metadata. [#52]
* Add `initial_node_count` parameter to node_pool block. [#60]
* Added `disable_legacy_metadata_endpoints` parameter. [#114]

### Changed

* Set `horizontal_pod_autoscaling` to `true` by default.
  Fixes [#42]. [#54]
* Update simple-zonal example GKE version to supported version. [#49]
* Drop explicit version from simple_zonal example. [#74]
* Remove explicit versions from test cases and examples. [#62]
* Set up submodule structure for public and private clusters. [#61]
* Update the google and google-beta providers to v2.2 [#106]

### Fixed
* Zonal clusters can now accept a single zone. Fixes [#43]. [#50]
* Fix link to "configure a service account" [#73]
* Fix issue with regional cluster roll outs causing version skews [#108]
* Fix permanent metadata skew due to disable-legacy-endpoints keys [#114]

## [v0.4.0] - 2018-12-19
### Added
* Added support for testing with kitchen-terraform. [#33]
* Added support for preemptible nodes. [#38]

### Changed
* Updated default version to `1.10.6`. [#31]

### Fixed
* `region` argument on google_compute_subnetwork caused errors. [#22]
* Added check to wait for GKE cluster to be `READY` before completing. [#46]

## [v0.3.0] - 2018-10-10
### Changed
* Updated network/subnetwork lookup to use data source. [#16]
* Make zone configuration optional when creating a regional cluster. [#19]

## [v0.2.0] - 2018-09-26

### Added

* Support for configuring master authorized networks. [#10]
* Support specifying monitoring and logging services. [#9]

## v0.1.0 - 2018-09-12

### Added

* Initial release of module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v6.2.0...HEAD
[v6.2.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v6.1.1...v6.2.0
[v6.1.1]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v6.1.0...v6.1.1
[v6.1.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v6.0.1...v6.1.0
[v6.0.1]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v6.0.0...v6.0.1
[v6.0.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v5.1.0...v6.0.0
[v5.2.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v5.1.1...v5.2.0
[v5.1.1]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v5.1.0...v5.1.1
[v5.1.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v5.0.0...v5.1.0
[v5.0.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v4.1.0...v5.0.0
[v4.1.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v4.0.0...v4.1.0
[v4.0.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v3.0.0...v4.0.0
[v3.0.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v2.1.0...v3.0.0
[v2.1.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v2.0.1...v2.1.0
[v2.0.1]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v2.0.0...v2.0.1
[v2.0.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v1.0.1...v2.0.0
[v1.0.1]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v0.4.0...v1.0.0
[v0.4.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v0.1.0...v0.2.0

[#359]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/359
[#354]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/354
[#350]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/350
[#340]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/340
[#339]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/339
[#337]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/337
[#326]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/326
[#321]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/321
[#315]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/315
[#311]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/311
[#308]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/308
[#303]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/303
[#301]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/301
[#300]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/300
[#290]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/290
[#286]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/286
[#285]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/285
[#284]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/284
[#282]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/282
[#273]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/273
[#271]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/271
[#268]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/268
[#261]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/261
[#258]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/258
[#256]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/256
[#248]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/248
[#247]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/247
[#228]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/228
[#238]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/238
[#241]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/241
[#250]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/250
[#236]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/236
[#217]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/217
[#234]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/234
[#27]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/27
[#216]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/216
[#214]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/214
[#210]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/210
[#207]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/207
[#203]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/203
[#198]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/198
[#197]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/197
[#195]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/195
[#193]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/193
[#188]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/188
[#187]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/187
[#177]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/177
[#165]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/165
[#163]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/163
[#160]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/160
[#159]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/159
[#152]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/152
[#151]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/151
[#149]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/149
[#148]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/148
[#138]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/138
[#136]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/138
[#136]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/136
[#132]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/132
[#124]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/124
[#121]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/121
[#109]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/109
[#108]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/108
[#106]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/106
[#94]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/94
[#93]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/93
[#89]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/89
[#80]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/80
[#77]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/77
[#74]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/74
[#73]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/73
[#61]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/61
[#69]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/69
[#62]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/62
[#60]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/60
[#55]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/55
[#54]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/54
[#52]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/52
[#50]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/50
[#49]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/49
[#46]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/46
[#43]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/43
[#42]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/42
[#40]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/40
[#38]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/38
[#33]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/33
[#31]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/31
[#22]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/22
[#19]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/19
[#16]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/16
[#15]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/15
[#10]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/10
[#9]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/9
[#3]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/3

[upgrading-to-v2.0]: docs/upgrading_to_v2.0.md
[upgrading-to-v3.0]: docs/upgrading_to_v3.0.md
[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
[3.0.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/3.0.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
