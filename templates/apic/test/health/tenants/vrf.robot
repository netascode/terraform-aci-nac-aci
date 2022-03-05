*** Settings ***
Documentation   Verify VRF Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for vrf in tenant.vrfs | default([]) %}
{% set vrf_name = vrf.name ~ ('' if vrf.name in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}

Verify VRF {{ vrf_name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ctx-{{ vrf_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} has ${minor} minor faults"

Verify VRF {{ vrf_name }} Health
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ctx-{{ vrf_name }}/health.json"
    ${health}=   Output   $..healthInst.attributes.cur
    Run Keyword If   ${health} < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} health score: ${health}"

{% endfor %}
