{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Route Tag Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for route_tag in tenant.policies.route_tag_policies | default([]) %}
{% set route_tag_name = route_tag.name ~ defaults.apic.tenants.policies.route_tag_policies.name_suffix %}

Verify Route Tag Policy {{ route_tag_name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/rttag-{{ route_tag_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..l3extRouteTagPol.attributes.name   {{ route_tag_name }}
    Should Be Equal Value Json String   ${r.json()}   $..l3extRouteTagPol.attributes.descr   {{ route_map.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..l3extRouteTagPol.attributes.tag   {{ route_tag.tag | default(defaults.apic.tenants.policies.route_tag_policies.tag) }}

{% endfor %}
