*** Settings ***
Documentation   Verify Access Spine Interface Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_spine_switch_interface_profiles | default(defaults.apic.auto_generate_access_spine_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.spine_interface_profile_name | default(defaults.apic.access_policies.spine_interface_profile_name))) %}

Verify Access Spine Interface Profile {{ spine_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/spaccportprof-{{ spine_interface_profile_name }}.json
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraSpAccPortP.attributes.name   {{ spine_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.access_policies.spine_interface_profiles | default([]) %}
{% set spine_interface_profile_name = prof.name ~ defaults.apic.access_policies.spine_interface_profiles.name_suffix %}

Verify Access Spine Interface Profile {{ spine_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/spaccportprof-{{ spine_interface_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraSpAccPortP.attributes.name   {{ spine_interface_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set spine_interface_selector_name = sel.name ~ defaults.apic.access_policies.spine_interface_profiles.selectors.name_suffix %}

Verify Access Spine Interface Profile {{ spine_interface_profile_name }} Selector {{ spine_interface_selector_name }}
    ${sel}=   Set Variable   $..infraSpAccPortP.children[?(@.infraSHPortS.attributes.name=='{{ spine_interface_selector_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraSHPortS.attributes.name   {{ spine_interface_selector_name }}
{% if sel.policy_group is defined %}
{% set policy_group_name = sel.policy_group ~ defaults.apic.access_policies.spine_interface_policy_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraRsSpAccGrp.attributes.tDn   uni/infra/funcprof/spaccportgrp-{{ policy_group_name }}
{% endif %}

{% for blk in sel.port_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.name_suffix %}

Verify Access Spine Interface Profile {{ spine_interface_profile_name }} Selector {{ spine_interface_selector_name }} Port Block {{ block_name }}
    ${blk}=   Set Variable   $..infraSpAccPortP.children[?(@.infraSHPortS.attributes.name=='{{ spine_interface_selector_name }}')].infraSHPortS.children[?(@.infraPortBlk.attributes.name=='{{ block_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.name   {{ block_name }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.fromCard   {{ blk.from_module | default(defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.from_module) }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.fromPort   {{ blk.from_port }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.toCard   {{ blk.to_module | default(blk.from_module | default(defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.from_module)) }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.toPort   {{ blk.to_port | default(blk.from_port) }}

{% endfor %}
{% endfor %}
{% endfor %}
