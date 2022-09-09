{# iterate_list apic.tenants name item[2] #}
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
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ ip_sla_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ip_sla_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ip_sla_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ip_sla_name }} has ${minor}[0] minor faults"

{% endfor %}
