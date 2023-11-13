*** Settings ***
Documentation   Verify Routed Domain Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   access_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for domain in apic.access_policies.routed_domains | default([]) %}
{% set domain_name = domain.name ~ defaults.apic.access_policies.routed_domains.name_suffix %}

{% if domain.expected_state.maximum_critical_faults is defined or domain.expected_state.maximum_major_faults is defined or domain.expected_state.maximum_minor_faults is defined %}

Verify Routed Domain {{ domain_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/l3dom-{{ domain_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
{% if domain.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ domain.expected_state.maximum_critical_faults }}   Run Keyword And Continue 
    ...   Fail  "{{ domain_name }} has ${critical}[0] critical faults"
{% endif %}
{% if domain.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ domain.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ domain_name }} has ${major}[0] major faults"
{% endif %}
{% if domain.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ domain.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ domain_name }} has ${minor}[0] minor faults"

{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Application Profile {{ ap_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ domain.name }}//fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}domain_{{ domain.name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Application Profile {{ ap_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ domain.name }}//fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}domain_{{ domain.name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if domain.expected_state.minimum_health is defined %}
Verify Application Profile {{ domain_name }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ domain.name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < {{ domain.expected_state.minimum_health }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ domain_name }} health score: ${health}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Application Profile {{ ap_name }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ domain.name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}domain_{{ domain.name }}_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Application Profile {{ ap_name }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ domain.name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}domain_{{ domain.name }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ ap_name }} health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}
{% endfor %}