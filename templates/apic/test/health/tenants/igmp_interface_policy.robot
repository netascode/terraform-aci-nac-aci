*** Settings ***
Documentation   Verify IGMP Interface Policy Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for igmp_pol in tenant.policies.igmp_interface_policies | default([]) %}
{% set igmp_pol_name = igmp_pol.name ~ defaults.apic.tenants.policies.igmp_interface_policies.name_suffix %}

Verify IGMP Interface Policy Name {{ igmp_pol_name }} Faults
    GET   "/api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${minor} minor faults"

{% endfor %}
