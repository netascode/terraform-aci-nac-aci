{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Tenant SPAN Source Group
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for span in tenant.policies.span.source_groups | default([]) %}
{% set span_src_grp_name = span.name ~ defaults.apic.tenants.policies.span.source_groups.name_suffix %}

Verify Tenant SPAN Source Group {{ span_src_grp_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/srcgrp-{{ span_src_grp_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_src_grp_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_src_grp_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_src_grp_name }} has ${minor}[0] minor faults"

{% endfor %}
