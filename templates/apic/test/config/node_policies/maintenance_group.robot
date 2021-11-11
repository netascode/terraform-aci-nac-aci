*** Settings ***
Documentation   Verify Maintenance Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for group in apic.node_policies.update_groups | default([]) %}
{% set update_group_name = group.name ~ defaults.apic.node_policies.update_groups.name_suffix %}

Verify Maintenance Policy {{ update_group_name }}
    GET   "/api/mo/uni/fabric/maintpol-{{ update_group_name }}.json?rsp-subtree=full"
    String   $..maintMaintP.attributes.name   {{ update_group_name }}
{% if group.scheduler is defined%}
    {% set scheduler_name = group.scheduler ~ defaults.apic.fabric_policies.schedulers.name_suffix %}
{% endif %}
    String   $..maintRsPolScheduler.attributes.tnTrigSchedPName   {{ group.scheduler_name | default(defaults.apic.node_policies.update_groups.scheduler) }}

Verify Maintenance Group {{ update_group_name }}
    GET   "/api/mo/uni/fabric/maintgrp-{{ update_group_name }}.json?rsp-subtree=full"
    String   $..maintMaintGrp.attributes.name   {{ update_group_name }}
    String   $..maintRsMgrpp.attributes.tnMaintMaintPName   {{ update_group_name }}

{% for node in apic.node_policies.nodes | default([]) %}
{% if node.update_group is defined and node.update_group == update_group_name %}

Verify Maintenance Group {{ update_group_name }} Node {{ node.id }}
    ${node}=   Set Variable   $..maintMaintGrp.children[?(@.fabricNodeBlk.attributes.name=='{{ node.id }}')]
    String   ${node}..fabricNodeBlk.attributes.name   {{ node.id }}
    String   ${node}..fabricNodeBlk.attributes.from_   {{ node.id }}
    String   ${node}..fabricNodeBlk.attributes.to_   {{ node.id }}

{% endif %}
{% endfor %}

{% endfor %}
