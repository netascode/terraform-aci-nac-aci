## 0.2.12 (unreleased)

- Add support for EIGRP

## 0.2.11

- Add option to specify `mode` for SVI interfaces

## 0.2.10

- Add support for SR MPLS

## 0.2.9

- Add `autostate` option for SVIs
- Add support for floating SVIs for VMware VMM domains

## 0.2.8

- Fix issue with BGP `connectivityType` parameter

## 0.2.7

- Fix issue with BGP `connectivityType` parameter

## 0.2.6

- Add `remote_leaf` variable
- Add `multipod` variable

## 0.2.5

- Make the BGP peer `password` variable sensitive
- Make the `ospf_authentication_key` variable sensitive

## 0.2.4

- Fix issue with `next_hop_self` attribute

## 0.2.3

- Enable secondary (shared) IP for non-vPC SVI interfaces

## 0.2.2

- Fix floating SVI objects

## 0.2.1

- Add support for PIM policy
- Add support for IGMP interface policy
- Add support for QoS class
- Add support for custom QoS policy
- Add support for floating SVI
- Add multiple options to BGP peers

## 0.2.0

- Update to support new Terraform 1.3 `optional` syntax

## 0.1.0

- Migrate to devnet provider

## 0.0.4

- Update implicit resource dependencies

## 0.0.3

- Enable unicastv4 and multicastv4 address families for BGP peers

## 0.0.2

- Set BGP weight to 0 by default

## 0.0.1

- Initial release
