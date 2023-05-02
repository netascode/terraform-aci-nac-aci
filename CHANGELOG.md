## 0.7.0 (unreleased)

- Initial release

### Changes compared to previous releases of individual modules

These are the changes compared to the previous releases of the following modules:

- `terraform-aci-nac-tenant` v0.4.1
- `terraform-aci-nac-access-policies` v0.4.0
- `terraform-aci-nac-fabric-policies` v0.4.1
- `terraform-aci-nac-pod-policies` v0.4.0
- `terraform-aci-nac-node-policies` v0.4.0
- `terraform-aci-nac-interface-policies` v0.4.0

List of changes:

- Add support for custom L2 MTU policies
- Add support for VMware VMM domain vSwitch MTU policy
- Add support for static routes to inband EPGs
- Add support for static routes to out-of-band EPGs
- Add support for external TEP pools
- Add support for remote pools
- Add support for pod unicast TEP
- Add `multipod` and `remote_leaf` flags to L3outs
- Fix issue with inband node addresses and ACI 6.x
- Add `autostate` option to L3out SVI interfaces
- Add `proxy_arp` option to EPGs
- Add support for floating SVIs with VMware VMM domains
- Support IPv6 address for smart licensing proxy
- Fix issue with BGP address family context policy and ACI 4.2
