# Changelog

## 0.4.1 (unreleased)

#### CLI (aac-tool)

- APIC: Add support for IPv6 OOB and inband management addresses
- APIC: Add support for breakout interface policy groups
- APIC: Add support fur sub-port (breakout) leaf interface selectors
- APIC: Add support for sub-port (breakout) EPG static ports

#### Ansible (ansible-aac)

- APIC: Add support for IPv6 OOB and inband management addresses
- APIC: Add support for breakout interface policy groups
- APIC: Add support fur sub-port (breakout) leaf interface selectors
- APIC: Add support for sub-port (breakout) EPG static ports
- MSO: Do not touch (ignore) default `dcnm-default-tn` NDO tenant

#### Terraform (terraform-aac)

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
- Fix various bugss in aac-lint rules
- Adding necessary config to make this tool CAT enabled
