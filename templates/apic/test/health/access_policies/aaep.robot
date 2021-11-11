*** Settings ***
Documentation   Verify AAEP Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   access_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for aaep in apic.access_policies.aaeps | default([]) %}
{% set aaep_name = aaep.name ~ defaults.apic.access_policies.aaeps.name_suffix %}

Verify AAEP {{ aaep_name }} Faults
    GET   "/api/mo/uni/infra/attentp-{{ aaep_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ aaep_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ aaep_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ aaep_name }} has ${minor} minor faults"

{% endfor %}
