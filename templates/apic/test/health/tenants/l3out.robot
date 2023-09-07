{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify L3out Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.l3outs.name_suffix %}

Verify L3out {{ l3out_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ l3out_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ l3out_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ l3out_name }} has ${minor}[0] minor faults"

{% endfor %}

{% for l3out in tenant.sr_mpls_l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.sr_mpls_l3outs.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ l3out_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ l3out_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ l3out_name }} has ${minor}[0] minor faults"

{% endfor %}
