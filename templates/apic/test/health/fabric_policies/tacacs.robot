*** Settings ***
Documentation   Verify TACACS Provider Health
Suite Setup     Login APIC
Default Tags    apic   day0   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for prov in apic.fabric_policies.aaa.tacacs_providers | default([]) %}




{% if prov.expected_state.maximum_critical_faults is defined or prov.expected_state.maximum_major_faults is defined or prov.expected_state.maximum_minor_faults is defined %}
Verify TACACS Provider {{ prov.hostname_ip }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/userext/tacacsext/tacacsplusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
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
Verify TACACS Provider {{ prov.hostname_ip }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/userext/tacacsext/tacacsplusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_tacacsplusprovider_{{ prov.hostname_ip }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify TACACS Provider {{ prov.hostname_ip }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/userext/tacacsext/tacacsplusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCountsWithDetails.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_tacacsplusprovider_{{ prov.hostname_ip }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if prov.expected_state.minimum_health is defined %}
Verify TACACS Provider {{ prov.hostname_ip }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/tacacsplusprovider-{{ prov.hostname_ip }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < {{ prov.expected_state.minimum_health }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} health score: ${health}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify TACACS Provider {{ prov.hostname_ip }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/tacacsplusprovider-{{ prov.hostname_ip }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_tacacsplusprovider_{{ prov.hostname_ip }}_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify TACACS Provider {{ prov.hostname_ip }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/tacacsplusprovider-{{ prov.hostname_ip }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_tacacsplusprovider_{{ prov.hostname_ip }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} health score degraded from ${previous["health"]} to ${health}[0]"

{% endif %}

{% endfor %}
