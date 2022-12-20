# Changelog

## 0.5.1 (unreleased)

#### CLI (aac-tool)

- APIC: Add support for reflective relay option

#### Ansible (ansible-aac)

- APIC: Add support for reflective relay option

#### Terraform (terraform-aac)

- APIC: Add support for reflective relay option
- APIC: Fix VRF leaked internal prefix destination public default value

## 0.5.0 <small>December 14, 2022</small>

Tested versions: [link](./tested_versions.md#release-050)

#### CLI (aac-tool)

- APIC: Add support for endpoint security groups
- BREAKING CHANGE APIC: Enable remote leaf direct option by default
- APIC: Add support for IPv6 OOB and inband management addresses
- APIC: Add support for breakout interface policy groups
- APIC: Add support fur sub-port (breakout) leaf interface selectors
- APIC: Add support for sub-port (breakout) EPG static ports
- APIC: Support VMM read-only mode (no Vlan Pool)
- APIC: Make infra_vlan configuration optional and add semantic validation rule to verify if infra_vlan is configured when enabled on AAEP
- APIC: Fix filter config test to support ssh protocol
- APIC: Fix QoS no_drop_cos default value
- APIC: Replace RESTinstance Robot library with Requests and JSONLibrary to align with CXTA curated libraries
- BREAKING CHANGE APIC: Rename `source_port_from` attribute of Access SPAN filter group to `source_from_port`
- BREAKING CHANGE APIC: Rename `source_port_to` attribute of Access SPAN filter group to `source_to_port`
- BREAKING CHANGE APIC: Rename `destination_port_from` attribute of Access SPAN filter group to `destination_from_port`
- BREAKING CHANGE APIC: Rename `destination_port_to` attribute of Access SPAN filter group to `destination_to_port`
- APIC: Add support for L4-L7 device logical interfaces without encap
- APIC: Add support for virtual (VMM Domain) L4-L7 devices
- APIC: Add support for imported consumers (contract interface) to ESGs
- APIC: Add support for leaked internal and external prefixes to VRF
- APIC: Add support for intra-EPG contracts
- APIC: Add support for intra-ESG contracts
- APIC: Add `name` and `protocol` attributes to syslog destinations
- Hosted version available at <https://caf.cisco.com/aci/aac-tool>

#### Ansible (ansible-aac)

- APIC: Add support for endpoint security groups
- BREAKING CHANGE APIC: Enable remote leaf direct option by default
- APIC: Add support for IPv6 OOB and inband management addresses
- APIC: Add support for breakout interface policy groups
- APIC: Add support fur sub-port (breakout) leaf interface selectors
- APIC: Add support for sub-port (breakout) EPG static ports
- MSO: Do not touch (ignore) default `dcnm-default-tn` NDO tenant
- APIC: Ignore (do not delete) default system interface policies (ACI 5.x)
- APIC: Support VMM read-only mode (no Vlan Pool)
- APIC: Make infra_vlan configuration optional and add semantic validation rule to verify if infra_vlan is configured when enabled on AAEP
- APIC: Fix filter config test to support ssh protocol
- APIC: Fix QoS no_drop_cos default value
- APIC: Replace RESTinstance Robot library with Requests and JSONLibrary to align with CXTA curated libraries
- MSO: Replace RESTinstance Robot library with Requests and JSONLibrary to align with CXTA curated libraries
- BREAKING CHANGE APIC: Rename `source_port_from` attribute of Access SPAN filter group to `source_from_port`
- BREAKING CHANGE APIC: Rename `source_port_to` attribute of Access SPAN filter group to `source_to_port`
- BREAKING CHANGE APIC: Rename `destination_port_from` attribute of Access SPAN filter group to `destination_from_port`
- BREAKING CHANGE APIC: Rename `destination_port_to` attribute of Access SPAN filter group to `destination_to_port`
- APIC: Add support for L4-L7 device logical interfaces without encap
- APIC: Add support for virtual (VMM Domain) L4-L7 devices
- APIC: Add support for imported consumers (contract interface) to ESGs
- APIC: Add support for leaked internal and external prefixes to VRF
- APIC: Add support for intra-EPG contracts
- APIC: Add support for intra-ESG contracts
- APIC: Add `name` and `protocol` attributes to syslog destinations

#### Terraform (terraform-aac)

- APIC: Add support for endpoint security groups
- APIC: Add option to configure EPG mappings under AAEP
- BREAKING CHANGE APIC: Enable remote leaf direct option by default
- Update modules to Terraform 1.3 syntax
- Introduce module switches (`modules/modules.yaml`) to selectively disable modules for brownfield scenarios
- BREAKING CHANGE: Use boolean values in data model instead of `enabled`/`disabled`, `yes`/`no` and `on`/`off`
- Use [iac-validate](https://github.com/netascode/iac-validate) to perform syntactic and semantic validation
- Use [iac-test](https://github.com/netascode/iac-test) to perform testing
- FIX: Intra-EPG Isolation enforcement
- Add BD Subnet `virtual` option and IGMP policy relationships
- FIX: Do not create empty auto-generated L3out Node Profiles
- APIC: Add support for IPv6 OOB and inband management addresses
- APIC: Add support for breakout interface policy groups
- APIC: Add support fur sub-port (breakout) leaf interface selectors
- APIC: Add support for sub-port (breakout) EPG static ports
- APIC: Support VMM read-only mode (no Vlan Pool)
- APIC: Make infra_vlan configuration optional and add semantic validation rule to verify if infra_vlan is configured when enabled on AAEP
- APIC: Fix filter config test to support ssh protocol
- APIC: Fix QoS no_drop_cos default value
- APIC: Replace RESTinstance Robot library with Requests and JSONLibrary to align with CXTA curated libraries
- BREAKING CHANGE APIC: Change EPG preferred group attribute to boolean value
- BREAKING CHANGE APIC: Change External EPG preferred group attribute to boolean value
- BREAKING CHANGE APIC: Change EPG intra-EPG isolation attribute to boolean value
- APIC: Add option to specify QoS class for external EPGs
- APIC: Add option to specify target DSCP value for external EPGs
- APIC: Add aggregate flags to subnet of external EPGs
- APIC: Add option to enable IPv4 multicast for L3out
- APIC: Add option to specify target DSCP for L3out
- APIC: Add option to reference interleak, dampening and redistribution route maps for L3out
- APIC: Add option to configure default route leak policy for L3out
- APIC: Add support for node loopbacks in L3out node profiles
- APIC: Add support for static route BFD in L3out node profiles
- APIC: Add support for loopback BGP peerings in L3out node profiles
- APIC: Add support for PIM policy in L3out interface profiles
- APIC: Add support for IGMP interface policy in L3out interface profiles
- APIC: Add support for QoS class in L3out interface profiles
- APIC: Add support for custom QoS policy in L3out interface profiles
- APIC: Add support for floating SVI in L3out interface profiles
- APIC: Add multiple options to BGP peers in L3out interface profiles
- APIC: Fix default tenant for service graph templates and device selection policies
- APIC: Make `community` an optional attribute of `set_rule`
- APIC: Fix BGP peer address family attribute order for L3out node profiles
- APIC: Add additional attributes to set rules
- APIC: Add additional attributes to redirect policies
- APIC: Add `preferred_group` attribute to VRF
- APIC: Add BGP address family context policies to VRF
- APIC: Add IP SLA policy module
- APIC: Add BGP address family context policy module
- APIC: Add redirect health group module
- APIC: Add route control route map module
- APIC: Add QoS policy module
- APIC: Add custom QoS policy attribute to EPG
- APIC: Add `minimum_buffer`, `pfc_state`, `no_drop_cos`, `pfc_scope`, `ecn`, `forward_non_ecn`, `wred_max_threshold`, `wred_min_threshold`, `wred_probability`, `weight` attributes to QoS class
- APIC: Add SPAN filter group module
- APIC: Add SPAN destination group module
- APIC: Add SPAN source group module
- APIC: Fix unintended deletion of inband EPG when inband node address is removed
- APIC: Fix unintended deletion of out-of-band EPG when out-of-band node address is removed
- APIC: Add L2 MTU module
- APIC: Add interface type module
- APIC: Fix SNMP policy client entry dependencies
- APIC: Add management access policy module
- APIC: Add L2 MTU module
- APIC: Add interface type module
- APIC: Fix SNMP policy client entry dependencies
- APIC: Add management access policy module
- Pin module dependencies
- APIC: Add support for L4-L7 device logical interfaces without encap
- APIC: Add `description` attribute to vlan pools and ranges
- APIC: Add `description` attribute to interface policy group module
- APIC: Add `policy_group` attribute to access spine switch profiles
- APIC: Add support for L4-L7 device logical interfaces without paths
- APIC: Add support for virtual (VMM Domain) L4-L7 devices
- APIC: Add support for imported consumers (contract interface) to ESGs
- APIC: Add support for leaked internal and external prefixes to VRF
- APIC: Add support for intra-EPG contracts
- APIC: Add support for intra-ESG contracts
- APIC: Add `name` and `protocol` attributes to syslog destinations
- APIC: Add QoS attributes to contract
- APIC: Add `managed` flag to tenant (default value `true`) to indicate if a tenant should be created/modified/deleted or is assumed to exist already and just acts a container for other objects
- APIC: Add `managed` flag to application profile
- APIC: Add option to configure individual vPC group name
- APIC: Add `type` attribute to pod profile selector
- APIC: Add `management_access_policy` option to pod policy groups
- APIC: Add syslog policy flags and `minimum_severity`
- APIC: Add reallocate GIPO fabric-wide setting
- APIC: Fix auto-generated pod profile selector name
- APIC: Add support for `auto_generate_pod_profiles`, `auto_generate_access_leaf_switch_interface_profiles`, `auto_generate_access_spine_switch_interface_profiles`, `auto_generate_fabric_leaf_switch_interface_profiles` and `auto_generate_fabric_spine_switch_interface_profiles` flags
- APIC: Remove option to specify tenant for EPG selectors under an ESG
- APIC: Normalize filter `protocol` and `port` values
- APIC: Allow escaping character in ESG tag selectors
- APIC: Add `qos_class` attribute to EPG
- APIC: Allow OSPF area IDs in dotted decimal format
- APIC: Add spine switch policy group module
- APIC: Add colon to allowed characters of leaf interface selector names
- APIC: Normalize access SPAN filter `protocol` and `port` values

## 0.4.0 <small>April 25, 2022</small>

#### CLI (aac-tool)

- APIC: Add AS-Path option to set rule
- MSO: Add support for vzAny
- APIC: Add reallocate GIPO fabric-wide setting
- APIC: Add APIC GUI banner message option
- APIC: Fix export_route_map order attribute value encoding
- APIC: Add orchestrator:aac annotation to every object

#### Ansible (ansible-aac)

- Initial release

#### Terraform (terraform-aac)

- Initial release

## 0.3.4 <small>March 9, 2022</small>

#### CLI (aac-tool)

- APIC: Instead of enabled/disabled, yes/no, on/off, use boolean values (true/false) in yaml by default
- APIC: Add VSPAN destination groups
- APIC: Add VSPAN sessions  

## 0.3.3 <small>January 23, 2022</small>

#### CLI (aac-tool)

- APIC: Add service EPG policies
- APIC: Add health groups and backup option to redirect policy
- APIC: Fix BGP operational tests
- APIC: Add vmac and ep move detection option to BD
- APIC: Add trust policy for EPG
- APIC: Extend support of access SPAN
- APIC: Add option to specify uplinks for VMware VMM domain
- APIC: Add fabric SPAN destination group
- APIC: Add eLACP for VMware VMM domain
- APIC: Add fabric SPAN source group
- APIC: Add QoS policies
- APIC: Add EPG subnet options

## 0.3.2 <small>November 1, 2021</small>

#### CLI (aac-tool)

- Allow PIDs beginning with HEX character
- Remove HCL options
- BREAKING CHANGE APIC: Add option to specify multiple L3out redistribution route maps

## 0.3.1 <small>October 13, 2021</small>

#### CLI (aac-tool)

- APIC: Add unspecified option to filter entry ports
- MSO: Add additional BD and EPG subnet options for v3.1
- APIC: Add description to vlan pool and ranges
- APIC: Add additional QoS class options
- APIC: Add description to leaf interface policy groups
- APIC: Add option to define scheduler for update groups
- APIC: Add QoS options to EPG
- APIC: Add L4L7 VIPs and address pools to EPG
- APIC: Add QoS options to contracts and subjects
- APIC: Add QoS options to l3outs
- APIC: Add Tenant SPAN
- APIC: Add redirect health groups
- APIC: Add QoS options to device selection policies

## 0.3.0 <small>August 20, 2022</small>

#### CLI (aac-tool)

- Add cli option to upgrade XLS to latest template
- Use aac-tool version on XLS front page
- BREAKING CHANGE APIC: Update and expand L3out BPG options
- APIC: Add option to configure EPG tags
- BREAKING CHANGE APIC: Restructure VRF BGP options
- APIC: Update VRF multicast options
- APIC: Add options to monitoring policy
- APIC: Add templates to configure fabric MTU
- APIC: Add templates to configure port type (uplink/downlink)
- APIC: Add flags to control auto generation of individual pod and switch profiles
- APIC: Update Terraform templates
- BREAKING CHANGE APIC: Add option to specify multiple next_hops for L3out static routes
- APIC: Add multicast options to L3out
- APIC: Add multicast options to VRF
- APIC: Add options to set rule
- APIC: Add templates for route control route maps
- APIC: Add templates for PIM policy
- APIC: Add templates for multicast route maps
- APIC: Add options to match rule
- APIC: Add templates for BGP peer prefix policy
- APIC: Add templates for BGP best path policy
- APIC: Add templates for BGP address family context policy
- APIC: Add option to specify loopbacks for L3outs
- APIC: Add templates for IP SLA policy
- APIC: Add templates for IGMP snooping policy
- APIC: Add templates for IGMP interface policy
- APIC: Add preferred_group option to VRF
- APIC: Add local_as and as_propagate options for BGP in L3outs
- APIC: Add option to configure secondary ip for L3outs (ip_shared)
- APIC: Add option to specify alias for static endpoints in EPG
- APIC: Add option to specify type for fabric pod profiles
- APIC: Add templates for access spine switch policy group
- APIC: Add mappings for system GIPO policy
- APIC: Add mappings for AAEP EPG mapping
- APIC: Add mappings for fabric_id
- APIC: Update temaplates and mappings to configure static endpoints under EPG
- APIC: Add templates and mappings for management access policy
- APIC: Add templates and mappings for health score evaluation
- BREAKING CHANGE APIC: Add option to specify routing profiles under external connectivity policy
- APIC: Add templates for SPAN source and destination group
- Fix various bugs in aac-lint rules
- Adding necessary config to make this tool CAT enabled
