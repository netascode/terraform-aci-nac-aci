*** Settings ***
Documentation   Verify SPAN Filter Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% macro get_protocol_from_port(name) -%}
    {% set ports = {0:"unspecified",20:"ftpData",25:"smtp",53:"dns",110:"pop3",554:"rtsp",80:"http",443:"https"} %}
    {{ ports[name] | default(name)}}
{% endmacro %}
{% for filter_ in apic.access_policies.span.filter_groups | default([]) %}
{% set filter_name = filter_.name ~ defaults.apic.access_policies.span.filter_groups.name_suffix %}

Verify SPAN Filter Group {{ filter_name }}
    GET  "/api/mo/uni/infra/filtergrp-{{ filter_name }}.json?rsp-subtree=full"
    String   $..spanFilterGrp.attributes.name   {{ filter_name }}
    String   $..spanFilterGrp.attributes.descr   {{ filter_.description | default() }}

{% for entry in filter_.entries | default([]) %}
{% set entry_name = entry.name ~ defaults.apic.access_policies.span.filter_groups.entries.name_suffix %}
Verify SPAN Filter Group {{ filter_name }} Entry {{ entry_name }}
    ${entry}=   Set Variable   $..spanFilterGrp.children[?(@.spanFilterEntry.attributes.name=='{{ entry_name }}')].spanFilterEntry
    String   ${entry}.attributes.name   {{ entry_name }}
    String   ${entry}.attributes.descr   {{ entry.description | default() }}
    String   ${entry}.attributes.dstAddr   {{ entry.destination_ip }}
    String   ${entry}.attributes.dstPortFrom   {{ get_protocol_from_port(entry.destination_port_from | default(defaults.apic.access_policies.span.filter_groups.entries.destination_port_from)) }}
    String   ${entry}.attributes.dstPortTo   {{ get_protocol_from_port(entry.destination_port_to | default(defaults.apic.access_policies.span.filter_groups.entries.destination_port_to)) }}
    String   ${entry}.attributes.ipProto   {{ entry.ip_protocol | default(defaults.apic.access_policies.span.filter_groups.entries.ip_protocol) }}
    String   ${entry}.attributes.srcAddr   {{ entry.source_ip }}
    String   ${entry}.attributes.srcPortFrom   {{ get_protocol_from_port(entry.source_port_from | default(defaults.apic.access_policies.span.filter_groups.entries.source_port_from)) }}
    String   ${entry}.attributes.srcPortTo   {{ get_protocol_from_port(entry.source_port_to | default(defaults.apic.access_policies.span.filter_groups.entries.source_port_to)) }}

{% endfor %}

{% endfor %}