## 2.0.0

### New Features

- BREAKING CHANGE: Move old `leaked_internal_prefixes` (class leakInternalSubnet) to `leaked_internal_subnets` and add support for new `leaked_internal_prefixes` (class leakInternalPrefix) in a VRF leaking configuration
- BREAKING CHANGE: Add support for configuring custom monitoring policy. Previous configuration needs to be moved to explicit `common` monitoring policy
- BREAKING CHANGE: Update default values for various management access policy attributes (`aes256_gcm`, `curve25519_sha256`, `curve25519_sha256_libssh`,`dh14_sha256`, `dh16_sha512`, `ecdh_sha2_nistp256`, `ecdh_sha2_nistp384`, `ecdh_sha2_nistp521`, `tlsv1_1`, `chacha`, `hmac_sha1`)
- BREAKING CHANGE: Remove default values for `retries` attribute under LDAP, RADIUS and TACACS configuration. This attribute is deprecated in ACI 6.2. For pre-6.2 versions these values need to be explicitely configured
- Terraform only: BREAKING CHANGE: Fix L4L7 logical interface unique ID. Resource key will change that will result in resource recreation.
- Terraform only: BREAKING CHANGE: Fix DHCP relay policy to support duplicate provider IPs. Resource key will change that will result in resource recreation.
- Add support for port channel member policy in port selectors
- Add support for filter `match_only_fragments` attribute
- Add support for DVS version 8.0 and future versions
- Add support for security attributes `forged_transmit`, `mac_change` and `promiscous_mode` for floating SVI in L3Out
- Add support for static AAEP configuration under EPG
- Add support for HSRP interface profile and group policies
- Add support for specifying `port_binding` type in EPG VMM Domain Association
- Add support to configure `adjacency_type` for a service graph template device
- Add support for VRF SNMP context and community profiles
- Add support for remote leaf resiliency groups
- Add support for priority flow control and port security interface policies
- Add support for using IP SLA policy from common tenant
- Add support for configuring `legacy_mode_vlan` under bridge domain
- Add support for L3Out contract masters configuration
- Add support for `port_channel_member_name` configuration under leaf interface policy group
- Add support for OOB contract filter `action`, `priority`, `log` and `no_stats` configuration
- Add support for configuring fault severity policies under fabric monitoring policy
- Add support for ACI border gateway
- Add support for multi-device service graph and device selection policy
- Add support to attach BGP route reflector policy in pod policy group
- Add support to attach CDP and LLDP policy in spine policy group
- Add support for `description` under L3Out node profile
- Add support for `mod1536`, `mod3072` and `mod4096` modulus attribute in key ring configuration
- Add support for ACI version 6.2
- Add support for `explicit-failover` mode in port channel policy
- Add support for `auto_enforce` attribute in a link level policy that would enforce autonegotation
- Add support for `unspecified` OSPF network type
- Add dependency between VRF and SR MPLS L3Out configuration
- Add support for removing ACI undeletable objects (`content_on_destroy`) from state management (all policies under leaf/spine interface policy groups, that previously were not possible to be removed)

### Bug Fixes

- Fix filter `no_stats` directive configuration
- Fix imported device in multi-node scenario
- Fix null value for access spine selector policy group
- Fix password class attribute order that was failing in ACI 6.1
- Change L3Out set rule and external EPG configuration order
- Remove nonexistent description attribute under L4L7 device
- Fix incorrect max value validation for set rules `metric` attribute
- Fix VRF name suffix support in a VRF leaking configuration
- Fix ESG IP external subnet selector to support IPv6

## 1.2.0

### New Features

- Add support for new types of forwarding scale policies: `high-policy`, `high-ipv4-ep`, `mcast-heavy` and `max-lpm`
- Add support for configuring `subnets` under inband endpoint groups
- Add support for control plane MTU configuration
- Add support to not set VRF enforcement direction when VRF is managed by NDO
- Add access monitoring policy support
- Add fabric MacSec policies support
- Add data plane policing feature support
- Add BFD multihop policy support for L3out node profiles
- Add support for HTTP type IP SLA policy
- Add tenant Netflow policy support
- Add support for configuring `deployment_immediacy` under endpoint security groups
- Add support for configuring `ip_external_subnet_selectors` under endpoint security groups
- Add support for IPV6 subnet selectors in endpoint security groups
- Add support for VMware VMM trunk port groups
- Add Nutanix VMM integration support
- Add OSPF route summarization policy support with custom policy names
- Add support for static routes with empty next hop, pointing to Null0 interface
- Add leaf interface profile `description` attribute
- Add fabric pod policy group `description` attribute
- Add support for configuring VM attributes in usegEPG
- Add support for ACI version 6.1
- Add support for configuring node-level BGP peers in the `infra` tenant
- Add support for using system-generated breakout policy groups under interface selectors even if they are not managed by Terraform

### Bug Fixes

- Correct BD `virtual_mac` default value handling
- Fix maintenance group `scheduler` deployment
- Fix missing `pod_id` for interface shutdown module
- Fix MacOS handling of null values
- Fix `ssh_keys` validation for OpenTofu
- Fix dependency between inband node addressing and inband endpoint group
- Fix default values handling for service graph templates
- Fix SR MPLS L3out name validation missing `:`
- Fix L3out name to use name suffix in various places if suffix is provided


## 1.1.0

- Add support for DCBXP version under LLDP interface policy
- Add support for IP SLA policy under static route next hop
- Add support for fabric leaf interface selector
- Add support for fabric leaf interface policy group
- Add support for fabric spine interface selector
- Add support for tenant monitoring policies
- Change OOB endpoint group to be an optional attribute
- Fix OSPF metric type for set rules
- Fix missing values for target DSCP under contract subjects
- Fix the EIGRP key chain configuration under L3out interface profile


## 1.0.1

- Fix handling of errors when merging invalid YAML content
- Fix merging of boolean values, where values of `false` were not merged consistently

## 1.0.0

- Add support for L3Out ND interface policy
- Add support for endpoint MAC and IP tags
- Add support for interface shutdown
- Add support for encapsulation under floating L3outs
- Add support for atomic counter
- Add support for enhanced log format in syslog configuration
- BREAKING CHANGE: Add support for multiple loopbacks in L3out nodes configuration
- BREAKING CHANGE: Add support for multiple IPv4 and IPv6 import/export route targets under VRF
- BREAKING CHANGE: Remove default value for smart licensing URL
- Fix support for service graphs with copy device
- Add support for MACsec policy in spine interface policy group
- Add support for BGP protocol profile name
- Add support for port bringup delay to link level policies
- BREAKING CHANGE: Optimized interface and switch policy groups: empty policies will not be pushed anymore. Empty resources will be removed from existing statefile with no expected impact on fabric
- BREAKING CHANGE: Disable escaping HTML characters for all resources that contain passwords
- Add support for `route_maps` under L3out to configure multiple route maps. This will deprecate `import_route map` and `export_route_map` in the future
- Enhance SPAN filer group with name being optional attribute
- BREAKING CHANGE: Enhance BGP best path policy with new attribute `ignore_igp_metric`. Change `control_type` attribute to `as_path_multipath_relax` boolean
- Add support for endpoint retention policy
- Add support for unidirectional contracts
- Add support for `rewrite_source_mac` under redirect policy
- Add support for DHCP relay in L3out secondary IP address configuration
- Add support for application banners
- Use Terraform functions to merge YAML content instead of data sources

## 0.9.3

- Fix validation for consumed contracts under external EPG
- Add support for link local address in L3out interface profiles
- Enhance static endpoints to not require name
- Fix for EIGRP route summarization policy to refer to a user tenant

## 0.9.2

- Add support for interface selector description in auto-generated profiles
- Add support for Netflow Exporter for VMM Networking
- Add support for EIGRP route summarization
- Add support to specify different type of a route control map
- Add description under External EPG Subnet
- Add support for NDO managed service graph templates and device selection policies
- Add support for bulk EPG static ports optimization
- Add support for FEX VPC static port configuration under EPG
- Add support for global SR MPLS configuration
- Add support for multicast ARP drop for BD
- Add support for BGP route summarization at the VRF level
- Add support for access MACsec Policies

## 0.9.1

- Add support for vPC Delay Restore timer
- Add support for Pod Peering Profile
- Add support for Fabric Interface Link Level Policies
- Add support for static vlan allocation under VMware VMM domain
- Add support for ND interface policy under Bridge Domain
- Add support for PBR L3 destination name
- Add support for configuring node role during registration
- Add support for allow_origins parameter in management access policy
- Add support for Netflow policies
- Add support for sub-interfaces in L3out
- Enhance action support for EP loop protection
- Add support for MicroBFD in L3out
- Add support for BGP Route Summarization policies
- Add description under interface selector, EPG static port, l3out interface profile and static route next hop
- Add LDAP support in AAA login domains
- Add support for Private VLANs on static ports
- Add support for BGP profile in L3out
- Add support for DHCP Labels under L3out interface profiles
- Add support for escaping HTML in banners
- Add support for L4L7 active-active device configuration
- Fix support for imported devices in service graph templates
- Add RBAC rules for nodes
- Add support for MPLS Custom QoS policy in Terraform module
- Add support for port channel member policies in new interface configuration mode
- Add support for annotations in NDO-managed objects for tenant, VRF, BD, EPG, L3out and extEPG

## 0.9.0

- Add support for PBR L1L2 destinations
- Add support for additional AAA security management settings
- Add support for syslog show timezone
- Enhance set rules to support external EPG classification
- Add support for colon character in contract names
- Add support for all types of storm control attributes
- Add support for multiple SR/MPLS Infra L3outs
- BREAKING CHANGE: Add support for multiple match rules to L3out route maps
- Add support for PTP profiles
- Add support for vPC component SPAN source
- Add support for Infra DHCP relay policies
- Support for descriptions on SNMP policy user and client group
- Add L3out SVI encapsulation scope
- Add description to AAEP
- Add track lists and track members
- Add auto FEC mode to link level policies
- Support IP data plane learning at subnet level
- Align naming standard for fabricNodeBlk objects to what APIC uses
- Add target version to update groups
- Make routed domain vlan pool optional
- BREAKING CHANGE: Add support for multiple ASN entries in AS path prepending
- Add support for BFD switch policies
- Add support for uSeg EPGs

## 0.8.1

- Make L3 PBR destination MAC optional
- Add `apic_include` option to `port_tracking` configuration
- Add support for Radius Provider
- Enhance new interface configuration mode to support creating access and fabric policy groups on the created switch profiles
- Enhance new interface configuration mode to support configuring fabric interfaces
- Enhance new interface configuration mode to support interface shutdown option
- Add support for `physical_media_type` to link level policies
- Add support for imported L4L7 devices
- Add support for PIM source and destination filters to bridge domains
- Add support for DHCP label scope to bridge domains
- Add support for ND interface policies

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
