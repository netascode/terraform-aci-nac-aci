{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify ND Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for nd_intf_pol in tenant.policies.nd_interface_policies | default([]) %}
{% set policy_name = nd_intf_pol.name ~ defaults.apic.tenants.policies.nd_interface_policies.name_suffix %}
{% if nd_intf_pol.controller_state is defined %}{% set state = nd_intf_pol.controller_state | join(',') %}{% endif %}

Verify ND Interface Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ndifpol-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.descr   {{ nd_intf_pol.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.ctrl   {{ state | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.hopLimit   {{ nd_intf_pol.hop_limit | default(defaults.apic.tenants.policies.nd_interface_policies.hop_limit) }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.nsIntvl   {{ nd_intf_pol.ns_tx_interval | default(defaults.apic.tenants.policies.nd_interface_policies.ns_tx_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.mtu   {{ nd_intf_pol.mtu | default(defaults.apic.tenants.policies.nd_interface_policies.mtu) }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.nsRetries   {{ nd_intf_pol.retransmit_retry_count | default(defaults.apic.tenants.policies.nd_interface_policies.retransmit_retry_count) }}
{% if nd_intf_pol.nud_retransmit_base is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.nudRetryBase   {{ nd_intf_pol.nud_retransmit_base }}
{% endif %}
{% if nd_intf_pol.nud_retransmit_interval is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.nudRetryInterval   {{ nd_intf_pol.nud_retransmit_interval }}
{% endif %}
{% if nd_intf_pol.nud_retransmit_count is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.nudRetryMaxAttempts   {{ nd_intf_pol.nud_retransmit_count }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.raIntvl   {{ nd_intf_pol.route_advertise_interval | default(defaults.apic.tenants.policies.nd_interface_policies.route_advertise_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.raLifetime   {{ nd_intf_pol.router_lifetime | default(defaults.apic.tenants.policies.nd_interface_policies.router_lifetime) }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.reachableTime   {{ nd_intf_pol.reachable_time | default(defaults.apic.tenants.policies.nd_interface_policies.reachable_time) }}
    Should Be Equal Value Json String   ${r.json()}   $..ndIfPol.attributes.retransTimer   {{ nd_intf_pol.retransmit_timer | default(defaults.apic.tenants.policies.nd_interface_policies.retransmit_timer) }}
{% endfor %}
