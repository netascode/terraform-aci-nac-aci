*** Settings ***
Documentation   Verify Fabric Leaf Switch Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) == "enabled" or apic.auto_generate_fabric_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_fabric_leaf_switch_interface_profiles) == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_switch_profile_name | default(defaults.apic.fabric_policies.leaf_switch_profile_name))) %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_interface_profile_name | default(defaults.apic.fabric_policies.leaf_interface_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_switch_selector_name | default(defaults.apic.fabric_policies.leaf_switch_selector_name))) %}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }}
    GET   "/api/mo/uni/fabric/leprof-{{ leaf_switch_profile_name }}.json?rsp-subtree=full"
    String   $..fabricLeafP.attributes.name   {{ leaf_switch_profile_name }}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Selector
    String   $..fabricLeafS.attributes.name   {{ leaf_switch_selector_name }}

{% if node.fabric_policy_group is defined %}
{% set policy_group_name = node.fabric_policy_group ~ defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix %}
Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Policy
    String   $..fabricRsLeNodePGrp.attributes.tDn   uni/fabric/funcprof/lenodepgrp-{{ policy_group_name }}
{% endif %}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Node Block
    String   $..fabricNodeBlk.attributes.from_   {{ node.id }}
    String   $..fabricNodeBlk.attributes.name   {{ node.id }}
    String   $..fabricNodeBlk.attributes.to_   {{ node.id }}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Interface Profile
    String   $..fabricRsLePortP.attributes.tDn   uni/fabric/leportp-{{ leaf_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.fabric_policies.leaf_switch_profiles | default([]) %}
{% set leaf_switch_profile_name = prof.name ~ defaults.apic.fabric_policies.leaf_switch_profiles.name_suffix %}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }}
    GET   "/api/mo/uni/fabric/leprof-{{ leaf_switch_profile_name }}.json?rsp-subtree=full"
    String   $..fabricLeafP.attributes.name   {{ leaf_switch_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set leaf_switch_selector_name = sel.name ~ defaults.apic.fabric_policies.leaf_switch_profiles.selectors.name_suffix %}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Selector {{ leaf_switch_selector_name }}
    String   $..fabricLeafS.attributes.name   {{ leaf_switch_selector_name }}

{% if sel.policy is defined %}
{% set policy_group_name = sel.policy ~ defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix %}
Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Policy
    String   $..fabricRsLeNodePGrp.attributes.tDn   uni/fabric/funcprof/lenodepgrp-{{ policy_group_name }}
{% endif %}

{% for blk in sel.node_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.fabric_policies.leaf_switch_profiles.selectors.node_blocks.name_suffix %}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Selector {{ leaf_switch_selector_name }} Node Block {{ block_name }}
    String   $..fabricNodeBlk.attributes.from_   {{ blk.from }}
    String   $..fabricNodeBlk.attributes.name   {{ block_name }}
    String   $..fabricNodeBlk.attributes.to_   {{ blk.to | default(blk.from) }}

{% endfor %}

{% endfor %}

{% for intp in prof.interface_profiles | default([]) %}
{% set leaf_interface_profile_name = intp ~ defaults.apic.fabric_policies.leaf_interface_profiles.name_suffix %}

Verify Fabric Leaf Switch Profile {{ leaf_switch_profile_name }} Interface Profile
    String   $..fabricRsLePortP.attributes.tDn   uni/fabric/leportp-{{ leaf_interface_profile_name }}

{% endfor %}

{% endfor %}
