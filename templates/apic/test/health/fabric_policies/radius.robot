*** Settings ***
Documentation   Verify RADIUS Provider Health
Suite Setup     Login APIC
Default Tags    apic   day0   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for prov in apic.fabric_policies.aaa.radius_providers | default([]) %}

{% if prov.expected_state.maximum_critical_faults is defined or prov.expected_state.maximum_major_faults is defined or prov.expected_state.maximum_minor_faults is defined %}
Verify RADIUS Provider {{ prov.hostname_ip }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/userext/radiusext/radiusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if prov.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ prov.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} has ${critical}[0] critical faults"
{% endif %}
{% if prov.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ prov.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} has ${major}[0] major faults"
{% endif %}
{% if prov.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ prov.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify RADIUS Provider {{ prov.hostname_ip }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/userext/radiusext/radiusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}radius_{{ prov.hostname_ip }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify RADIUS Provider {{ prov.hostname_ip }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/userext/radiusext/radiusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}radius_{{ prov.hostname_ip }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% endfor %}