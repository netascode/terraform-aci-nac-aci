{# iterate_list apic.tenants name item[2] #}
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
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ctx-{{ vrf_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} has ${minor}[0] minor faults"

Verify VRF {{ vrf_name }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ctx-{{ vrf_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ vrf_name }} health score: ${health}[0]"

{% endfor %}
