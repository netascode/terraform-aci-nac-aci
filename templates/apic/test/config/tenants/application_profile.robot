{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Application Profile
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ap in tenant.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.apic.tenants.application_profiles.name_suffix %}

Verify Application Profile {{ ap_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..fvAp.attributes.name   {{ ap_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAp.attributes.nameAlias   {{ ap.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAp.attributes.descr   {{ ap.description | default() }}

{% endfor %}
