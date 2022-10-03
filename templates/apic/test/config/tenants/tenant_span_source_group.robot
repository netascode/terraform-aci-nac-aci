{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Tenant SPAN Source Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for span in tenant.policies.span.source_groups | default([]) %}
{% set span_grp_name = span.name ~ defaults.apic.tenants.policies.span.source_groups.name_suffix %}
{% set span_destination_name = span.destination ~ defaults.apic.tenants.policies.span.destination_groups.name_suffix %}

Verify Tenant SPAN Source Group {{ span_grp_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/srcgrp-{{ span_grp_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..spanSrcGrp.attributes.name   {{ span_grp_name }}
    Should Be Equal Value Json String   ${r.json()}   $..spanSrcGrp.attributes.descr   {{ span.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..spanSrcGrp.attributes.adminSt   {{ span.admin_state | default(defaults.apic.tenants.policies.span.source_groups.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}   $..spanSpanLbl.attributes.name   {{ span_destination_name }}

{% for source in span.sources | default([]) %}
Verify Tenant SPAN Source Group {{ span_grp_name }} Source {{ source.name }}
    ${src}=   Set Variable   $..spanSrcGrp.children[?(@.spanSrc.attributes.name=='{{ source.name }}')].spanSrc
    Should Be Equal Value Json String   ${r.json()}   ${src}.attributes.name   {{ source.name  }}
    Should Be Equal Value Json String   ${r.json()}   ${src}.attributes.descr   {{ source.description | default()}}
    Should Be Equal Value Json String   ${r.json()}   ${src}.attributes.dir   {{ source.direction | default(defaults.apic.tenants.policies.span.source_groups.sources.direction ) }}
{% if source.application_profile is defined and source.endpoint_group is defined %}
{% set application_profile_name = source.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = source.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}                                    
    Should Be Equal Value Json String   ${r.json()}   ${src}..spanRsSrcToEpg.attributes.tDn   uni/tn-{{ tenant.name }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}
{% endif %} 

{% endfor %}

{% endfor %}
