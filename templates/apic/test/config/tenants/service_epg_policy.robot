{# iterate_list apic.tenants name item[2] #}
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
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/svcCont/svcEPgPol-{{ pol_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcEPgPol.attributes.descr   {{ pol.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcEPgPol.attributes.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcEPgPol.attributes.prefGrMemb   {{ pol.preferred_group | default(defaults.apic.tenants.services.service_epg_policies.preferred_group) | cisco.aac.aac_bool("include") }}

{% endfor %}
