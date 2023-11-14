{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify External Endpoint Group Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.l3outs.name_suffix %}
{% for epg in l3out.external_endpoint_groups | default([]) %}
{% set eepg_name = epg.name ~ defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix %}

{% if epg.expected_state.maximum_critical_faults is defined or epg.expected_state.maximum_major_faults is defined or epg.expected_state.maximum_minor_faults is defined %}
Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if epg.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ epg.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${critical}[0] critical faults"
{% endif %}
{% if epg.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ epg.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${major}[0] major faults"
{% endif %}
{% if epg.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ epg.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_epg_{{ eepg_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_epg_{{ eepg_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if epg.expected_state.minimum_health is defined %}
Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < {{ epg.expected_state.minimum_health }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} health score: ${health}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_epg_{{ eepg_name }}_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_epg_{{ eepg_name }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}
{% endfor %}
{% endfor %}


{% for l3out in tenant.sr_mpls_l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.sr_mpls_l3outs.name_suffix %}
{% for epg in l3out.external_endpoint_groups | default([]) %}
{% set eepg_name = epg.name ~ defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.name_suffix %}

{% if epg.expected_state.maximum_critical_faults is defined or epg.expected_state.maximum_major_faults is defined or epg.expected_state.maximum_minor_faults is defined %}
Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if epg.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ epg.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${critical}[0] critical faults"
{% endif %}
{% if epg.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ ap.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${major}[0] major faults"
{% endif %}
{% if epg.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ epg.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_l3out_{{ l3out_name }}_external_endpoint_group_{{ eepg_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_l3out_{{ l3out_name }}_external_endpoint_group_{{ eepg_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% if epg.expected_state.minimum_health is defined %}
Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health
     ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < {{ epg.expected_state.minimum_health }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} health score: ${health}[0]"
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_l3out_{{ l3out_name }}_external_endpoint_group_{{ eepg_name }}_health.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_l3out_{{ l3out_name }}_external_endpoint_group_{{ eepg_name }}_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} health score degraded from ${previous["health"]} to ${health}[0]"
{% endif %}

{% endfor %}
{% endfor %}
