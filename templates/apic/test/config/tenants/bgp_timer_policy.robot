{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify BGP Timer Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bt in tenant.policies.bgp_timer_policies | default([]) %}
{% set bgp_timer_name = bt.name ~ defaults.apic.tenants.policies.bgp_timer_policies.name_suffix %}

Verify BGP Timer Policy {{ bgp_timer_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/bgpCtxP-{{ bgp_timer_name }}.json"
    String   $..bgpCtxPol.attributes.name   {{ bgp_timer_name }}
    String   $..bgpCtxPol.attributes.descr   {{ bt.description | default() }}
    String   $..bgpCtxPol.attributes.grCtrl   {% if bt.graceful_restart_helper | default(defaults.apic.tenants.policies.bgp_timer_policies.graceful_restart_helper) | cisco.aac.aac_bool("enabled") == "enabled" %}helper{% elif bt.graceful_restart_helper | default(defaults.apic.tenants.policies.bgp_timer_policies.graceful_restart_helper) | cisco.aac.aac_bool("enabled") == "disabled" %}""{% endif %} 
    String   $..bgpCtxPol.attributes.holdIntvl   {{ bt.hold_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.hold_interval) }}
    String   $..bgpCtxPol.attributes.kaIntvl   {{ bt.keepalive_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.keepalive_interval) }}
    String   $..bgpCtxPol.attributes.maxAsLimit   {{ bt.maximum_as_limit | default(defaults.apic.tenants.policies.bgp_timer_policies.maximum_as_limit) }}
    String   $..bgpCtxPol.attributes.staleIntvl  {% if bt.stale_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.stale_interval) == 300 %}default{% else %}{{ bt.stale_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.stale_interval) }}{% endif %} 

{% endfor %}
