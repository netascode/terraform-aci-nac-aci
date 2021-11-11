*** Settings ***
Documentation   Verify Leaf Interface Policy Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pg in apic.access_policies.leaf_interface_policy_groups | default([]) %}
{% set policy_group_name = pg.name ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}

Verify Leaf Interface Policy Group {{ policy_group_name }}
{% if pg.type in ["vpc", "pc"] %}
    GET   "/api/mo/uni/infra/funcprof/accbundle-{{ policy_group_name }}.json?rsp-subtree=full"
    String   $..infraAccBndlGrp.attributes.name   {{ policy_group_name }}
    String   $..infraAccBndlGrp.attributes.descr   {{ pg.description | default() }}
{% if pg.type == "vpc" %}
    String   $..infraAccBndlGrp.attributes.lagT   node
{% elif pg.type == "pc" %}
    String   $..infraAccBndlGrp.attributes.lagT   link
{% endif %}
{% else %}
    GET   "/api/mo/uni/infra/funcprof/accportgrp-{{ policy_group_name }}.json?rsp-subtree=full"
    String   $..infraAccPortGrp.attributes.name   {{ policy_group_name }}
    String   $..infraAccPortGrp.attributes.descr   {{ pg.description | default() }}
{% endif %}
{% if pg.link_level_policy is defined %}
{% set link_level_policy_name = pg.link_level_policy ~ defaults.apic.access_policies.interface_policies.link_level_policies.name_suffix %}
    String   $..infraRsHIfPol.attributes.tnFabricHIfPolName   {{ link_level_policy_name }}
{% endif %}
{% if pg.cdp_policy is defined %}
{% set cdp_policy_name = pg.cdp_policy ~ defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix %}
    String   $..infraRsCdpIfPol.attributes.tnCdpIfPolName   {{ cdp_policy_name }}
{% endif %}
{% if pg.lldp_policy is defined %}
{% set lldp_policy_name = pg.lldp_policy ~ defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix %}
    String   $..infraRsLldpIfPol.attributes.tnLldpIfPolName   {{ lldp_policy_name }}
{% endif %}
{% if pg.spanning_tree_policy is defined %}
{% set spanning_tree_policy_name = pg.spanning_tree_policy ~ defaults.apic.access_policies.interface_policies.spanning_tree_policies.name_suffix %}
    String   $..infraRsStpIfPol.attributes.tnStpIfPolName   {{ spanning_tree_policy_name }}
{% endif %}
{% if pg.mcp_policy is defined %}
{% set mcp_policy_name = pg.mcp_policy ~ defaults.apic.access_policies.interface_policies.mcp_policies.name_suffix %}
    String   $..infraRsMcpIfPol.attributes.tnMcpIfPolName   {{ mcp_policy_name }}
{% endif %}
{% if pg.l2_policy is defined %}
{% set l2_policy_name = pg.l2_policy ~ defaults.apic.access_policies.interface_policies.l2_policies.name_suffix %}
    String   $..infraRsL2IfPol.attributes.tnL2IfPolName   {{ l2_policy_name }}
{% endif %}
{% if pg.storm_control_policy is defined %}
{% set storm_control_policy_name = pg.storm_control_policy ~ defaults.apic.access_policies.interface_policies.storm_control_policies.name_suffix %}
    String   $..infraRsStormctrlIfPol.attributes.tnStormctrlIfPolName   {{ storm_control_policy_name }}
{% endif %}
{% if pg.port_channel_policy is defined and pg.type in ["vpc", "pc"] %}
{% set port_channel_policy_name = pg.port_channel_policy ~ defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix %}
    String   $..infraRsLacpPol.attributes.tnLacpLagPolName   {{ port_channel_policy_name }}
{% endif %}
{% if pg.port_channel_member_policy is defined and pg.type in ["vpc", "pc"] %}
{% set port_channel_member_policy_name = pg.port_channel_member_policy ~ defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix %}
    String   $..infraAccBndlSubgrp.attributes.name   {{ policy_group_name }}
    String   $..infraRsLacpInterfacePol.attributes.tnLacpIfPolName   {{ port_channel_member_policy_name }}
{% endif %}
{% if pg.aaep is defined %}
{% set aaep_name = pg.aaep ~ defaults.apic.access_policies.aaeps.name_suffix %}
    String   $..infraRsAttEntP.attributes.tDn   uni/infra/attentp-{{ aaep_name }}
{% endif %}

{% endfor %}
