*** Settings ***
Documentation   Verify Tenant Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for tenant in apic.tenants | default([]) %}

Verify Tenant {{ tenant.name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/fltCnts.json"
    ${critical}=   Output   $..faultCountsWithDetails.attributes.crit
    ${major}=   Output   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Output   $..faultCountsWithDetails.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} has ${minor} minor faults"

Verify Tenant {{ tenant.name }} Health
    GET   "/api/mo/uni/tn-{{ tenant.name }}/health.json"
    ${health}=   Output   $..healthInst.attributes.cur
    Run Keyword If   ${health} < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} health score: ${health}"

{% endfor %}
