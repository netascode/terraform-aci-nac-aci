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

Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${minor}[0] minor faults"

Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health
     ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} health score: ${health}[0]"

{% endfor %}

{% endfor %}

{% for l3out in tenant.sr_mpls_l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.sr_mpls_l3outs.name_suffix %}
{% for epg in l3out.external_endpoint_groups | default([]) %}
{% set eepg_name = epg.name ~ defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} has ${minor}[0] minor faults"

Verify L3out {{ l3out_name }} External Endpoint Group {{ eepg_name }} Health
     ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/instP-{{ eepg_name }}/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..healthInst.attributes.cur
    Run Keyword If   ${health}[0] < 100   Run Keyword And Continue On Failure
    ...   Fail  "{{ eepg_name }} health score: ${health}[0]"

{% endfor %}

{% endfor %}
