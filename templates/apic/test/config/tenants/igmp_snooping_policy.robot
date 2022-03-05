*** Settings ***
Documentation   Verify IGMP Snooping Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for igmp_snoop_pol in tenant.policies.igmp_snooping_policies | default([]) %}
{% set policy_name = igmp_snoop_pol.name ~ defaults.apic.tenants.policies.igmp_snooping_policies.name_suffix %}
{% set ctrl = [] %}
{% if igmp_snoop_pol.fast_leave | default(defaults.apic.tenants.policies.igmp_snooping_policies.fast_leave) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("fast-leave")] %}{% endif %}
{% if igmp_snoop_pol.querier | default(defaults.apic.tenants.policies.igmp_snooping_policies.querier) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("querier")] %}{% endif %}

Verify IGMP Snooping Policy {{ policy_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/snPol-{{ policy_name }}.json"
    String   $..igmpSnoopPol.attributes.name   {{ policy_name }}
    String   $..igmpSnoopPol.attributes.descr   {{ igmp_snoop_pol.description | default() }}
    String   $..igmpSnoopPol.attributes.adminSt   {{ igmp_snoop_pol.admin_state | default(defaults.apic.tenants.policies.igmp_snooping_policies.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   $..igmpSnoopPol.attributes.ctrl   {{ ctrl | join(',') }}
    String   $..igmpSnoopPol.attributes.lastMbrIntvl   {{ igmp_snoop_pol.last_member_query_interval | default(defaults.apic.tenants.policies.igmp_snooping_policies.last_member_query_interval) }}                   
    String   $..igmpSnoopPol.attributes.queryIntvl   {{ igmp_snoop_pol.query_interval | default(defaults.apic.tenants.policies.igmp_snooping_policies.query_interval) }}
    String   $..igmpSnoopPol.attributes.rspIntvl   {{ igmp_snoop_pol.query_response_interval | default(defaults.apic.tenants.policies.igmp_snooping_policies.query_response_interval) }}
    String   $..igmpSnoopPol.attributes.startQueryCnt   {{ igmp_snoop_pol.start_query_count | default(defaults.apic.tenants.policies.igmp_snooping_policies.start_query_count) }}
    String   $..igmpSnoopPol.attributes.startQueryIntvl   {{ igmp_snoop_pol.start_query_interval | default(defaults.apic.tenants.policies.igmp_snooping_policies.start_query_interval) }}

{% endfor %}
