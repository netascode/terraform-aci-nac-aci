*** Settings ***
Documentation   Verify Multicast Route Map Policies Option Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for policy in tenant.policies.multicast_route_maps | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}

Verify Multicast Route Map Policy {{ policy_name }}
    GET   "/api/node/mo/uni/tn-{{ tenant.name }}/rtmap-{{ policy_name }}.json?rsp-subtree=full"
    String   $..pimRouteMapPol.attributes.name   {{ policy_name }}

{% for route_map_entry in policy.multicast_route_map_entries | default([]) %}

Verify Multicast Route Map Policy {{ policy_name }} entry {{ route_map_entry.order }}
    ${entry}=   Set Variable   $..pimRouteMapPol.children[?(@.pimRouteMapEntry.attributes.order=='{{ route_map_entry.order }}')]
    String    ${entry}..attributes.order    {{ route_map_entry.order }}
    String    ${entry}..attributes.src    {{ route_map_entry.source_ip  | default(defaults.apic.tenants.policies.multicast_route_maps.multicast_route_map_entries.source_ip) }}
    String    ${entry}..attributes.grp    {{ route_map_entry.group_ip | default(defaults.apic.tenants.policies.multicast_route_maps.multicast_route_map_entries.group_ip) }}
    String    ${entry}..attributes.rp    {{ route_map_entry.rp_ip | default(defaults.apic.tenants.policies.multicast_route_maps.multicast_route_map_entries.rp_ip) }}
    String    ${entry}..attributes.action    {{ route_map_entry.action | default(defaults.apic.tenants.policies.multicast_route_maps.multicast_route_map_entries.action) }}
{% endfor %}

{% endfor %}
