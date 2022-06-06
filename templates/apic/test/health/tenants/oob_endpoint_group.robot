{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify OOB Endpoint Group Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for epg in tenant.oob_endpoint_groups | default([]) %}
{% if epg.name is not defined %}
{% set epg_name = defaults.apic.tenants.oob_endpoint_groups.name %}
{% else %}
{% set epg_name = epg.name ~ defaults.apic.tenants.oob_endpoint_groups.name_suffix %}
{% endif %}

Verify OOB Endpoint Group {{ epg_name }} Faults
    GET   "/api/mo/uni/tn-mgmt/mgmtp-default/oob-{{ epg_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ epg_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ epg_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ epg_name }} has ${minor} minor faults"

{% endfor %}
