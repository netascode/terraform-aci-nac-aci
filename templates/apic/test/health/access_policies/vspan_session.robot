*** Settings ***
Documentation   Verify VSPAN Session Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vspan in apic.access_policies.vspan.sessions | default([]) %}
{% set vspan_name = vspan.name ~ defaults.apic.access_policies.vspan.sessions.name_suffix %}

Verify VSPAN Session {{ vspan_name }} Faults
    GET  "/api/mo/uni/infra/vsrcgrp-{{ vspan_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${minor} minor faults"

{% endfor %}
