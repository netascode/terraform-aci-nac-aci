*** Settings ***
Documentation   Verify SPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for span in apic.access_policies.span.destination_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.access_policies.span.destination_groups.name_suffix %}

Verify SPAN Destination Group {{ span_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/destgrp-{{ span_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.attributes.name   {{ span_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.attributes.descr   {{ span.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.attributes.name   {{ span_name }} 
{% if span.node_id is defined or span.channel is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.mtu   {{ span.mtu | default(defaults.apic.access_policies.span.destination_groups.mtu) }}
{% if span.node_id is defined and span.channel is not defined %}
    {% set query = "nodes[?id==`" ~ span.node_id ~ "`].pod" %}
    {% set pod = span.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
    {% if span.sub_port is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ span.node_id }}/pathep-[eth{{ span.module | default(defaults.apic.access_policies.span.destination_groups.module) }}/{{ span.port }}/{{ span.sub_port }}]
    {%else%}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ span.node_id }}/pathep-[eth{{ span.module | default(defaults.apic.access_policies.span.destination_groups.module) }}/{{ span.port }}]
    {% endif %}                                                    
{% else %}
    {% set policy_group_name = span.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
    {% set query_sub_ports = "nodes[?interfaces[?sub_ports[?policy_group==`" ~ span.channel ~ "`]]].id" %}
    {% set id_sub_ports = (apic.interface_policies | default() | community.general.json_query(query_sub_ports)) %}
    {% set query_ports = "nodes[?interfaces[?policy_group==`" ~ span.channel ~ "`]].id" %}
    {% set id_ports = (apic.interface_policies | default() | community.general.json_query(query_ports)) %}
    {% if id_sub_ports | length > 0 %}
        {% if span.node_id is defined %}
            {% set node = span.node_id %}
        {% else %}
            {% set query = "nodes[?interfaces[?sub_ports[?policy_group==`" ~ span.channel ~ "`]]].id" %}
            {% set node = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
        {% endif %}
        {% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
        {% set pod = span.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]                                                
    {% elif id_ports | length > 0 %}
        {% if span.node_id is defined %}
            {% set node = span.node_id %}
        {% else %}
            {% set query = "nodes[?interfaces[?policy_group==`" ~ span.channel ~ "`]].id" %}
            {% set node = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
        {% endif %}
        {% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
        {% set pod = span.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
    {% endif %}
{% endif %}

{% elif span.tenant is defined and span.application_profile is defined and span.endpoint_group is defined %}
{% set application_profile_name = span.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = span.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ip   {{ span.ip }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.srcIpPrefix   {{ span.source_prefix }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.dscp   {{ span.dscp | default(defaults.apic.access_policies.span.destination_groups.dscp) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.flowId   {{ span.flow_id | default(defaults.apic.access_policies.span.destination_groups.flow_id) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.mtu   {{ span.mtu | default(defaults.apic.access_policies.span.destination_groups.mtu) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ttl   {{ span.ttl | default(defaults.apic.access_policies.span.destination_groups.ttl) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ver   ver{{ span.version | default(defaults.apic.access_policies.span.destination_groups.version) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.verEnforced   {{ span.enforce_version | default(defaults.apic.access_policies.span.destination_groups.enforce_version) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.tDn   uni/tn-{{ span.tenant | default(tenant.name) }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}
{% endif %}                                  

{% endfor %}
