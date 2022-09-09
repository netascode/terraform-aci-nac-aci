*** Settings ***
Documentation   Verify VSPAN Destination Group Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vspan in apic.access_policies.vspan.destination_groups | default([]) %}
{% set vspan_name = vspan.name ~ defaults.apic.access_policies.vspan.destination_groups.name_suffix %}

Verify VSPAN Destination Group {{ vspan_name }} Faults
    GET  "/api/mo/uni/infra/vdestgrp-{{ vspan_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${minor}[0] minor faults"

{% endfor %}
