*** Settings ***
Documentation   Verify BGP Address Family Context Policies
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bafc in tenant.policies.bgp_address_family_context_policies | default([]) %}
{% set bafc_name = bafc.name ~ defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix %}
{% set enable_host_route_leak = "" %}
{% if bafc.enable_host_route_leak | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.enable_host_route_leak) | cisco.aac.aac_bool("yes") == "yes" %}{% set enable_host_route_leak = "host-rt-leak" %}{% endif %}

Verify BGP Address Family Context Policy {{ bafc_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/bgpCtxAfP-{{ bafc_name }}.json"
    String   $..bgpCtxAfPol.attributes.name   {{ bafc_name }}
    String   $..bgpCtxAfPol.attributes.descr   {{ bafc.description | default() }}
    String   $..bgpCtxAfPol.attributes.ctrl   {{ enable_host_route_leak }}
    String   $..bgpCtxAfPol.attributes.eDist   {{ bafc.ebgp_distance | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ebgp_distance) }}
    String   $..bgpCtxAfPol.attributes.iDist   {{ bafc.ibgp_distance | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ibgp_distance) }}
    String   $..bgpCtxAfPol.attributes.localDist   {{ bafc.local_distance | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.local_distance) }}
    String   $..bgpCtxAfPol.attributes.maxEcmp   {{ bafc.ebgp_max_ecmp | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ebgp_max_ecmp) }}
    String   $..bgpCtxAfPol.attributes.maxEcmpIbgp   {{ bafc.ibgp_max_ecmp | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ibgp_max_ecmp) }}
{% if bafc.local_max_ecmp is defined %}
    String   $..bgpCtxAfPol.attributes.maxLocalEcmp   {{ bafc.local_max_ecmp }}
{% endif %}

{% endfor %}
