# APIC Support Matrix

This table provides an overview of which object is supported in combination with which tool.

* **CLI** refers to the ability to deploy the object using [aac-tool](../cli/overview.md)
* **Ansible** refers to the ability to deploy the object using Ansible
* **Terraform** refers to the ability to deploy the object using Terraform
* **Reverse** refers to the ability to generate YAML files from JSON configurations (e.g., APIC snapshot) using [aac-tool](../cli/overview.md)

### Bootstrap

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Bootstrap](./apic/bootstrap/bootstrap.md) | :material-check: | :material-check: | |

### Fabric Policies

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Date and Time Format](./apic/fabric_policies/date_time_format.md) | :material-check: | :material-check: | :material-check: | :material-check:
[APIC Connectivity Preference](./apic/fabric_policies/apic_connectivity_pref.md) | :material-check: | :material-check: | :material-check: | :material-check:
[GUI and CLI Banner](./apic/fabric_policies/banner.md) | :material-check: | :material-check: | :material-check: | :material-check:
[EP Loop Protection](./apic/fabric_policies/ep_loop_protection.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Rogue EP Control](./apic/fabric_policies/rogue_ep_control.md) | :material-check: | :material-check: | :material-check: | :material-check:
[IP Aging](./apic/fabric_policies/ip_aging.md) | :material-check: | :material-check: | :material-check: | :material-check:
[System Global GIPo](./apic/fabric_policies/system_global_gipo.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Wide Settings](./apic/fabric_policies/fabric_wide_settings.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Port Tracking](./apic/fabric_policies/port_tracking.md) | :material-check: | :material-check: | :material-check: | :material-check:
[PTP](./apic/fabric_policies/ptp.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric ISIS Redistribute Metric](./apic/fabric_policies/isis_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric ISIS BFD](./apic/fabric_policies/fabric_isis_bfd.md) | :material-check: | :material-check: | :material-check: | :material-check:
[DNS Profile Policy](./apic/fabric_policies/dns_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Error Disabled Recovery Policy](./apic/fabric_policies/err_disabled_recovery.md) | :material-check: | :material-check: | :material-check: | :material-check:
[COOP Policy](./apic/fabric_policies/coop_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[L2 MTU](./apic/fabric_policies/l2_mtu.md) | :material-check: | :material-check: |
[Infra DSCP Translation Policy](./apic/fabric_policies/infra_dscp_translation_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[AAA Settings](./apic/fabric_policies/aaa.md) | :material-check: | :material-check: | :material-check: | :material-check:
[TACACS Provider](./apic/fabric_policies/tacacs.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Local User](./apic/fabric_policies/user.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Login Domain](./apic/fabric_policies/login_domain.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Remote Location](./apic/fabric_policies/remote_location.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Scheduler](./apic/fabric_policies/scheduler.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Config Export](./apic/fabric_policies/config_export.md) | :material-check: | :material-check: | :material-check: | :material-check:
[SNMP Trap](./apic/fabric_policies/snmp_trap.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Syslog](./apic/fabric_policies/syslog.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Monitoring Policy](./apic/fabric_policies/monitoring_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[CA Certificate](./apic/fabric_policies/ca_cert.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Keyring](./apic/fabric_policies/keyring.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Health Score Evaluation](./apic/fabric_policies/health_score_evaluation.md) | :material-check: | :material-check: |
[Date and Time Policy](./apic/fabric_policies/date_time_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[BGP Policy](./apic/fabric_policies/bgp_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Leaf Switch Profile](./apic/fabric_policies/fp_leaf_switch_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Spine Switch Profile](./apic/fabric_policies/fp_spine_switch_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Leaf Interface Profile](./apic/fabric_policies/fp_leaf_interface_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Spine Interface Profile](./apic/fabric_policies/fp_spine_interface_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Pod Profile](./apic/fabric_policies/pod_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[SNMP Pod Policy](./apic/fabric_policies/snmp_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Management Access Policy](./apic/fabric_policies/management_access_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[PSU Switch Policy](./apic/fabric_policies/psu_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Node Control Switch Policy](./apic/fabric_policies/node_control_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Pod Policy Group](./apic/fabric_policies/pod_policy_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Leaf Switch Policy Group](./apic/fabric_policies/fp_leaf_switch_policy_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Fabric Spine Switch Policy Group](./apic/fabric_policies/fp_spine_switch_policy_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[External Connectivity Policy](./apic/fabric_policies/ext_conn_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Vmware VMM Domain](./apic/fabric_policies/vmw_vmm_domain.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Geolocation Policy](./apic/fabric_policies/geolocation.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Interface type](./apic/fabric_policies/interface_type.md) | :material-check: | :material-check: |
[Fabric SPAN Source Group](./apic/fabric_policies/fp_span_source_group.md) | :material-check: | :material-check: |
[Fabric SPAN Destination Group](./apic/fabric_policies/fp_span_destination_group.md) | :material-check: | :material-check: |

### Access Policies

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[MCP Global Instance](./apic/access_policies/mcp.md) | :material-check: | :material-check: | :material-check: | :material-check:
[QoS Class](./apic/access_policies/qos.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Leaf Switch Profile](./apic/access_policies/ap_leaf_switch_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Spine Switch Profile](./apic/access_policies/ap_spine_switch_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Leaf Interface Profile](./apic/access_policies/ap_leaf_interface_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access FEX Interface Profile](./apic/access_policies/ap_fex_interface_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Spine Interface Profile](./apic/access_policies/ap_spine_interface_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[VLAN Pool](./apic/access_policies/vlan_pool.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Physical Domain](./apic/access_policies/physical_domain.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Routed Domain](./apic/access_policies/routed_domain.md) | :material-check: | :material-check: | :material-check: | :material-check:
[AAEP](./apic/access_policies/aaep.md) | :material-check: | :material-check: | :material-check: | :material-check:
[CDP Interface Policy](./apic/access_policies/cdp_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[LLDP Interface Policy](./apic/access_policies/lldp_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Link Level Interface Policy](./apic/access_policies/link_level_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Port Channel Interface Policy](./apic/access_policies/port_channel_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Port Channel Member Interface Policy](./apic/access_policies/port_channel_member_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Spanning Tree Interface Policy](./apic/access_policies/spanning_tree_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[MCP Interface Policy](./apic/access_policies/mcp_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[L2 Interface Policy](./apic/access_policies/l2_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Storm Control Interface Policy](./apic/access_policies/storm_control_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[MST Switch Policy](./apic/access_policies/mst_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[vPC Switch Policy](./apic/access_policies/vpc_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Forwarding Scale Switch Policy](./apic/access_policies/forwarding_scale_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Spine Switch Policy Group](./apic/access_policies/ap_spine_switch_policy_group.md) | :material-check: | :material-check: |
[Access Leaf Switch Policy Group](./apic/access_policies/ap_leaf_switch_policy_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Spine Interface Policy Group](./apic/access_policies/ap_spine_interface_policy_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access SPAN Destination Group](./apic/access_policies/ap_span_destination_group.md) | :material-check: | :material-check: |
[Access SPAN Source Group](./apic/access_policies/ap_span_source_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Access Leaf Interface Policy Group](./apic/access_policies/ap_leaf_interface_policy_group.md) | :material-check: | :material-check: | :material-check: | :material-check:

### Pod Policies

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Pod Setup](./apic/pod_policies/pod_setup.md) | :material-check: | :material-check: | :material-check: | :material-check:

### Node Policies

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Node Registration](./apic/node_policies/node_registration.md) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check:
[OOB Node Address](./apic/node_policies/oob_node_address.md) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check:
[Inband Node Address](./apic/node_policies/inb_node_address.md) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check:
[Maintenance Group](./apic/node_policies/maintenance_group.md) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check:
[Firmware Group](./apic/node_policies/firmware_group.md) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check:
[vPC Group](./apic/node_policies/vpc_group.md) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check:

### Interface Policies

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Access Spine Interface Selector](./apic/interface_policies/spine_interface_selector.md) | :material-check: | :material-check: | :material-check: |
[Access Leaf Interface Selector](./apic/interface_policies/leaf_interface_selector.md) | :material-check: | :material-check: | :material-check: |
[Access FEX Interface Selector](./apic/interface_policies/fex_interface_selector.md) | :material-check: | :material-check: | :material-check: |

### Tenant

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Tenant](./apic/tenants/tenant.md) | :material-check: | :material-check: | :material-check: | :material-check:
[VRF](./apic/tenants/vrf.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Bridge Domain](./apic/tenants/bridge_domain.md) | :material-check: | :material-check: | :material-check: | :material-check:
[External Endpoint Group](./apic/tenants/external_endpoint_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Application Profile](./apic/tenants/application_profile.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Endpoint Group](./apic/tenants/endpoint_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Contract](./apic/tenants/contract.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Imported Contract](./apic/tenants/imported_contract.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Filter](./apic/tenants/filter.md) | :material-check: | :material-check: | :material-check: | :material-check:
[OSPF Interface Policy](./apic/tenants/ospf_interface_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[BFD Interface Policy](./apic/tenants/bfd_interface_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[DHCP Relay Policy](./apic/tenants/dhcp_relay_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[DHCP Option Policy](./apic/tenants/dhcp_option_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Route Control Route Map](./apic/tenants/route_control_route_map.md) | :material-check: | :material-check: |
[Match Rule](./apic/tenants/match_rule.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Multicast Route Map](./apic/tenants/multicast_route_map.md) | :material-check: | :material-check: |
[Set Rule](./apic/tenants/set_rule.md) | :material-check: | :material-check: | :material-check: | :material-check:
[BGP Timer Policy](./apic/tenants/bgp_timer_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[BGP Peer Prefix Policy](./apic/tenants/bgp_peer_prefix_policy.md) | :material-check: | :material-check: |
[BGP Best Path Policy](./apic/tenants/bgp_best_path_policy.md) | :material-check: | :material-check: |
[BGP Address Family Context Policy](./apic/tenants/bgp_address_family_context_policy.md) | :material-check: | :material-check: |
[PIM Policy](./apic/tenants/pim_policy.md) | :material-check: | :material-check: |
[IGMP Snooping Policy](./apic/tenants/igmp_snooping_policy.md) | :material-check: | :material-check: |
[IGMP Interface Policy](./apic/tenants/igmp_interface_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[IP SLA Policy](./apic/tenants/ip_sla_policy.md) | :material-check: | :material-check: |
[Tenant SPAN Source Group](./apic/tenants/tenant_span_source_group.md) | :material-check: | :material-check: |
[Tenant SPAN Destination Group](./apic/tenants/tenant_span_destination_group.md) | :material-check: | :material-check: |
[Trust Control Policy](./apic/tenants/trust_control_policy.md) | :material-check: | :material-check: |
[Redirect Policy](./apic/tenants/redirect_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Service EPG Policy](./apic/tenants/service_epg_policy.md) | :material-check: | :material-check: |
[Redirect Health Group](./apic/tenants/redirect_health_group.md) | :material-check: | :material-check: |
[L4L7 Device](./apic/tenants/l4l7_device.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Service Graph Template](./apic/tenants/service_graph_template.md) | :material-check: | :material-check: | :material-check: | :material-check:
[Device Selection Policy](./apic/tenants/device_selection_policy.md) | :material-check: | :material-check: | :material-check: | :material-check:
[INB Endpoint Group](./apic/tenants/inb_endpoint_group.md) | :material-check: | :material-check: | :material-check: | :material-check:
[OOB Endpoint Group](./apic/tenants/tenant.md) | :material-check: | :material-check: | :material-check: | :material-check:
[OOB External Management Instance](./apic/tenants/oob_ext_mgmt_instance.md) | :material-check: | :material-check: | :material-check: | :material-check:
[OOB Contract](./apic/tenants/oob_contract.md) | :material-check: | :material-check: | :material-check: | :material-check:
