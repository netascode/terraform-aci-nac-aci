*** Settings ***
Documentation   Verify SPAN Filter Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% macro get_protocol_from_port(name) -%}
    {% set ports = {0:"unspecified",20:"ftpData",25:"smtp",53:"dns",110:"pop3",554:"rtsp",80:"http",443:"https",22:"ssh"} %}
    {{ ports[name] | default(name)}}
{% endmacro %}
{% for filter_ in apic.access_policies.span.filter_groups | default([]) %}
{% set filter_name = filter_.name ~ defaults.apic.access_policies.span.filter_groups.name_suffix %}

Verify SPAN Filter Group {{ filter_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/filtergrp-{{ filter_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..spanFilterGrp.attributes.name   {{ filter_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanFilterGrp.attributes.descr   {{ filter_.description | default() }}

{% for entry in filter_.entries | default([]) %}
{% set entry_name = entry.name ~ defaults.apic.access_policies.span.filter_groups.entries.name_suffix %}
Verify SPAN Filter Group {{ filter_name }} Entry {{ entry_name }}
    ${entry}=   Set Variable   $..spanFilterGrp.children[?(@.spanFilterEntry.attributes.name=='{{ entry_name }}')].spanFilterEntry
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.name   {{ entry_name }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.descr   {{ entry.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.dstAddr   {{ entry.destination_ip }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.dstPortFrom   {{ get_protocol_from_port(entry.destination_from_port | default(defaults.apic.access_policies.span.filter_groups.entries.destination_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.dstPortTo   {{ get_protocol_from_port(entry.destination_to_port | default(entry.destination_from_port | default(defaults.apic.access_policies.span.filter_groups.entries.destination_from_port))) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.ipProto   {{ entry.ip_protocol | default(defaults.apic.access_policies.span.filter_groups.entries.ip_protocol) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.srcAddr   {{ entry.source_ip }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.srcPortFrom   {{ get_protocol_from_port(entry.source_from_port | default(defaults.apic.access_policies.span.filter_groups.entries.source_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}.attributes.srcPortTo   {{ get_protocol_from_port(entry.source_to_port | default(entry.source_from_port | default(defaults.apic.access_policies.span.filter_groups.entries.source_from_port))) }}

{% endfor %}

{% endfor %}