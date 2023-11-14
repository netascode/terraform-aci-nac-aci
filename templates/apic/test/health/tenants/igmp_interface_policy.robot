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

{% if igmp_pol.expected_state.maximum_critical_faults is defined or igmp_pol.expected_state.maximum_major_faults is defined or igmp_pol.expected_state.maximum_minor_faults is defined %}
Verify IGMP Interface Policy Name {{ igmp_pol_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if igmp_pol.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ igmp_pol.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${critical}[0] critical faults"
{% endif %}
{% if igmp_pol.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ igmp_pol.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${major}[0] major faults"
{% endif %}
{% if igmp_pol.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ igmp_pol.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ igmp_pol_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify IGMP Interface Policy Name {{ igmp_pol_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_igmp_interface_policy_{{ igmp_pol_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify IGMP Interface Policy Name {{ igmp_pol_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_igmp_interface_policy_{{ igmp_pol_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% endfor %}
