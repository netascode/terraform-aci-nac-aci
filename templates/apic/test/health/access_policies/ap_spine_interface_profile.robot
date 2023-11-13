*** Settings ***
Documentation   Verify Access Spine Interface Profile Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   access_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.spine_interface_profile_name | default(defaults.apic.access_policies.spine_interface_profile_name))) %}

{% if node.expected_state.maximum_critical_faults is defined or node.expected_state.maximum_major_faults is defined or node.expected_state.maximum_minor_faults is defined %}

Verify Spine Switch Profile {{ spine_switch_profile_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/infra/spprof-{{ spine_switch_profile_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
{% if node.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ node.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ spine_switch_profile_name }} has ${critical}[0] critical faults"
{% endif %}
{% if node.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ node.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ spine_switch_profile_name }} has ${major}[0] major faults"
{% endif %}
{% if node.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ node.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ spine_switch_profile_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}
{% if 'pre-check' in robot_include_tags | default() %}
Verify Application Profile {{ node_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ spine_switch_profile_name }}/node-{{ node_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ spine_switch_profile_name }}_node_{{ node_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Application Profile {{ node_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ spine_switch_profile_name }}/node-{{ node_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ spine_switch_profile_name }}_node_{{ node_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Application Profile {{ node_name }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ spine_switch_profile_name }}/node-{{ node_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ spine_switch_profile_name }}_node_{{ node_name }}_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Application Profile {{ node_name }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ spine_switch_profile_name }}/ap-{{ node_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_ap_{{ ap_name }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ ap_name }} health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}
{% endif %}
{% endfor %}
