*** Settings ***
Documentation   Verify Service EPG Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for pol in tenant.services.service_epg_policies | default([]) %}
{% set pol_name = pol.name ~ defaults.apic.tenants.services.service_epg_policies.name_suffix %}

Verify Service EPG Policy {{ pol_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/svcCont/svcEPgPol-{{ pol_name }}.json?rsp-subtree=full"
    String   $..vnsSvcEPgPol.attributes.descr   {{ pol.description | default() }}
    String   $..vnsSvcEPgPol.attributes.name   {{ pol_name }}
    String   $..vnsSvcEPgPol.attributes.prefGrMemb   {{ pol.preferred_group | default() }}

{% endfor %}
