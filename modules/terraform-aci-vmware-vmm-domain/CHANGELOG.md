## 0.2.7

- Fix validation of `delimiter` and ELAG `name` variables

## 0.2.6

- Add support for security domains

## 0.2.5

- Fix conditional provisioning of `vmmRsVswitchOverrideMtuPol` object

## 0.2.4

- Add `vswitch_mtu_policy` variable

## 0.2.3

- Make the `password` variable sensitive

## 0.2.2

- Add enhanced LAG configuration
- Add uplink configuration

## 0.2.1

- Fix regex validation of vCenter username to allow for `domain\username` format

## 0.2.0

- Update to support new Terraform 1.3 `optional` syntax

## 0.1.0

- Migrate to devnet provider

## 0.0.3

- Update implicit resource dependencies

## 0.0.2

- BREAKING CHANGE: refactor vswitch variables
- BREAKING CHANGE: rename mgmt_epg variable to mgmt_epg_type
- BREAKING CHANGE: remove inband_epg variable and add mgmt_epg_name variable

## 0.0.1

- Initial release
