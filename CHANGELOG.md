# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [26.1.1](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v26.1.0...v26.1.1) (2023-05-22)


### Bug Fixes

* correct TPG version constraint ([#1637](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1637)) ([#1640](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1640)) ([14eac9f](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/14eac9f91a90245d3e00d05a8653f334eb8966ec))

## [26.1.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v26.0.0...v26.1.0) (2023-05-16)


### Features

* Add timeouts variable for safer cluster module ([#1613](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1613)) ([146b2e7](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/146b2e7b0a3385a5f0864a003abd8bee8bec2bc7))


### Bug Fixes

* allow ACM module to work w/o metrics sa ([#1634](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1634)) ([83a8be2](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/83a8be24ee1bf84371714f49f8c904d3d94492d6))
* avoid TPG 4.65.0 and 4.65.1 ([#1637](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1637)) ([ea3e374](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ea3e374bbf99c86189b5ca428d6c2a2f07bd1e16))

## [26.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v25.0.0...v26.0.0) (2023-05-10)


### ⚠ BREAKING CHANGES

* set release_channel and auto_upgrade, drop meshtelemetry ([#1618](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1618))
* **kubernetes ~> 2.13:** Remove 1.23 restriction on workload identity module ([#1595](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1595))
* **acm:** prevent conflicts in IAM binding ([#1576](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1576))

### Features

* add blue/green upgrade strategy settings ([#1551](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1551)) ([db51271](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/db5127141d12616eff8b816890c542a8c51605cf))
* add enable_private_nodes options to node_pool network_config ([#1604](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1604)) ([48d7590](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/48d7590c2e09f6cd178966f9f764c6bd04bfb73f))
* allow setting network tags on autopilot clusters ([#1572](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1572)) ([23e9c96](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/23e9c96e0b8b50eecb40b3948804e01df6f05e92))
* Workload Identity module, to bind roles in various projects for the service account created ([#1574](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1574)) ([53f0f58](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/53f0f58d5f0b2dbdcf429b101e5c577781cb3c39))


### Bug Fixes

* **acm:** prevent conflicts in IAM binding ([#1576](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1576)) ([a7cfe92](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a7cfe92af494abaf2960b0819a3ac6023d2a78dd))
* Autopilot vertical pod autoscaling ([#1564](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1564)) ([6853c61](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6853c617614f332d6e051d2c9c2a7acca84253f5))
* fixes for tflint and dev-tools 1.10 ([#1598](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1598)) ([d012313](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d01231355689ab13c779b70b1656758d468fb944))
* **kubernetes ~> 2.13:** Remove 1.23 restriction on workload identity module ([#1595](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1595)) ([b23bc86](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b23bc860bbae21a92e7f008856deec62c408518b))
* node_metadata mapping for GCE_METADATA ([#1542](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1542)) ([#1543](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1543)) ([b03ea84](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b03ea84a1f5bbbc7bd56098cbe1c6905dd581259))
* nodepool autoscaling vars avail in GKE 1.24.1 result in conflicts. Preserve default behavior ([#1562](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1562)) ([98e8dc3](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/98e8dc3f9aaa897da477cc3bca959c7c95473983))
* PSP removed in GKE &gt;= 1.25.0 ([#1622](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1622)) ([530f16b](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/530f16b8f52abd14540d8bd69c662bd64d04ae19))
* set release_channel and auto_upgrade, drop meshtelemetry ([#1618](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1618)) ([3c8dd3a](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/3c8dd3afcd8c3d6c7ccd034f732cf82738a14eab))
* use provided service_account_name if available ([#1610](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1610)) ([a42ed88](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a42ed88a347a06490db2c05e45564e4092c1ada7))

## [25.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v24.1.0...v25.0.0) (2023-02-03)


### ⚠ BREAKING CHANGES

* Promote node sysctl config to GA ([#1536](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1536))
* enable auto repair and upgrade with cluster autoscaling ([#1530](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1530))
* support for gateway api for safer cluster variants ([#1523](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1523))
* promote gke_backup_agent_config to ga ([#1513](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1513))
* enable private nodes with specified pod ip range ([#1514](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1514))
* Promote managed_prometheus to GA ([#1505](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1505))
* support for gateway api ([#1510](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1510))
* Add option to pass `resource_labels` to NP ([#1508](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1508))
* promote gce_pd_csi_driver to GA ([#1509](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1509))
* Set the provided SA when creating autopilot clusters ([#1495](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1495))

### Features

* add all pod_ranges to cluster firewall rules and add missing shadow rules ([#1480](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1480)) ([bcd5e03](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/bcd5e03ff2514c79c906ef5c15cc793aa3c7426f))
* Add option to pass `resource_labels` to NP ([#1508](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1508)) ([e7566c5](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e7566c592d6a73aeb56762789aeaea072d2bb6ff))
* add support for policy bundles and metrics SA ([#1529](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1529)) ([0f63eab](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0f63eab5163a460d485346e2a37992a1b29dc082))
* promote gce_pd_csi_driver to GA ([#1509](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1509)) ([ac062f8](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ac062f81e754c52bc785628fe0b2f0442a126599))
* promote gke_backup_agent_config to ga ([#1513](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1513)) ([966135f](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/966135f2d201d2d05032f31753c87e4f7d43b00a))
* Promote managed_prometheus to GA ([#1505](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1505)) ([9c77c6c](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9c77c6c73c7718cfe793e65b946b5a1048f04f71))
* Promote node sysctl config to GA ([#1536](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1536)) ([754f4e3](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/754f4e367bd43140f48897fc1d3bfdf9e7d4dfce))
* Set the provided SA when creating autopilot clusters ([#1495](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1495)) ([d122a55](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d122a55f82c0625ca88ffb1055d758406d902cd1))
* support for gateway api ([#1510](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1510)) ([4181276](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4181276635dd16d334a2787ae10e5f0bba0df253))
* support for gateway api for safer cluster variants ([#1523](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1523)) ([912da8c](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/912da8c97082d08f4fef96e82bbdf6a76dad006b))


### Bug Fixes

* auth module avoid TPG v4.49.0 ([#1535](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1535)) ([95c5c11](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/95c5c11e4f5856c408b7a1dffa00fa1acac8a5b2))
* auth module avoid TPG v4.50.0 ([#1541](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1541)) ([c3e08ea](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c3e08eaa8418fcf9df54d61692c4c7df97ea6968))
* avoid TGP v4.49.0 for asm ([#1537](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1537)) ([5d3d54e](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5d3d54e5a2325443515041342f77c7ecdadba2a1))
* enable auto repair and upgrade with cluster autoscaling ([#1530](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1530)) ([d59542c](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d59542c8482709028fda0ec53d7bef8749e6a055))
* enable private nodes with specified pod ip range ([#1514](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1514)) ([8190439](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8190439f33b6b525fe930b1bfcdc65762d8652ab))
* remove datapath provider from Autopilot modules ([#1556](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1556)) ([ea012f5](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ea012f5c57a79c9de56f529dd9cc2ea9d3673838))
* support custom service account for autopilot ([#1550](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1550)) ([52e25ab](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/52e25ab2c929777fddada40c0c0a03ac03ae75ec))
* Update variable validation description ([#1518](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1518)) ([d985879](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d985879b4bb8d995dca04bed9cdfa541914ffa69))

## [24.1.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v24.0.0...v24.1.0) (2022-12-14)


### Features

* Allow enabling cost management for safer_cluster module ([#1475](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1475)) ([8507e09](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8507e09b732568ef3e66a1492ea6c73835b40120))

## [24.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v23.3.0...v24.0.0) (2022-11-21)


### ⚠ BREAKING CHANGES

* cost_management_config is out of beta now (#1470)
* update variant - recreate node pools on max_pods_per_node or pod_range change (#1464)
* expose global master access in GA modules (#1421)
* min tpb bump for location_policy
* min TPG bump for location_policy (#1453)
* add service_external_ips option (#1441)
* Adding Support for Cost Allocation Feature in Beta (#1413)
* add boot_disk_kms_key variable for node pools to GA modules (#1371)

### Features

* add boot_disk_kms_key variable for node pools to GA modules ([#1371](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1371)) ([d9a44c6](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d9a44c60198e2bea72aa1f36c5dbe34e59416dbf))
* add location_policy and fix permadiff ([#1452](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1452)) ([aecccf0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/aecccf0bb8ca950fab5598ce8ec4b91f45dcb4a9))
* add nodepool autoscaling vars avail in GKE 1.24.1 ([#1415](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1415)) ([f57f3ce](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f57f3ce58de14076a03182aa3b37aae58beac29a))
* add service_external_ips option ([#1441](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1441)) ([e9de006](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e9de006f535e67a311a01e60a554c636f127fafa))
* Add support for https_proxy parameter for the config_sync.git block ([#1457](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1457)) ([43bbd3c](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/43bbd3c7ac48560e76a6ad2448d8e1901f9d4e4a))
* Adding Support for Cost Allocation Feature in Beta ([#1413](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1413)) ([ba3dcd0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ba3dcd0b617ff82367c5fbaffa5dc76e6f9f2cb1))
* cost_management_config is out of beta now ([#1470](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1470)) ([10ea608](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/10ea6081c532aa0bcd5fdd8addbb15fedfe18ee0))
* expose global master access in GA modules ([#1421](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1421)) ([4278f2c](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4278f2cd2dfc81ae71230162d53ec30401a5e54f))
* Make creation of istio-system namespace optional ([#1439](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1439)) ([335c62a](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/335c62a546f9b35b6825783e004c46f3d5f2440b))
* update variant - recreate node pools on max_pods_per_node or pod_range change ([#1464](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1464)) ([b006593](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b006593cf9d81ca018468ad440c70509fdcef082))


### Bug Fixes

* location-policy permadrifting [#1445](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1445) ([aecccf0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/aecccf0bb8ca950fab5598ce8ec4b91f45dcb4a9))
* min tpb bump for location_policy ([0ddd297](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0ddd297a1d57cd4e58849e780d592147eac24321))
* min TPG bump for location_policy ([#1453](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1453)) ([0ddd297](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0ddd297a1d57cd4e58849e780d592147eac24321))

## [23.3.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v23.2.0...v23.3.0) (2022-10-28)


### Features

* move vpa out of beta ([df16cda](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/df16cda06d692842ac124bb1bb28353656ee9205))


### Bug Fixes

* Exposing VPA to GA module ([#1404](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1404)) ([df16cda](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/df16cda06d692842ac124bb1bb28353656ee9205))
* incorrect `node_pools` variable type ([#1424](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1424)) ([faaee19](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/faaee19d4989cb974d61f6a3f35f6f5b0a866848))
* Truncating hub membership ID when greater than 63 character ([#1429](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1429)) ([0c5660d](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0c5660d8399fc0a236eff0dbdfeacef5d5ca7706))
* use dynamic block for accelerators, updates for CI ([#1428](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1428)) ([0304a20](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0304a2074bf9d9d8e4b23b52448837c216e3d03b))

## [23.2.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v23.1.0...v23.2.0) (2022-09-27)


### Features

* add support for provisioning windows node pools ([92d7c67](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/92d7c67bc656e1caddb9a5f3771fab54e84e1ee5))
* Allow configuring cluster_autoscaling for safer cluster variants ([#1407](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1407)) ([a661eea](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a661eeabaf7f430df77933be1d9d27f699239be6))

## [23.1.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v23.0.0...v23.1.0) (2022-09-08)


### Features

* add enable_referential_rules variable ([#1394](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1394)) ([1fd7184](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/1fd7184c5be51d183908499d3cb2392b551031a4))
* adds placement policy argument to the beta modules ([#1385](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1385)) ([c0f5881](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c0f588194b1845f51db6ee04253393b38b35faa5))
* Allow enabling GKE backup agent for safer cluster variants ([#1367](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1367)) ([5fb077d](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5fb077dee404e8669c256961c4ba26904d321db6))
* cloud dns support for safer clusters ([#1384](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1384)) ([4e817be](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4e817be3f09fe45f095c6b3debf755005efb9ac3))
* enable PoCo referential_rules for ACM ([#1373](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1373)) ([b9287de](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b9287de679592a2adcae4d98dcfee33a001f328b))

## [23.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v22.1.0...v23.0.0) (2022-08-22)


### ⚠ BREAKING CHANGES

* Increased minimum Google Provider version to 4.29 ([#1353](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1353))
* The new binary_authorization ([#1332](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1332)) may result in the first apply after upgrading taking additional time

### Features

* add module_depends_on to workload-identity ([#1341](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1341)) ([a6dce1a](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a6dce1a491956d536ecf969b3bf22c6dede4da18))
* promote notification config & dns to ga ([#1327](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1327)) ([47b5ff6](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/47b5ff67595b090446d563c406fca89d8f1f7c1e))


### Bug Fixes

* add depends_on to asm module google_container_cluster data resource ([#1365](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1365)) ([9140c60](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9140c60fe51d83fe69500227915b17a9cd01d3cb))
* change asm module depends_on method ([#1354](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1354)) ([300eb1f](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/300eb1f2cee66a5057380967e09d1340e74b545a))
* new binary_authorization ([#1332](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1332)) requires TPG 4.29 ([#1353](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1353)) ([4f0d19e](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4f0d19e46d87f5670f0afbf6f806269b0fc3e775))

## [22.1.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v22.0.0...v22.1.0) (2022-08-02)


### Features

* add `gke_backup_agent_config` arg ([#1316](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1316)) ([cff4428](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/cff44285b5b5f085ff22cfe64fe87e438ac9a90a))
* add module_depends_on for asm sub module ([#1323](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1323)) ([4d526f9](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4d526f930958027d546ef9109eba095553fe7409))
* add var and output for ACM version ([#1322](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1322)) ([35b2bf5](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/35b2bf510232c72ccabfebcc07a3d65885e11786))
* cloud-dns support ([#1317](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1317)) ([4bf0011](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4bf0011202667b6efe8a0b5aea2910f1c3250968))
* expose disable_default_snat in GA modules ([#1336](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1336)) ([a8ea7c7](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a8ea7c7881b77a426c5ab8cedee80ad49c7f7007))
* promote `max_pods_per_node`, `max_surge`, and `max_unavailable` fields to ga ([#1318](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1318)) ([ed64058](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ed64058fa57bf9a9ff6f271f6eb010e5a7e68704))


### Bug Fixes

* resolve deprecation warning for binary authorization ([#1332](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1332)) ([f8a5cca](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f8a5cca510b180ac285183214c0641cf9d0b8a87)), closes [#1331](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1331)
* support explicit k8s version with unspecified release channel ([#1335](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1335)) ([dc1de85](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/dc1de85697d4ee6c7b8f5fd24447fed13ee2eb82))

## [22.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v21.2.0...v22.0.0) (2022-07-11)


### ⚠ BREAKING CHANGES

* Minimum Google/Google Beta provider versions increased to v4.25.0.
* promote Spot VM to GA (#1294)
* support maintenance_exclusion (#1273)

### Features

* Allow enabling managed Prometheus in beta cluster submodules ([#1307](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1307)) ([71e7067](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/71e7067c7b0279a84284cf0713ed77d79c19e86b))
* expose use_existing_context variable in WI module ([#1295](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1295)) ([d802e49](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d802e492832dde1bf2ac01a540c8281dd7c35e49))
* promote Spot VM to GA ([#1294](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1294)) ([274da2f](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/274da2fd594684d2400d29ceff96342be01aebf1))
* support gVNIC ([#1296](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1296)) ([5d6eac1](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5d6eac194e06129306cfeb25552107bd0f8baf55))
* support maintenance_exclusion ([#1273](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1273)) ([425bf93](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/425bf93e60c75a0b238ca3c6aa968000f89a9271))
* Support managed Prometheus for safer cluster variants ([#1311](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1311)) ([55faaf5](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/55faaf51ba9996b9dd3741258524fd642f5c4d8f))
* WorkloadIdenity allow to use k8s sa from the different project ([#1275](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1275)) ([4f5dded](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4f5ddeded6dd2dbe47342a948e1fb2c011002eee))


### Bug Fixes

* Create new node pool when shielded_instance_config changes ([#1237](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1237)) ([a2272f0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a2272f0c158642dd166a14415944a5541c6ff174))
* support managed prometheus for autopilot ([#1310](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1310)) ([568c824](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/568c82468cb611b6425c480799e9a5b3fd5dc252))

## [21.2.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v21.1.0...v21.2.0) (2022-06-22)


### Features

* Add keeper for `enable_secure_boot` nodepool option for update variant. ([#1277](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1277)) ([a8b6f20](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a8b6f2001ac94a24f4e2c7b402e713e1173a999a))
* Add maintenance variables for safer cluster ([#1282](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1282)) ([19f59c4](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/19f59c4d55e0761fac0e37103502c70b90536800))
* expose timeouts ([6011c80](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6011c80f139abeecccaeb157e0a93ab28ceb7aab))
* Recurring maintenance window to GA ([#1262](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1262)) ([4bba52f](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/4bba52f53402b4a32bf744868fdefe2a82f08829))


### Bug Fixes

* source node pools' auto_upgrade configuration from the GKE cluster ([#1293](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1293)) ([c7c9f44](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/c7c9f4448be74687ad43f4e1b080467ddc3ccaec))

## [21.1.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v21.0.0...v21.1.0) (2022-05-24)


### Features

* support database encryption and google group rbac for autopilot ([#1265](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1265)) ([066149d](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/066149d417bc98cff1feefb8edcb16c7f45a2b51))


### Bug Fixes

* convert gcfs_config to dynamic block to prevent node pool recreation ([81686e7](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/81686e7ffb98da59c756691351db1e8ae158c218))
* trim trailing dash from gcp SA name ([#1243](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1243)) ([aee12e7](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/aee12e7175d6adf6d73c3bb5808399537ae56b48))

## [21.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v20.0.0...v21.0.0) (2022-05-12)


### ⚠ BREAKING CHANGES

* update kube-dns configMap using kubernetes_config_map_v1_data (#1214)

### Features

* Add `filestore_csi_driver` option for safer cluster variants ([#1176](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1176)) ([40ef1a1](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/40ef1a178281ab967ed60ddf1a28304a76e8982d))
* Add app.kubernetes.io/created-by label to CPR in ASM module ([#1190](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1190)) ([bbd9b77](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/bbd9b770987b6e8e502ce3747ccc6ce0a96e79c1))
* Add keeper for `enable_gcfs` node pool option for update variants ([#1218](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1218)) ([f431756](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/f4317560c8978b9b4946cc0484fc7f8703a37a38)), closes [#1217](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1217)
* Add support for image streaming/GCFS ([#1174](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1174)) ([3a94528](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/3a94528701a06b99bbb02274c3a75012eeae72ea))
* Add support for internal endpoint with ASM module ([#1219](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1219)) ([8e87308](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8e873089af810b23aaa8b368b31bca737ec61835))
* Switch to native Terraform resources for hub registration and ACM ([#947](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/947)) ([9359961](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/93599618529ba532ad5b118b59497f502a020d4e))
* update kube-dns configMap using kubernetes_config_map_v1_data ([#1214](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1214)) ([8547935](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/85479352a7250ac32eed61a885dad0ccb34bfd3b))


### Bug Fixes

* add output "service_account" to simple_zonal ([9e92318](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9e9231897f7897d684e8231d1dcde7ba120bece8))
* add provider_meta for google-beta to ASM submodule ([#1186](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1186)) ([9f06ef4](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9f06ef4562adcc9096fbf2da6041746d3d08c483))
* Add required kubernetes provider to ASM module ([#1221](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1221)) ([77d08e0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/77d08e02d738c38a5c68987572ef506a987dd41e))
* Apply applicable ASM_OPTS in config_map ([#1183](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1183)) ([79d604a](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/79d604aa40db27e17a679eaf4902fedf6de7cf67))
* ASM module required TF 0.14+ ([#1209](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1209)) ([55a1e15](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/55a1e15ec6ce43eb87185854e5988424e0be2eae))
* make GKE module cluster_name computed attribute ([#1189](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1189)) ([7a09acd](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7a09acdecb0c13657194579ee3446a6e2fe1421e))
* misspellings in comments and min_cpu_platform ([#1207](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1207)) ([7553a2b](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7553a2b760455636b164c2a0cd9f06f23c8a9466))
* Remove unnecessary auth files. ([#1231](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1231)) ([aa47e23](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/aa47e23ec114a4d07cf737c4be60596b00a723cc))
* removed unused variable ip_source_ranges_ssh from example safer_cluster_iap_bastion ([#1199](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1199)) ([5197f22](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5197f2214bff1693a0d469d66f3430a994d6a885))
* set initial_node_count with remove_default_node_pool ([#1228](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1228)) ([151c8c4](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/151c8c4fb3e62fe91762e7b2f7d97f7581b48024))
* set only one of log/mon config or service ([#1240](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1240)) ([2316e77](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/2316e7775ae0322ff72650caca66d6d34a92ec02))
* Use fleet_id instead of project_id for hub operations ([#1238](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1238)) ([a9a69ed](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a9a69edaed7dac3b700ad48309d7922c722609bb))
* various fix to address CI issues ([#1248](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1248)) ([9e92318](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/9e9231897f7897d684e8231d1dcde7ba120bece8))

## [20.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v19.0.0...v20.0.0) (2022-03-10)


### ⚠ BREAKING CHANGES

* Added gcp_filestore_csi_driver_config to addons config (#1166)
* Rewrote ASM module, see the [upgrade guide](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/docs/upgrading_to_v20.0.md) for details (#1140)
* Minimum provider version increased to 4.10.

### Features

* add gcp_filestore_csi_driver_config to addons config ([#1166](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1166)) ([a68fe69](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/a68fe6922fad3f343c9ad075d4433b0a087f7df2))
* Add Identity Service config to beta modules ([#1142](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1142)) ([6a99347](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6a993475c0925887a8b13007202408faeb346926))
* GKE autopilot support ([#1148](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1148)) ([d5ceafb](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d5ceafb8cd8b492169f417e1585bb706e6599750))
* Rewrite ASM module ([#1140](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1140)) ([0d9c44e](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/0d9c44e32057160401322f8c0475016b8bd1c9fe))


### Bug Fixes

* Add missing type attributes to variables ([#1117](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1117)) ([6436339](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/6436339a6342f927801d91bc3ba1818defbb000b))
* ASM module rewrite improvements ([#1165](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1165)) ([2867162](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/2867162c09069fb9763e1e280d25d06b6d3c7689))


### Miscellaneous Chores

* release 20.0.0 ([7976d17](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/7976d17e497e879ecb664e9fe5e7169563bda7a8))

## [19.0.0](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v18.0.0...v19.0.0) (2022-01-31)


### ⚠ BREAKING CHANGES

* Change default node image from COS to COS_CONTAINERD (#1122)
* Add spot vm support to beta clusters (#1131)
* update TPG version constraints to 4.0 (#1129)
* TPU firewall rule split into a separate resource

### Features

* Add spot vm support to beta clusters ([#1131](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1131)) ([ae0d953](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/ae0d9536e006663701202e7e18eb932a8c195dac))
* Allow datapath_provider in GA main module ([#1084](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1084)) ([3b5ddb9](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/3b5ddb92e41e79e900a716326c135e618fa974ec))
* Change default node image from COS to COS_CONTAINERD ([#1122](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1122)) ([e6b9282](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e6b928288cdd79035d32ea84fd8ce6ca40979246))
* update TPG version constraints to 4.0 ([#1129](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1129)) ([d494b0f](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d494b0f1ee346440af3b9c734eceb0f72b804379))


### Bug Fixes

* Allow users to specify network tags for the default node pool ([#1123](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1123)) ([b8b8547](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/b8b854793410473f4f7469d2675d8a58aaffd18a))
* Create separate firewall rule for egress to TPUs ([#1126](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1126)) ([99cfd98](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/99cfd98a523f9410a8dc06503b566f51bfe8b158))
* Removed dependency to obsolete template_file by upgrading to templatefile ([#1119](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1119)) ([14a0536](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/14a0536bbcfeb89dc1af21f8fef0cb46affdc52e))

## [18.0.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v17.3.0...v18.0.0) (2021-12-16)


### ⚠ BREAKING CHANGES

* safer-cluster modules now use ADVANCED_DATAPATH by default. Set `datapath_provider` to `DATAPATH_PROVIDER_UNSPECIFIED` to continue using Dataplane v1.
* Minimum beta provider version increased to v3.87.0.

### Features

* Added monitoring_enabled_components and logging_enabled_components variables to beta clusters ([#1028](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1028)) ([9278265](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/92782657320de244629b50058ac07d7fb808859b))
* Make auto_provisioning_defaults a non-beta feature and set `min_cpu_platform` for auto-provisioned node pools ([#1077](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1077)) ([5603718](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/5603718d81920c141103993abbc72e2080aa2701))
* Use ADVANCED_DATAPATH (aka. Dataplane V2) for safer-cluster modules ([#1085](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1085)) ([41a0c83](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/41a0c83955079464d044adbd52d972fb8d69a909))

## [17.3.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v17.2.0...v17.3.0) (2021-11-23)


### Features

* Add support for `gpu_partition_size` ([#1072](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1072)) ([cff1c1b](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/cff1c1be2658fc88ea793dca73a5156b849050c3))


### Bug Fixes

* ignore ASM labels ([#1061](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1061)) ([3dea235](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/3dea235faaf6b2ff3d54f1c70dca134f8c8ef378))

## [17.2.0](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v17.1.0...v17.2.0) (2021-11-12)


### Features

* Add beta support for confidential_nodes ([#1040](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1040)) ([e105bb5](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/e105bb5b5154b6c77f3256bc4ced28d3b3e26ad1))
* Added support for specifying min_cpu_platform in node config - … ([#1057](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1057)) ([23b5243](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/23b524318c1052d9e39aa183839b28cad8fbe7bc))


### Bug Fixes

* Document grant_registry_access for Artifact Registry ([#1044](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1044)) ([d3ca023](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/d3ca023f5f4ecbcf72ea63097c39254cd0439256))
* pass REVISION_NAME to downstream install script ([#1048](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1048)) ([dd410d7](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/dd410d77bedb62c872ccdb71d51a614f9e5f40b9))
* set image_type, machine_type, and sandboxing on default node pool to comply with validation policies ([#1038](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1038)) ([8e92f6e](https://www.github.com/terraform-google-modules/terraform-google-kubernetes-engine/commit/8e92f6ec0d71bfffee9fa3621b55bbbd9091b0d0))

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
