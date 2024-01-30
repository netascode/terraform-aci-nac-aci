*** Settings ***
Documentation   Verify Fabric Switch Configuration
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.new_interface_configuration | default(defaults.apic.new_interface_configuration) %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.fabric_policy_group is defined %}

{% if node.role == "leaf" %}
{% set policy_group_name = node.fabric_policy_group ~ defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix %}
Verify Fabric Switch Configuration Leaf {{ node.id }} Policy Group
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/nodeconfnode-{{ node.id }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeConfig.attributes.assocGrp   uni/fabric/funcprof/lenodepgrp-{{ policy_group_name }}

{% elif node.role == "spine" %}
{% set policy_group_name = node.fabric_policy_group ~ defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix %}
Verify Fabric Switch Configuration Spine {{ node.id }} Policy Group
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/nodeconfnode-{{ node.id }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeConfig.attributes.assocGrp   uni/fabric/funcprof/spnodepgrp-{{ policy_group_name }}

{% endif %}

{% endif %}
{% endfor %}
{% endif %}
