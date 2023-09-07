{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Bridge Domain Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bd in tenant.bridge_domains | default([]) %}
{% set bd_name = bd.name ~ defaults.apic.tenants.bridge_domains.name_suffix %}

{% if bd.expected_state.maximum_critical_faults is defined or bd.expected_state.maximum_major_faults is defined or bd.expected_state.maximum_minor_faults is defined %}
Verify Bridge Domain {{ bd_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
{% if bd.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ bd.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} has ${critical}[0] critical faults"
{% endif %}
{% if bd.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ bd.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} has ${major}[0] major faults"
{% endif %}
{% if bd.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ bd.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Bridge Domain {{ bd_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_bd_{{ bd_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Bridge Domain {{ bd_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_bd_{{ bd_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if bd.expected_state.minimum_health is defined %}
Verify Bridge Domain {{ bd_name }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] <  {{ bd.expected_state.minimum_health }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} health score: ${health}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Bridge Domain {{ bd_name }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_bd_{{ bd_name }}_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Bridge Domain {{ bd_name }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_bd_{{ bd_name }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ bd_name }} health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}
{% endfor %}
