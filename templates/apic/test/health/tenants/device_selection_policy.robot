{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Device Selection Policy Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for dsp in tenant.services.device_selection_policies | default([]) %}
{% set query = "service_graph_templates[?name==`" ~ dsp.service_graph_template ~ "`]" %}
{% set sgt = (tenant.services | community.general.json_query(query))[0] %}
{% set contract_name = dsp.contract ~ defaults.apic.tenants.contracts.name_suffix %} 
{% set sgt_name = dsp.service_graph_template ~ defaults.apic.tenants.services.service_graph_templates.name_suffix %}

{% if dsp.expected_state.maximum_critical_faults is defined or dsp.expected_state.maximum_major_faults is defined or dsp.expected_state.maximum_minor_faults is defined %}
Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ldevCtx-dsp-{{ contract_name }}-sgt-{{ sgt_name }}-n-N1/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
{% if dsp.expected_state.maximum_critical_faults is defined %}
    Run Keyword If   ${critical}[0] > {{ dsp.expected_state.maximum_critical_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ contract_name }}-{{ sgt_name }} has ${critical}[0] critical faults"
{% endif %}
{% if dsp.expected_state.maximum_major_faults is defined %}
    Run Keyword If   ${major}[0] > {{ dsp.expected_state.maximum_major_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ contract_name }}-{{ sgt_name }} has ${major}[0] major faults"
{% endif %}
{% if dsp.expected_state.maximum_minor_faults is defined %}
    Run Keyword If   ${minor}[0] > {{ dsp.expected_state.maximum_minor_faults }}   Run Keyword And Continue On Failure
    ...   Fail  "{{ contract_name }}-{{ sgt_name }} has ${minor}[0] minor faults"
{% endif %}
{% endif %}

{% if 'pre-check' in robot_include_tags | default() %}
Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }} Faults Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}ldevCtx-dsp-{{ contract_name }}-sgt-{{ sgt_name }}-n-N1/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{json}=    Create Dictionary   critical=${critical}[0]   major=${major}[0]   minor=${minor}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}tenant_{{ tenant.name }}_device_selection_policy_{{ contract_name }}_{{ sgt_name }}_faults.json', 'w'))   modules=json
{% endif %}

{% if 'post-check' in robot_include_tags | default() %}
Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }} Faults Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ldevCtx-dsp-{{ contract_name }}-sgt-{{ sgt_name }}-n-N1/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    &{previous}=   evaluate   json.load(open('${STATE_PATH}tenant_{{ tenant.name }}_device_selection_policy_{{ contract_name }}_{{ sgt_name }}_faults.json'))   modules=json
    Run Keyword If   ${critical}[0] > ${previous["critical"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of critical faults increased from ${previous["critical"]} to ${critical}[0]"
    Run Keyword If   ${major}[0] > ${previous["major"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of major faults increased from ${previous["major"]} to ${major}[0]"
    Run Keyword If   ${minor}[0] > ${previous["minor"]}   Run Keyword And Continue On Failure
    ...   Fail  "Number of minor faults increased from ${previous["minor"]} to ${minor}[0]"
{% endif %}

{% endfor %}
