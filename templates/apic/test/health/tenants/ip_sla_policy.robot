*** Settings ***
Documentation   Verify IP SLA Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ip_sla in tenant.policies.ip_sla_policies | default([]) %}
{% set ip_sla_name = ip_sla.name ~ defaults.apic.tenants.policies.ip_sla_policies.name_suffix %} 

Verify IP SLA {{ ip_sla_name }} Faults
    GET   "/api/node/mo/uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ ip_sla_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ip_sla_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ip_sla_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ip_sla_name }} has ${minor} minor faults"

{% endfor %}
