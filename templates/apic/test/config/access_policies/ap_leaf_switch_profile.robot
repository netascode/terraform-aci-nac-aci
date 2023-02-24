*** Settings ***
Documentation   Verify Access Leaf Switch Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_profile_name | default(defaults.apic.access_policies.leaf_switch_profile_name))) %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_selector_name | default(defaults.apic.access_policies.leaf_switch_selector_name))) %}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/nprof-{{ leaf_switch_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeP.attributes.name   {{ leaf_switch_profile_name }}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Selector
    Should Be Equal Value Json String   ${r.json()}    $..infraLeafS.attributes.name   {{ leaf_switch_selector_name }}

{% if node.access_policy_group is defined %}
{% set policy_group_name = node.access_policy_group ~ defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix %}
Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Policy
    Should Be Equal Value Json String   ${r.json()}    $..infraRsAccNodePGrp.attributes.tDn   uni/infra/funcprof/accnodepgrp-{{ policy_group_name }}
{% endif %}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Node Block
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeBlk.attributes.from_   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeBlk.attributes.name   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeBlk.attributes.to_   {{ node.id }}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Interface Profile
    Should Be Equal Value Json String   ${r.json()}    $..infraRsAccPortP.attributes.tDn   uni/infra/accportprof-{{ leaf_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.access_policies.leaf_switch_profiles | default([]) %}
{% set leaf_switch_profile_name = prof.name ~ defaults.apic.access_policies.leaf_switch_profiles.name_suffix %}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/nprof-{{ leaf_switch_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeP.attributes.name   {{ leaf_switch_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set leaf_switch_selector_name = sel.name ~ defaults.apic.access_policies.leaf_switch_profiles.selectors.name_suffix %}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Selector {{ leaf_switch_selector_name }}
    ${sel}=   Set Variable   $..infraNodeP.children[?(@.infraLeafS.attributes.name=='{{ leaf_switch_selector_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraLeafS.attributes.name   {{ leaf_switch_selector_name }}

{% if sel.policy is defined %}
{% set policy_group_name = sel.policy ~ defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix %}
Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Selector {{ leaf_switch_selector_name }} Policy
    ${sel}=   Set Variable   $..infraNodeP.children[?(@.infraLeafS.attributes.name=='{{ leaf_switch_selector_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraRsAccNodePGrp.attributes.tDn   uni/infra/funcprof/accnodepgrp-{{ policy_group_name }}
{% endif %}

{% for blk in sel.node_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.access_policies.leaf_switch_profiles.selectors.node_blocks.name_suffix %}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Selector {{ leaf_switch_selector_name }} Node Block {{ block_name }}
    ${block}=   Set Variable   $..infraNodeP.children[?(@.infraLeafS.attributes.name=='{{ leaf_switch_selector_name }}')].infraLeafS.children[?(@.infraNodeBlk.attributes.name=='{{ block_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${block}..infraNodeBlk.attributes.from_   {{ blk.from }}
    Should Be Equal Value Json String   ${r.json()}    ${block}..infraNodeBlk.attributes.name   {{ block_name }}
    Should Be Equal Value Json String   ${r.json()}    ${block}..infraNodeBlk.attributes.to_   {{ blk.to | default(blk.from) }}

{% endfor %}
{% endfor %}

{% for intp in prof.interface_profiles | default([]) %}
{% set leaf_interface_profile_name = intp ~ defaults.apic.access_policies.leaf_interface_profiles.name_suffix %}

Verify Access Leaf Switch Profile {{ leaf_switch_profile_name }} Interface Profile
    Should Be Equal Value Json String   ${r.json()}    $..infraRsAccPortP.attributes.tDn   uni/infra/accportprof-{{ leaf_interface_profile_name }}

{% endfor %}
{% endfor %}