{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Tenant SPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenant
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for span in tenant.policies.span.destination_groups | default([]) %}
{% set span_dst_grp_name = span.name ~ defaults.apic.tenants.policies.span.destination_groups.name_suffix %}
{% set application_profile_name = span.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = span.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}

Verify Tenant SPAN Destination Group {{ span_dst_grp_name }}
    GET  "/api/mo/uni/tn-{{ tenant.name }}/destgrp-{{ span_dst_grp_name }}.json?rsp-subtree=full"
    String   $..spanDestGrp.attributes.name   {{ span_dst_grp_name }}
    String   $..spanDestGrp.attributes.descr   {{ span.description | default() }}
    String   $..spanDest.attributes.name   {{ span_dst_grp_name }}
    String   $..spanRsDestEpg.attributes.ip   {{ span.ip }}
    String   $..spanRsDestEpg.attributes.srcIpPrefix   {{ span.source_prefix }}
    String   $..spanRsDestEpg.attributes.dscp   {{ span.dscp | default(defaults.apic.tenants.policies.span.destination_groups.dscp) }}
    String   $..spanRsDestEpg.attributes.flowId   {{ span.flow_id | default(defaults.apic.tenants.policies.span.destination_groups.flow_id) }}
    String   $..spanRsDestEpg.attributes.mtu   {{ span.mtu | default(defaults.apic.tenants.policies.span.destination_groups.mtu) }}
    String   $..spanRsDestEpg.attributes.ttl   {{ span.ttl | default(defaults.apic.tenants.policies.span.destination_groups.ttl) }}
    String   $..spanRsDestEpg.attributes.ver   ver{{ span.version | default(defaults.apic.tenants.policies.span.destination_groups.version) }}
    String   $..spanRsDestEpg.attributes.verEnforced   {{ span.enforce_version | default(defaults.apic.tenants.policies.span.destination_groups.enforce_version) | cisco.aac.aac_bool("yes") }}
    String   $..spanRsDestEpg.attributes.tDn   uni/tn-{{ span.tenant | default(tenant.name) }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}

{% endfor %}
