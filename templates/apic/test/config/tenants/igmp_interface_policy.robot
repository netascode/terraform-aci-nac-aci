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
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for igmp_pol in tenant.policies.igmp_interface_policies | default([]) %}
{% set igmp_pol_name = igmp_pol.name ~ defaults.apic.tenants.policies.igmp_interface_policies.name_suffix %}
{% set ctrl = [] %}
{% if igmp_pol.allow_v3_asm | default(defaults.apic.tenants.policies.igmp_interface_policies.allow_v3_asm) == "yes" %}{% set ctrl = ctrl + [("allow-v3-asm")] %}{% endif %}
{% if igmp_pol.fast_leave | default(defaults.apic.tenants.policies.igmp_interface_policies.fast_leave) == "yes" %}{% set ctrl = ctrl + [("fast-leave")] %}{% endif %}
{% if igmp_pol.report_link_local_groups | default(defaults.apic.tenants.policies.igmp_interface_policies.report_link_local_groups) == "yes" %}{% set ctrl = ctrl + [("rep-ll")] %}{% endif %}

Verify IGMP Interface Policy {{ igmp_pol_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_pol_name }}.json?rsp-subtree=full"
    String   $..igmpIfPol.attributes.name   {{ igmp_pol_name }}
    String   $..igmpIfPol.attributes.descr   {{ igmp_pol.description | default()}}
    String   $..igmpIfPol.attributes.grpTimeout   {{ igmp_pol.grp_timeout | default(defaults.apic.tenants.policies.igmp_interface_policies.grp_timeout) }}
    String   $..igmpIfPol.attributes.ifCtrl   {{ ctrl | join(',') }}
    String   $..igmpIfPol.attributes.lastMbrCnt   {{ igmp_pol.last_member_count | default(defaults.apic.tenants.policies.igmp_interface_policies.last_member_count) }}
    String   $..igmpIfPol.attributes.lastMbrRespTime   {{ igmp_pol.last_member_response_time | default(defaults.apic.tenants.policies.igmp_interface_policies.last_member_response_time) }}
    String   $..igmpIfPol.attributes.querierTimeout   {{ igmp_pol.querier_timeout | default(defaults.apic.tenants.policies.igmp_interface_policies.querier_timeout) }}
    String   $..igmpIfPol.attributes.queryIntvl   "{{ igmp_pol.query_interval | default(defaults.apic.tenants.policies.igmp_interface_policies.query_interval) }}
    String   $..igmpIfPol.attributes.robustFac   {{ igmp_pol.robustness_variable | default(defaults.apic.tenants.policies.igmp_interface_policies.robustness_variable) }}
    String   $..igmpIfPol.attributes.rspIntvl   {{ igmp_pol.query_response_interval | default(defaults.apic.tenants.policies.igmp_interface_policies.query_response_interval) }}
    String   $..igmpIfPol.attributes.startQueryCnt   {{ igmp_pol.startup_query_count | default(defaults.apic.tenants.policies.igmp_interface_policies.startup_query_count) }}
    String   $..igmpIfPol.attributes.startQueryIntvl   {{ igmp_pol.startup_query_interval | default(defaults.apic.tenants.policies.igmp_interface_policies.startup_query_interval) }}
    String   $..igmpIfPol.attributes.ver   {{ igmp_pol.version | default(defaults.apic.tenants.policies.igmp_interface_policies.version) }}
    String   $..igmpIfPol.children..igmpStateLPol.attributes.max   {{ max_entry(igmp_pol.max_mcast_entries | default(defaults.apic.tenants.policies.igmp_interface_policies.max_mcast_entries)) }}
    String   $..igmpIfPol.children..igmpStateLPol.attributes.rsvd   {{ reserved_entry(igmp_pol.reserved_mcast_entries | default(defaults.apic.tenants.policies.igmp_interface_policies.reserved_mcast_entries)) }}
{% if igmp_pol.state_limit_multicast_route_map is defined %}
{% set state_limit_rm_name = igmp_pol.state_limit_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   $..igmpIfPol.children..igmpStateLPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ state_limit_rm_name }}
{% endif %}
{% if igmp_pol.report_policy_multicast_route_map is defined %}
{% set report_policy_rm_name = igmp_pol.report_policy_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   $..igmpIfPol.children..igmpStRepPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ report_policy_rm_name }}
{% endif %}
{% if igmp_pol.static_report_multicast_route_map is defined %}
{% set static_report_rm_name = igmp_pol.static_report_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   $..igmpIfPol.children..igmpRepPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ static_report_rm_name }}
{% endif %}

{% endfor %}
