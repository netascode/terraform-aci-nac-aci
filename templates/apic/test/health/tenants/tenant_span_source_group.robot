*** Settings ***
Documentation   Verify Tenant SPAN Source Group
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for span in tenant.policies.span.source_groups | default([]) %}
{% set span_src_grp_name = span.name ~ defaults.apic.tenants.policies.span.source_groups.name_suffix %}

Verify Tenant SPAN Source Group {{ span_src_grp_name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/srcgrp-{{ span_src_grp_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_src_grp_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_src_grp_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_src_grp_name }} has ${minor} minor faults"

{% endfor %}
