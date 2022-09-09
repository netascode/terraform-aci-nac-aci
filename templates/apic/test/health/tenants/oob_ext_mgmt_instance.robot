{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify External Management Instance Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ext in tenant.ext_mgmt_instances | default([]) %}
{% set ext_name = ext.name ~ defaults.apic.tenants.ext_mgmt_instances.name_suffix %}

Verify External Management Instance {{ ext_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-mgmt/extmgmt-default/instp-{{ ext_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ext_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ext_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ ext_name }} has ${minor}[0] minor faults"

{% endfor %}
