*** Settings ***
Documentation   Verify SPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{%- for span in apic.access_policies.span.destination_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.access_policies.span.destination_groups.name_suffix %}

Verify SPAN Destination Group {{ span_name }}
    GET  "/api/mo/uni/infra/destgrp-{{ span_name }}.json?rsp-subtree=full"
    String   $..spanDestGrp.attributes.name   {{ span_name }}
    String   $..spanDestGrp.attributes.descr   {{ span.description | default() }}
    String   $..spanDestGrp.attributes.nameAlias   {{ span.alias | default() }} 
    String   $..spanDestGrp.children..spanDest.attributes.name   {{ span_name }} 
    String   $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.mtu   {{ span.mtu | default(defaults.apic.access_policies.span.destination_groups.mtu) }}
{% if span.node_id is defined and span.channel is not defined%}
{% set query = "nodes[?id==`" ~ span.node_id ~ "`].pod" %}
{% set pod = span.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ span.node_id }}/pathep-[eth{{ span.module | default(defaults.apic.access_policies.span.destination_groups.module) }}/{{ span.port }}]
{% else %}
{% set policy_group_name = span.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ span.channel ~ "`].type" %}
{% set type = (apic.access_policies | json_query(query))[0] %}
{% set query = "nodes[?interfaces[?policy_group==`" ~ span.channel ~ "`]].id" %}
{% set node = (apic.interface_policies | json_query(query))[0] %}
{% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
{% set pod = span.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
{% endif %} 
{% endfor %}
