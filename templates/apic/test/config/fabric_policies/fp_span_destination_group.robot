*** Settings ***
Documentation   Verify Fabric SPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{%- for span in apic.fabric_policies.span.destination_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.fabric_policies.span.destination_groups.name_suffix %}

Verify SPAN Destination Group {{ span_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/destgrp-{{ span_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.attributes.name   {{ span_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.attributes.descr   {{ span.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.attributes.name   {{ span_name }} 
{% if span.tenant is defined and span.application_profile is defined and span.endpoint_group is defined %}
{% set application_profile_name = span.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = span.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ip   {{ span.ip }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.srcIpPrefix   {{ span.source_prefix }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.dscp   {{ span.dscp | default(defaults.apic.fabric_policies.span.destination_groups.dscp) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.flowId   {{ span.flow_id | default(defaults.apic.fabric_policies.span.destination_groups.flow_id) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.mtu   {{ span.mtu | default(defaults.apic.fabric_policies.span.destination_groups.mtu) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ttl   {{ span.ttl | default(defaults.apic.fabric_policies.span.destination_groups.ttl) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ver   ver{{ span.version | default(defaults.apic.fabric_policies.span.destination_groups.version) }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.verEnforced   {{ span.enforce_version | default(defaults.apic.fabric_policies.span.destination_groups.enforce_version) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.tDn   uni/tn-{{ span.tenant | default(tenant.name) }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}
{% endif %}                                  

{% endfor %}