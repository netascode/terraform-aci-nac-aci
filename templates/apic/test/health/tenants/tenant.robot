*** Settings ***
Documentation   Verify Tenant Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for tenant in apic.tenants | default([]) %}

Verify Tenant {{ tenant.name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} has ${minor}[0] minor faults"

Verify Tenant {{ tenant.name }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ tenant.name }} health score: ${health}[0]"

{% endfor %}
