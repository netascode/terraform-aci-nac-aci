*** Settings ***
Documentation   Verify SPAN Source Groups Profile Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for span in apic.access_policies.span.span_sources_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.access_policies.span.span_sources_groups.name_suffix %}

Verify SPAN Source Group {{ span_name }} Faults
    GET  "/api/mo/uni/infra/srcgrp-{{ span_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${minor}[0] minor faults"

{% endfor %}
