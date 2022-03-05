*** Settings ***
Documentation   Verify Access Leaf Interface Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}

Verify Access Leaf Interface Profile {{ leaf_interface_profile_name }}
    GET   "/api/mo/uni/infra/accportprof-{{ leaf_interface_profile_name }}.json"
    String   $..infraAccPortP.attributes.name   {{ leaf_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.access_policies.leaf_interface_profiles | default([]) %}
{% set leaf_interface_profile_name = prof.name ~ defaults.apic.access_policies.leaf_interface_profiles.name_suffix %}

Verify Access Leaf Interface Profile {{ leaf_interface_profile_name }}
    GET   "/api/mo/uni/infra/accportprof-{{ leaf_interface_profile_name }}.json?rsp-subtree=full"
    String   $..infraAccPortP.attributes.name   {{ leaf_interface_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set leaf_interface_selector_name = sel.name ~ defaults.apic.access_policies.leaf_interface_profiles.selectors.name_suffix %}

Verify Access Leaf Interface Profile {{ leaf_interface_profile_name }} Selector {{ leaf_interface_selector_name }}
    ${sel}=   Set Variable   $..infraAccPortP.children[?(@.infraHPortS.attributes.name=='{{ leaf_interface_selector_name }}')]
    String   ${sel}..infraHPortS.attributes.name   {{ leaf_interface_selector_name }}
{% if sel.fex_id is defined %}
{% set fex_profile_name = sel.fex_profile ~ defaults.apic.access_policies.fex_interface_profiles.name_suffix %}
    String   ${sel}..infraRsAccBaseGrp.attributes.fexId   {{ sel.fex_id }}
    String   ${sel}..infraRsAccBaseGrp.attributes.tDn   uni/infra/fexprof-{{ fex_profile_name }}/fexbundle-{{ fex_profile_name }}
{% elif sel.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ sel.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = sel.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    String   ${sel}..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% else %}
    String   ${sel}..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% endif %}

{% for blk in sel.port_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.name_suffix %}

Verify Access Leaf Interface Profile {{ leaf_interface_profile_name }} Selector {{ leaf_interface_selector_name }} Port Block {{ block_name }}
    ${blk}=   Set Variable   $..infraAccPortP.children[?(@.infraHPortS.attributes.name=='{{ leaf_interface_selector_name }}')].infraHPortS.children[?(@.infraPortBlk.attributes.name=='{{ block_name }}')]
    String   ${blk}..infraPortBlk.attributes.name   {{ block_name }}
    String   ${blk}..infraPortBlk.attributes.fromCard   {{ blk.from_module | default(defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module) }}
    String   ${blk}..infraPortBlk.attributes.fromPort   {{ blk.from_port }}
    String   ${blk}..infraPortBlk.attributes.toCard   {{ blk.to_module | default(blk.from_module | default(defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)) }}
    String   ${blk}..infraPortBlk.attributes.toPort   {{ blk.to_port | default(blk.from_port) }}

{% endfor %}
{% endfor %}
{% endfor %}
