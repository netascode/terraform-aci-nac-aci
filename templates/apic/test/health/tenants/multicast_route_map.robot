*** Settings ***
Documentation   Verify Multicast Route Map Policies Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for policy in tenant.policies.multicast_route_maps | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}

Verify Multicast Route Map {{ policy_name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/rtmap-{{ policy_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ policy_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ policy_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ policy_name }} has ${minor} minor faults"

{% endfor %}
