*** Settings ***
Documentation   Verify Bridge Domain Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bd in tenant.bridge_domains | default([]) %}
{% set bd_name = bd.name ~ defaults.apic.tenants.bridge_domains.name_suffix %}

Verify Bridge Domain {{ bd_name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} has ${minor} minor faults"

Verify Bridge Domain {{ bd_name }} Health
    GET   "/api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/health.json"
    ${health}=   Output   $..healthInst.attributes.cur
    Run Keyword If   ${health} < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} health score: ${health}"

{% endfor %}
