# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed

* Added suport for private clusters. #21
* Migrated to [google-beta provider](https://github.com/terraform-providers/terraform-provider-google-beta) to support private clusters. #21

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
