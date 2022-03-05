*** Settings ***
Documentation   Verify Fabric SPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{%- for span in apic.fabric_policies.span.destination_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.fabric_policies.span.destination_groups.name_suffix %}

Verify SPAN Destination Group {{ span_name }}
    GET  "/api/mo/uni/fabric/destgrp-{{ span_name }}.json?rsp-subtree=full"
    String   $..spanDestGrp.attributes.name   {{ span_name }}
    String   $..spanDestGrp.attributes.descr   {{ span.description | default() }}
    String   $..spanDestGrp.children..spanDest.attributes.name   {{ span_name }} 
{% if span.tenant is defined and span.application_profile is defined and span.endpoint_group is defined %}
{% set application_profile_name = span.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = span.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ip   {{ span.ip }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.srcIpPrefix   {{ span.source_prefix }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.dscp   {{ span.dscp | default(defaults.apic.fabric_policies.span.destination_groups.dscp) }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.flowId   {{ span.flow_id | default(defaults.apic.fabric_policies.span.destination_groups.flow_id) }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.mtu   {{ span.mtu | default(defaults.apic.fabric_policies.span.destination_groups.mtu) }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ttl   {{ span.ttl | default(defaults.apic.fabric_policies.span.destination_groups.ttl) }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.ver   ver{{ span.version | default(defaults.apic.fabric_policies.span.destination_groups.version) }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.verEnforced   {{ span.enforce_version | default(defaults.apic.fabric_policies.span.destination_groups.enforce_version) | cisco.aac.aac_bool("yes") }}
    String   $..spanDestGrp.children..spanDest.children..spanRsDestEpg.attributes.tDn   uni/tn-{{ span.tenant | default(tenant.name) }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}
{% endif %}                                  

{% endfor %}