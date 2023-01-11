{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Multicast Route Map Policies Option Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for policy in tenant.policies.multicast_route_maps | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}

Verify Multicast Route Map Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/rtmap-{{ policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..pimRouteMapPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..pimRouteMapPol.attributes.descr   {{ mrm.description | default("") }}

{% for route_map_entry in policy.entries | default([]) %}

Verify Multicast Route Map Policy {{ policy_name }} entry {{ route_map_entry.order }}
    ${entry}=   Set Variable   $..pimRouteMapPol.children[?(@.pimRouteMapEntry.attributes.order=='{{ route_map_entry.order }}')]
    Should Be Equal Value Json String   ${r.json()}    ${entry}..attributes.order    {{ route_map_entry.order }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}..attributes.src    {{ route_map_entry.source_ip  | default(defaults.apic.tenants.policies.multicast_route_maps.entries.source_ip) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}..attributes.grp    {{ route_map_entry.group_ip | default(defaults.apic.tenants.policies.multicast_route_maps.entries.group_ip) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}..attributes.rp    {{ route_map_entry.rp_ip | default(defaults.apic.tenants.policies.multicast_route_maps.entries.rp_ip) }}
    Should Be Equal Value Json String   ${r.json()}    ${entry}..attributes.action    {{ route_map_entry.action | default(defaults.apic.tenants.policies.multicast_route_maps.entries.action) }}
{% endfor %}

{% endfor %}
