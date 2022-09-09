{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Redirect Health Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for health_grp in tenant.services.redirect_health_groups | default([]) %}
{% set health_group_name = health_grp.name ~ defaults.apic.tenants.services.redirect_health_groups.name_suffix %}

Verify Redirect Health Group {{ health_group_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/svcCont/redirectHealthGroup-{{ health_group_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..vnsRedirectHealthGroup.attributes.descr   {{ health_grp.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsRedirectHealthGroup.attributes.name   {{ health_group_name }}
{% endfor %}
