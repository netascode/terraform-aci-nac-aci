{# iterate_list apic.tenants name item[2] #}
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
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${minor}[0] minor faults"

{% endfor %}
