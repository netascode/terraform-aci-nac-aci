{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify PIM Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for pim_pol in tenant.policies.pim_policies | default([]) %}
{% set pim_policy_name = pim_pol.name ~ defaults.apic.tenants.policies.pim_policies.name_suffix %}
{% set ctrl = [] %}     
{% if pim_pol.mcast_dom_boundary | default(defaults.apic.tenants.policies.pim_policies.mcast_dom_boundary) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("border")] %}{% endif %}
{% if pim_pol.passive | default(defaults.apic.tenants.policies.pim_policies.passive) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("passive")] %}{% endif %}
{% if pim_pol.strict_rfc | default(defaults.apic.tenants.policies.pim_policies.strict_rfc) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("strict-rfc-compliant")] %}{% endif %}

Verify PIM Policy {{ pim_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/pimifpol-{{ pim_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.name   {{ pim_policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.authT   {{ pim_pol.auth_type | default(defaults.apic.tenants.policies.pim_policies.auth_type) }}
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.drDelay   {{ pim_pol.designated_router_delay | default(defaults.apic.tenants.policies.pim_policies.designated_router_delay) }}
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.drPrio   {{ pim_pol.designated_router_priority | default(defaults.apic.tenants.policies.pim_policies.designated_router_priority) }}
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.helloItvl   {{ pim_pol.hello_interval | default(defaults.apic.tenants.policies.pim_policies.hello_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..pimIfPol.attributes.jpInterval    {{ pim_pol.join_prune_interval |  default(defaults.apic.tenants.policies.pim_policies.join_prune_interval) }}

{% if pim_pol.neighbor_filter_policy is defined %}
{% set neighbor_filter_policy_name = pim_pol.neighbor_filter_policy ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
                        
Verify PIM Policy {{ pim_policy_name }} Interface-Level Neighbor Filter Policy
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/pimifpol-{{ pim_policy_name }}/nbrfilter/rsfilterToRtMapPol.json
    Should Be Equal Value Json String   ${r.json()}   $..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ neighbor_filter_policy_name }}
    
{% endif %}
{% if pim_pol.join_prune_filter_policy_out is defined %}
{% set join_prune_filter_policy_out_name = pim_pol.join_prune_filter_policy_out ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
                                                
Verify PIM Policy {{ pim_policy_name }} Interface-Level Outbound Join-Prune Filter Policy
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/pimifpol-{{ pim_policy_name }}/jpoutbfilter/rsfilterToRtMapPol.json
    Should Be Equal Value Json String   ${r.json()}   $..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ join_prune_filter_policy_out_name }}
    
{% endif %}

{% if pim_pol.join_prune_filter_policy_in is defined %}
{% set join_prune_filter_policy_in_name = pim_pol.join_prune_filter_policy_in ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
                                                                        
Verify PIM Policy {{ pim_policy_name }} Interface-Level Inbound Join-Prune Filter Policy
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/pimifpol-{{ pim_policy_name }}/jpinbfilter/rsfilterToRtMapPol.json
    Should Be Equal Value Json String   ${r.json()}   $..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ join_prune_filter_policy_in_name }}
    
{% endif %}

{% endfor %}
