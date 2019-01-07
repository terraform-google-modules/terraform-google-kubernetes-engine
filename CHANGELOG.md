# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
* Set `horizontal_pod_autoscaling` to `true` by default. #42
* Add `remove_default_node_pool` set to `false` by default #15

## [v0.4.0] - 2018-12-19
### Added
* Added support for testing with kitchen-terraform. #33
* Added support for preemptible nodes. #38

### Changed
* Updated default version to `1.10.6`. #31

### Fixed
* `region` argument on google_compute_subnetwork caused errors. #22
* Added check to wait for GKE cluster to be `READY` before completing. #46

## [v0.3.0] - 2018-10-10
### Changed
* Updated network/subnetwork lookup to use data source. #16
* Make zone configuration optional when creating a regional cluster. #19

## [v0.2.0] - 2018-09-26

### Added

* Support for configuring master authorized networks. (#10)
* Support specifying monitoring and logging services. (#9)

## [v0.1.0] - 2018-09-12

### Added

* Initial release of module.
