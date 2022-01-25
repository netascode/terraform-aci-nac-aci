
*** Settings ***
Documentation   Verify Fabric SPAN Source Groups Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{%- for span in apic.fabric_policies.span.span_sources_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.fabric_policies.span.span_sources_groups.name_suffix %}

Verify SPAN Source Group {{ span_name }} Faults
    GET  "/api/mo/uni/fabric/srcgrp-{{ span_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${minor} minor faults"

{% endfor %}