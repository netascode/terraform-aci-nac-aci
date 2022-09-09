{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify IGMP Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% macro reserved_entry(value) %}
    {% set reserved_map = {0: "undefined"} %}
    {{ reserved_map[value] | default(value) }}
{% endmacro %}
{% macro max_entry(value) %}
    {% set max_map = {4294967295: "unlimited"} %}
    {{ max_map[value] | default(value) }}
{% endmacro %}
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for igmp_pol in tenant.policies.igmp_interface_policies | default([]) %}
{% set igmp_pol_name = igmp_pol.name ~ defaults.apic.tenants.policies.igmp_interface_policies.name_suffix %}
{% set ctrl = [] %}
{% if igmp_pol.allow_v3_asm | default(defaults.apic.tenants.policies.igmp_interface_policies.allow_v3_asm) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-v3-asm")] %}{% endif %}
{% if igmp_pol.fast_leave | default(defaults.apic.tenants.policies.igmp_interface_policies.fast_leave) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("fast-leave")] %}{% endif %}
{% if igmp_pol.report_link_local_groups | default(defaults.apic.tenants.policies.igmp_interface_policies.report_link_local_groups) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("rep-ll")] %}{% endif %}

Verify IGMP Interface Policy {{ igmp_pol_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.name   {{ igmp_pol_name }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.descr   {{ igmp_pol.description | default()}}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.grpTimeout   {{ igmp_pol.grp_timeout | default(defaults.apic.tenants.policies.igmp_interface_policies.grp_timeout) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.ifCtrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.lastMbrCnt   {{ igmp_pol.last_member_count | default(defaults.apic.tenants.policies.igmp_interface_policies.last_member_count) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.lastMbrRespTime   {{ igmp_pol.last_member_response_time | default(defaults.apic.tenants.policies.igmp_interface_policies.last_member_response_time) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.querierTimeout   {{ igmp_pol.querier_timeout | default(defaults.apic.tenants.policies.igmp_interface_policies.querier_timeout) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.queryIntvl   {{ igmp_pol.query_interval | default(defaults.apic.tenants.policies.igmp_interface_policies.query_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.robustFac   {{ igmp_pol.robustness_variable | default(defaults.apic.tenants.policies.igmp_interface_policies.robustness_variable) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.rspIntvl   {{ igmp_pol.query_response_interval | default(defaults.apic.tenants.policies.igmp_interface_policies.query_response_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.startQueryCnt   {{ igmp_pol.startup_query_count | default(defaults.apic.tenants.policies.igmp_interface_policies.startup_query_count) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.startQueryIntvl   {{ igmp_pol.startup_query_interval | default(defaults.apic.tenants.policies.igmp_interface_policies.startup_query_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.attributes.ver   {{ igmp_pol.version | default(defaults.apic.tenants.policies.igmp_interface_policies.version) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.children..igmpStateLPol.attributes.max   {{ max_entry(igmp_pol.max_mcast_entries | default(defaults.apic.tenants.policies.igmp_interface_policies.max_mcast_entries)) }}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.children..igmpStateLPol.attributes.rsvd   {{ reserved_entry(igmp_pol.reserved_mcast_entries | default(defaults.apic.tenants.policies.igmp_interface_policies.reserved_mcast_entries)) }}
{% if igmp_pol.state_limit_multicast_route_map is defined %}
{% set state_limit_rm_name = igmp_pol.state_limit_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.children..igmpStateLPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ state_limit_rm_name }}
{% endif %}
{% if igmp_pol.report_policy_multicast_route_map is defined %}
{% set report_policy_rm_name = igmp_pol.report_policy_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.children..igmpStRepPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ report_policy_rm_name }}
{% endif %}
{% if igmp_pol.static_report_multicast_route_map is defined %}
{% set static_report_rm_name = igmp_pol.static_report_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..igmpIfPol.children..igmpRepPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ static_report_rm_name }}
{% endif %}

{% endfor %}
