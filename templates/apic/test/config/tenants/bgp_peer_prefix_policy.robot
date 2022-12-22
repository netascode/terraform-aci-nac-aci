{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify BGP Peer Prefix Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bpp in tenant.policies.bgp_peer_prefix_policies | default([]) %}
{% set bgp_peer_prefix_name = bpp.name ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}

Verify BGP Peer Prefix Policy {{ bgp_peer_prefix_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/bgpPfxP-{{ bgp_peer_prefix_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.name   {{ bgp_peer_prefix_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.descr   {{ bpp.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.dn   uni/tn-{{ tenant.name }}/bgpPfxP-{{ bgp_peer_prefix_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.action   {{ bpp.action | default(defaults.apic.tenants.policies.bgp_peer_prefix_policies.action) }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.maxPfx   {{ bpp.max_prefixes | default(defaults.apic.tenants.policies.bgp_peer_prefix_policies.max_prefixes) }}
{% if bpp.action | default(defaults.apic.tenants.policies.bgp_peer_prefix_policies.action) == "restart" %}
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.restartTime   {{ bpp.restart_time | default(defaults.apic.tenants.policies.bgp_peer_prefix_policies.restart_time) }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   $..bgpPeerPfxPol.attributes.thresh   {{ bpp.threshold | default(defaults.apic.tenants.policies.bgp_peer_prefix_policies.threshold) }}

{% endfor %}
