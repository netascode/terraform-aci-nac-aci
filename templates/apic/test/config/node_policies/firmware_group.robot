*** Settings ***
Documentation   Verify Firmware Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for group in apic.node_policies.update_groups | default([]) %}
{% set update_group_name = group.name ~ defaults.apic.node_policies.update_groups.name_suffix %}

Verify Firmware Policy {{ update_group_name }}
    GET   "/api/mo/uni/fabric/fwpol-{{ update_group_name }}.json"
    String   $..firmwareFwP.attributes.name   {{ update_group_name }}

Verify Firmware Group {{ update_group_name }}
    GET   "/api/mo/uni/fabric/fwgrp-{{ update_group_name }}.json?rsp-subtree=full"
    String   $..firmwareFwGrp.attributes.name   {{ update_group_name }}
    String   $..firmwareRsFwgrpp.attributes.tnFirmwareFwPName   {{ update_group_name }}

{% for node in apic.node_policies.nodes | default([]) %}
{% if node.update_group is defined and node.update_group == update_group_name %}

Verify Firmware Group {{ update_group_name }} Node {{ node.id }}
    ${node}=   Set Variable   $..firmwareFwGrp.children[?(@.fabricNodeBlk.attributes.name=='{{ node.id }}')]
    String   ${node}..fabricNodeBlk.attributes.name   {{ node.id }}
    String   ${node}..fabricNodeBlk.attributes.from_   {{ node.id }}
    String   ${node}..fabricNodeBlk.attributes.to_   {{ node.id }}

{% endif %}
{% endfor %}

{% endfor %}
