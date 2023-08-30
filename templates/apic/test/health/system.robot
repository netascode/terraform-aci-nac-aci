*** Settings ***
Documentation   Verify System Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   system   non-critical
Resource        ../apic_common.resource

*** Test Cases ***
{% if apic.expected_state.maximum_critical_faults is defined or apic.expected_state.maximum_major_faults is defined or apic.expected_state.maximum_minor_faults is defined %}
Verify System Faults
    ${r}=   GET On Session   apic   /api/node/mo/topology/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if apic.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ apic.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "System has ${critical}[0] critical faults"
{% endif %}
{% if apic.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ apic.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "System has ${major}[0] major faults"
{% endif %}
{% if apic.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ apic.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "System has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify System Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/node/mo/topology/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}system_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify System Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/node/mo/topology/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}system_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if apic.expected_state.minimum_health is defined %}
Verify System Health
    ${r}=   GET On Session   apic   /api/node/mo/topology/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..fabricHealthTotal.attributes.cur
    Run Keyword If   ${health}[0] < {{ apic.expected_state.minimum_health }}   Run Keyword And Continue On Failure
    ...   Fail  "System health score: ${health}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify System Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/node/mo/topology/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..fabricHealthTotal.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}system_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify System Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/node/mo/topology/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..fabricHealthTotal.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}system_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "System health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}
