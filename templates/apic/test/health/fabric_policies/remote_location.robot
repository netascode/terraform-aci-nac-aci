*** Settings ***
Documentation   Verify Remote Location Health
Suite Setup     Login APIC
Default Tags    apic   day0   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for rl in apic.fabric_policies.remote_locations | default([]) %}
{% set rl_name = rl.name ~ defaults.apic.fabric_policies.remote_locations.name_suffix %}

{% if rl.expected_state.maximum_critical_faults is defined or rl.expected_state.maximum_major_faults is defined or rl.expected_state.maximum_minor_faults is defined %}
Verify Remote Location {{ rl_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/path-{{ rl_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if rl.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ rl.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ rl_name }} has ${critical}[0] critical faults"
{% endif %}
{% if rl.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ rl.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ rl_name }} has ${major}[0] major faults"
{% endif %}
{% if rl.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ rl.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ rl_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Remote Location {{ rl_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/path-{{ rl_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}remote_location_{{ rl_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Remote Location {{ rl_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/path-{{ rl_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}remote_location_{{ rl_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% endfor %}
