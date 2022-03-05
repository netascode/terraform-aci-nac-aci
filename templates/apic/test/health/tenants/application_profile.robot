*** Settings ***
Documentation   Verify Application Profile Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ap in tenant.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.apic.tenants.application_profiles.name_suffix %}

Verify Application Profile {{ ap_name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ap_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ap_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ap_name }} has ${minor} minor faults"

Verify Application Profile {{ ap_name }} Health
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/health.json"
    ${health}=   Output   $..healthInst.attributes.cur
    Run Keyword If   ${health} < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ ap_name }} health score: ${health}"

{% endfor %}
