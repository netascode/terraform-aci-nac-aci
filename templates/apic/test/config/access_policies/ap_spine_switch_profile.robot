*** Settings ***
Documentation   Verify Access Spine Switch Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_spine_switch_interface_profiles | default(defaults.apic.auto_generate_access_spine_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" %}
{% set spine_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.spine_switch_profile_name | default(defaults.apic.access_policies.spine_switch_profile_name))) %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.spine_interface_profile_name | default(defaults.apic.access_policies.spine_interface_profile_name))) %}
{% set spine_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.spine_switch_selector_name | default(defaults.apic.access_policies.spine_switch_selector_name))) %}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/spprof-{{ spine_switch_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraSpineP.attributes.name   {{ spine_switch_profile_name }}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Selector
    ${selector}=   Set Variable   $..infraSpineP.children[?(@.infraSpineS.attributes.name=='{{ spine_switch_selector_name }}')].infraSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}.attributes.name   {{ spine_switch_selector_name }}

{% if node.access_policy_group is defined %}
{% set policy_group_name = node.access_policy_group ~ defaults.apic.access_policies.spine_switch_policy_groups.name_suffix %}
Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Policy
    ${selector}=   Set Variable   $..infraSpineP.children[?(@.infraSpineS.attributes.name=='{{ spine_switch_selector_name }}')].infraSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}..infraRsSpineAccNodePGrp.attributes.tDn   uni/infra/funcprof/spaccnodepgrp-{{ policy_group_name }}
{% endif %}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Node Block
    ${selector}=   Set Variable   $..infraSpineP.children[?(@.infraSpineS.attributes.name=='{{ spine_switch_selector_name }}')].infraSpineS
    ${block}=   Set Variable   ${selector}.children[?(@.infraNodeBlk.attributes.name=='{{ node.id }}')].infraNodeBlk
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.from_   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.name   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.to_   {{ node.id }}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Interface Profile
    ${profile}=   Set Variable   $..infraSpineP.children[?(@.infraRsSpAccPortP.attributes.tDn=='uni/infra/spaccportprof-{{ spine_interface_profile_name }}')].infraRsSpAccPortP
    Should Be Equal Value Json String   ${r.json()}    ${profile}.attributes.tDn   uni/infra/spaccportprof-{{ spine_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.access_policies.spine_switch_profiles | default([]) %}
{% set spine_switch_profile_name = prof.name ~ defaults.apic.access_policies.spine_switch_profiles.name_suffix %}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/spprof-{{ spine_switch_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraSpineP.attributes.name   {{ spine_switch_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set spine_switch_selector_name = sel.name ~ defaults.apic.access_policies.spine_switch_profiles.selectors.name_suffix %}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Selector {{ spine_switch_selector_name }}
    ${selector}=   Set Variable   $..infraSpineP.children[?(@.infraSpineS.attributes.name=='{{ spine_switch_selector_name }}')].infraSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}.attributes.name   {{ spine_switch_selector_name }}

{% if sel.policy is defined %}
{% set policy_group_name = sel.policy ~ defaults.apic.access_policies.spine_switch_policy_groups.name_suffix %}
Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Selector {{ spine_switch_selector_name }} Policy
    ${selector}=   Set Variable   $..infraSpineP.children[?(@.infraSpineS.attributes.name=='{{ spine_switch_selector_name }}')].infraSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}..infraRsSpineAccNodePGrp.attributes.tDn   uni/infra/funcprof/spaccnodepgrp-{{ policy_group_name }}
{% endif %}

{% for blk in sel.node_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.access_policies.spine_switch_profiles.selectors.node_blocks.name_suffix %}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Selector {{ spine_switch_selector_name }} Node Block {{ block_name }}
    ${selector}=   Set Variable   $..infraSpineP.children[?(@.infraSpineS.attributes.name=='{{ spine_switch_selector_name }}')].infraSpineS
    ${block}=   Set Variable   ${selector}.children[?(@.infraNodeBlk.attributes.name=='{{ block_name }}')].infraNodeBlk
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.from_   {{ blk.from }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.name   {{ block_name }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.to_   {{ blk.to | default(blk.from) }}

{% endfor %}
{% endfor %}

{% for intp in prof.interface_profiles | default([]) %}
{% set spine_interface_profile_name = intp ~ defaults.apic.access_policies.spine_interface_profiles.name_suffix %}

Verify Access Spine Switch Profile {{ spine_switch_profile_name }} Interface Profile
    ${profile}=   Set Variable   $..infraSpineP.children[?(@.infraRsSpAccPortP.attributes.tDn=='uni/infra/spaccportprof-{{ spine_interface_profile_name }}')].infraRsSpAccPortP
    Should Be Equal Value Json String   ${r.json()}    ${profile}.attributes.tDn   uni/infra/spaccportprof-{{ spine_interface_profile_name }}

{% endfor %}
{% endfor %}