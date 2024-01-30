*** Settings ***
Documentation   Verify Access Switch Configuration
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.new_interface_configuration | default(defaults.apic.new_interface_configuration) %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.access_policy_group is defined %}

{% if node.role == "leaf" %}
{% set policy_group_name = node.access_policy_group ~ defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix %}
Verify Access Switch Configuration Leaf {{ node.id }} Policy Group
    ${r}=   GET On Session   apic   /api/mo/uni/infra/nodeconfnode-{{ node.id }}.json
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeConfig.attributes.assocGrp   uni/infra/funcprof/accnodepgrp-{{ policy_group_name }}

{% elif node.role == "spine" %}
{% set policy_group_name = node.access_policy_group ~ defaults.apic.access_policies.spine_switch_policy_groups.name_suffix %}
Verify Access Switch Configuration Spine {{ node.id }} Policy Group
    ${r}=   GET On Session   apic   /api/mo/uni/infra/nodeconfnode-{{ node.id }}.json
    Should Be Equal Value Json String   ${r.json()}    $..infraNodeConfig.attributes.assocGrp   uni/infra/funcprof/spaccnodepgrp-{{ policy_group_name }}

{% endif %}

{% endif %}
{% endfor %}
{% endif %}
