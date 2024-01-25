## 0.8.1 (unreleased)

- Make L3 PBR destination MAC optional
- Add `apic_include` option to `port_tracking` configuration

## 0.8.0

- Fix replacement of placeholders in auto-generated objects
- Fix error with sub-port static path bindings
- Add support for static leafs under an EPG
- Add `auto` to allowed values for `speed` in link level policies
- Add support for tenant security domains
- Add support for route tag policies
- Add support for VRF transit route tag policies
- Add support for L3out route control enforcement
- Add support for LDAP login domains
- Add support for LDAP configuration
- Add support for BFD multihop node policies
- Add support for security domains to physical and routed domains
- Add support for SR MPLS L3outs
- Add support for configuring `mode` of L3out SVI interfaces
- Support additional values for `authorization_type` attribute of SNMP users
- Allow `:` character in name attributes of various access policies objects
- Add HTTPS TLS v1.3 to management access policies
- Add SSH AES256-GCM to management access policies
- Add SSH KEX Algorithms to management access policies
- Improve handling of quad-dotted notation OSPF area IDs
- Fix PIM policy compatibility issue with ACI 6.0.x
- Add support for EPG contract masters
- Add support for VMware VMM domain security domains
- Add support for security domains
- Add support for EIGRP to L3outs
- Add support for new interface configuration mode
- Add option to clear remote MAC entries of BDs
- Add support for ND RA prefix policies
- Add support for back-2-back Multi-Pod connections
- Add support for system performance settings
- Add support for OSPF timer policies
- Add support for OSPF route summarization
- Add support for copy services (service graphs)
- Add support for "direct connect" in service graph templates
- Add support for OSPF area control
- Add support for L3out route control profiles
- Add AAA user management settings

## 0.7.0

- Initial release

### Changes compared to previous releases of individual modules

These are the changes compared to the previous releases of the following modules:

- `nac-tenant` v0.4.1
- `nac-access-policies` v0.4.0
- `nac-fabric-policies` v0.4.1
- `nac-pod-policies` v0.4.0
- `nac-node-policies` v0.4.0
- `nac-interface-policies` v0.4.0

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
- Fix idempotency issue with date time policy and ACI 6.0
