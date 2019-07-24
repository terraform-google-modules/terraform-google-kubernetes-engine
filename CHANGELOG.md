# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [Unreleased]

## [v4.1.0] 2019-07-24

### Added

* Support for GCE cluster resource_labels. [#210]

### Changed

* `endpoint` output depends on cluster and node pool resources to avoid a race condition. [#214]

## [v4.0.0] 2019-07-12

### Changed

* Supported version of Terraform is 0.12. [#177]

## [v3.0.0] - 2019-07-08

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

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v4.1.0...HEAD
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

[#214]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/214
[#210]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/210
[#207]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/207
[#203]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/203
[#198]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/198
[#197]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/197
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
[#136]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/136
[#132]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/132
[#124]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/124
[#121]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/121
[#109]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/109
[#108]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/108
[#106]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/106
[#94]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/94
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
