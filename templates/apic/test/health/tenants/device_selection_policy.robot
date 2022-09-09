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

Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ldevCtx-c-{{ contract_name }}-g-{{ sgt_name }}-n-N1/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ contract_name }}-{{ sgt_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ contract_name }}-{{ sgt_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ contract_name }}-{{ sgt_name }} has ${minor}[0] minor faults"

{% endfor %}
