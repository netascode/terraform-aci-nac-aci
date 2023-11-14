
*** Settings ***
Documentation   Verify Fabric SPAN Source Groups Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{%- for span in apic.fabric_policies.span.span_sources_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.fabric_policies.span.span_sources_groups.name_suffix %}

{% if span.expected_state.maximum_critical_faults is defined or span.expected_state.maximum_major_faults is defined or span.expected_state.maximum_minor_faults is defined %}
Verify SPAN Source Group {{ span_name }} Faults
    ${r}=   GET On Session   apic  /api/mo/uni/fabric/srcgrp-{{ span_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if span.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ span.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${critical}[0] critical faults"
{% endif %}
{% if span.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ span.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${major}[0] major faults"
{% endif %}
{% if span.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ span.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ span_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify SPAN Source Group {{ span_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/srcgrp-{{ span_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}fp_span_source_group_{{ span_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify SPAN Source Group {{ span_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/srcgrp-{{ span_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}fp_span_source_group_{{ span_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% endfor %}
