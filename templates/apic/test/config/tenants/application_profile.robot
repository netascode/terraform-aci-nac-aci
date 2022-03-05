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
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}.json"
    String   $..fvAp.attributes.name   {{ ap_name }}
    String   $..fvAp.attributes.nameAlias   {{ ap.alias | default() }}
    String   $..fvAp.attributes.descr   {{ ap.description | default() }}

{% endfor %}
