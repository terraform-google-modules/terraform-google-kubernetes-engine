# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

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
