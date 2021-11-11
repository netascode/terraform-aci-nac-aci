*** Settings ***
Documentation   Verify SPAN Source Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{%- for span in apic.access_policies.span.source_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.access_policies.span.source_groups.name_suffix %}

Verify SPAN Source Group {{ span_name }}
    GET  "/api/mo/uni/infra/srcgrp-{{ span_name }}.json?rsp-subtree=full"
    String   $..spanSrcGrp.attributes.name   {{ span_name }}
    String   $..spanSrcGrp.attributes.descr   {{ span.description | default() }}
    String   $..spanSrcGrp.attributes.nameAlias   {{ span.alias | default() }}
    String   $..spanSrcGrp.attributes.adminSt   {{ span.admin_state | default(defaults.apic.access_policies.span.source_groups.admin_state) }}
{%- for source in span.sources | default([]) %}

{% set source_name = source.name ~ defaults.apic.access_policies.span.source_groups.sources.name_suffix %}
    ${source}=   Set Variable   $..spanSrcGrp.children[?(@.spanSrc.attributes.name=='{{ source_name }}')].spanSrc
    String   ${source}.attributes.name   {{ source_name }}
{%- for path in source.access_paths| default([]) %}

{% if path.node_id is defined and path.channel is not defined %}
{% set query = "nodes[?id==`" ~ path.node_id ~ "`].pod" %}
{% set pod = path.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]')].spanRsSrcToPathEp
    String   ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]
{% else %}
{% set policy_group_name = path.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ path.channel ~ "`].type" %}
{% set type = (apic.access_policies | json_query(query))[0] %}
{% set query = "nodes[?interfaces[?policy_group==`" ~ path.channel ~ "`]].id" %}
{% set node = (apic.interface_policies | json_query(query))[0] %}
{% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
{% set pod = path.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
{% if type == 'vpc' %}
{% set query = "nodes[?interfaces[?policy_group==`" ~ path.channel ~ "`]].id" %}
{% set node2 = (apic.interface_policies | json_query(query))[1] %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]')].spanRsSrcToPathEp 
    String   ${path}.attributes.tDn   topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]
{% else %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]')].spanRsSrcToPathEp
    String   ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
{% endif %}
{% endif %}
{% endfor %}
{% endfor %}
{% set destination_name = span.destination.name ~ defaults.apic.access_policies.span.destination_groups.name_suffix %}
    String   $..spanSrcGrp.children..spanSpanLbl.attributes.name   {{ destination_name }}
    String   $..spanSrcGrp.children..spanSpanLbl.attributes.descr   {{ span.destination.description | default() }}
    String   $..spanSrcGrp.children..spanSpanLbl.attributes.nameAlias   {{ span.destination.alias | default() }}
{% endfor %}
