{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify IGMP Snooping Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for igmp_snoop_pol in tenant.policies.igmp_snooping_policies | default([]) %}
{% set policy_name = igmp_snoop_pol.name ~ defaults.apic.tenants.policies.igmp_snooping_policies.name_suffix %}

{% if igmp_snoop_pol.expected_state.maximum_critical_faults is defined or igmp_snoop_pol.expected_state.maximum_major_faults is defined or igmp_snoop_pol.expected_state.maximum_minor_faults is defined %}
Verify IGMP Snooping Policy {{ policy_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/snPol-{{ policy_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if igmp_snoop_pol.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ igmp_snoop_pol.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ policy_name }} has ${critical}[0] critical faults"
{% endif %}
{% if igmp_snoop_pol.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ igmp_snoop_pol.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ policy_name }} has ${major}[0] major faults"
{% endif %}
{% if igmp_snoop_pol.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ igmp_snoop_pol.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ policy_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify IGMP Snooping Policy {{ policy_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/snPol-{{ policy_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_igmp_snooping_policy_{{ policy_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify IGMP Snooping Policy {{ policy_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/snPol-{{ policy_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_igmp_snooping_policy_{{ policy_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% endfor %}
