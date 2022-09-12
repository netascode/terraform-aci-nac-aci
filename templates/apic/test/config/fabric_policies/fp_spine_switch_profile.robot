*** Settings ***
Documentation   Verify Fabric Spine Switch Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_fabric_spine_switch_interface_profiles | default(defaults.apic.auto_generate_fabric_spine_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" %}
{% set spine_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.spine_switch_profile_name | default(defaults.apic.fabric_policies.spine_switch_profile_name))) %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.spine_interface_profile_name | default(defaults.apic.fabric_policies.spine_interface_profile_name))) %}
{% set spine_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.spine_switch_selector_name | default(defaults.apic.fabric_policies.spine_switch_selector_name))) %}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/spprof-{{ spine_switch_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..fabricSpineP.attributes.name   {{ spine_switch_profile_name }}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Selector
   ${selector}=   Set Variable   $..fabricSpineP.children[?(@.fabricSpineS.attributes.name=='{{ spine_switch_selector_name }}')].fabricSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}.attributes.name   {{ spine_switch_selector_name }}

{% if node.fabric_policy_group is defined %}
{% set policy_group_name = node.fabric_policy_group ~ defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix %}
Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Policy
    ${selector}=   Set Variable   $..fabricSpineP.children[?(@.fabricSpineS.attributes.name=='{{ spine_switch_selector_name }}')].fabricSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}.children..fabricRsSpNodePGrp.attributes.tDn   uni/fabric/funcprof/spnodepgrp-{{ policy_group_name }}
{% endif %}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Node Block
    ${selector}=   Set Variable   $..fabricSpineP.children[?(@.fabricSpineS.attributes.name=='{{ spine_switch_selector_name }}')].fabricSpineS
    ${block}=   Set Variable   ${selector}.children[?(@.fabricNodeBlk.attributes.name=='{{ node.id }}')].fabricNodeBlk
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.from_   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.name   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.to_   {{ node.id }}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Interface Profile
    ${profile}=   Set Variable   $..fabricSpineP.children[?(@.fabricRsSpPortP.attributes.tDn=='uni/fabric/spportp-{{ spine_interface_profile_name }}')].fabricRsSpPortP
    Should Be Equal Value Json String   ${r.json()}    ${profile}.attributes.tDn   uni/fabric/spportp-{{ spine_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.fabric_policies.spine_switch_profiles | default([]) %}
{% set spine_switch_profile_name = prof.name ~ defaults.apic.fabric_policies.spine_switch_profiles.name_suffix %}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/spprof-{{ spine_switch_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..fabricSpineP.attributes.name   {{ spine_switch_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set spine_switch_selector_name = sel.name ~ defaults.apic.fabric_policies.spine_switch_profiles.selectors.name_suffix %}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Selector {{ spine_switch_selector_name }}
    ${selector}=   Set Variable   $..fabricSpineP.children[?(@.fabricSpineS.attributes.name=='{{ spine_switch_selector_name }}')].fabricSpineS
    Should Be Equal Value Json String   ${r.json()}    ${selector}.attributes.name   {{ spine_switch_selector_name }}

{% if sel.policy is defined %}
{% set policy_group_name = sel.policy ~ defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix %}
Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Selector {{ spine_switch_selector_name }} Policy
    ${selector}=   Set Variable   $..fabricSpineP.children[?(@.fabricSpineS.attributes.name=='{{ spine_switch_selector_name }}')].fabricSpineS
    Should Be Equal Value Json String   ${r.json()}     ${selector}.children..fabricRsSpNodePGrp.attributes.tDn   uni/fabric/funcprof/spnodepgrp-{{ policy_group_name }}

{% endif %}

{% for blk in sel.node_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.fabric_policies.spine_switch_profiles.selectors.node_blocks.name_suffix %}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Selector {{ spine_switch_selector_name }} Node Block {{ block_name }}
    ${selector}=   Set Variable   $..fabricSpineP.children[?(@.fabricSpineS.attributes.name=='{{ spine_switch_selector_name }}')].fabricSpineS
    ${block}=   Set Variable   ${selector}.children[?(@.fabricNodeBlk.attributes.name=='{{ block_name }}')].fabricNodeBlk
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.from_   {{ blk.from }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.name   {{ block_name }}
    Should Be Equal Value Json String   ${r.json()}    ${block}.attributes.to_   {{ blk.to | default(blk.from) }}

{% endfor %}

{% endfor %}

{% for intp in prof.interface_profiles | default([]) %}
{% set spine_interface_profile_name = intp ~ defaults.apic.fabric_policies.spine_interface_profiles.name_suffix %}

Verify Fabric Spine Switch Profile {{ spine_switch_profile_name }} Interface Profile
    ${profile}=   Set Variable   $..fabricSpineP.children[?(@.fabricRsSpPortP.attributes.tDn=='uni/fabric/spportp-{{ spine_interface_profile_name }}')].fabricRsSpPortP
    Should Be Equal Value Json String   ${r.json()}    ${profile}.attributes.tDn   uni/fabric/spportp-{{ spine_interface_profile_name }}

{% endfor %}

{% endfor %}
