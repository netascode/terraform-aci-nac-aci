*** Settings ***
Documentation   Verify VSPAN Session Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vspan in apic.access_policies.vspan.sessions | default([]) %}
{% set vspan_name = vspan.name ~ defaults.apic.access_policies.vspan.sessions.name_suffix %}

{% if vspan.expected_state.maximum_critical_faults is defined or vspan.expected_state.maximum_major_faults is defined or vspan.expected_state.maximum_minor_faults is defined %}

Verify VSPAN Session {{ vspan_name }} Faults
    GET  "/api/mo/uni/infra/vsrcgrp-{{ vspan_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
{% if vspan.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ vspan.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${critical}[0] critical faults"
{% endif %}
{% if vspan.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ vspan.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${major}[0] major faults"
{% endif %}
{% if vspan.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ vspan.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Application Profile {{ vspan_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ vspan.name }}//fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}vspan_{{ vspan.name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Application Profile {{ vspan_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ vspan.name }}//fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}vspan_{{ vspan.name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Application Profile {{ vspan_name }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ vspan.name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}vspan_{{ vspan.name }}_health.json', 'w'))   modules=json

{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Application Profile {{ vspan_name }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ vspan.name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}vspan_{{ vspan.name }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ vspan_name }} health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}
{% endfor %}
