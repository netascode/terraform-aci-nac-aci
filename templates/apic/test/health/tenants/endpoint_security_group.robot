{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Endpoint Security Group Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ap in tenant.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% for esg in ap.endpoint_security_groups | default([]) %}
{% set esg_name = esg.name ~ defaults.apic.tenants.application_profiles.endpoint_security_groups.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/esg-{{ esg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ esg_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ esg_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ esg_name }} has ${minor}[0] minor faults"

Verify Endpoint Security Group {{ esg_name }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/esg-{{ esg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ esg_name }} health score: ${health}[0]"

{% endfor %}

{% endfor %}
