{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Tenant SPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for span in tenant.policies.span.destination_groups | default([]) %}
{% set span_dst_grp_name = span.name ~ defaults.apic.tenants.policies.span.destination_groups.name_suffix %}
{% set application_profile_name = span.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = span.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}

Verify Tenant SPAN Destination Group {{ span_dst_grp_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/destgrp-{{ span_dst_grp_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..spanDestGrp.attributes.name   {{ span_dst_grp_name }}
    Should Be Equal Value Json String   ${r.json()}   $..spanDestGrp.attributes.descr   {{ span.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..spanDest.attributes.name   {{ span_dst_grp_name }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.ip   {{ span.ip }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.srcIpPrefix   {{ span.source_prefix }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.dscp   {{ span.dscp | default(defaults.apic.tenants.policies.span.destination_groups.dscp) }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.flowId   {{ span.flow_id | default(defaults.apic.tenants.policies.span.destination_groups.flow_id) }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.mtu   {{ span.mtu | default(defaults.apic.tenants.policies.span.destination_groups.mtu) }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.ttl   {{ span.ttl | default(defaults.apic.tenants.policies.span.destination_groups.ttl) }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.ver   ver{{ span.version | default(defaults.apic.tenants.policies.span.destination_groups.version) }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.verEnforced   {{ span.enforce_version | default(defaults.apic.tenants.policies.span.destination_groups.enforce_version) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..spanRsDestEpg.attributes.tDn   uni/tn-{{ span.tenant | default(tenant.name) }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}

{% endfor %}
