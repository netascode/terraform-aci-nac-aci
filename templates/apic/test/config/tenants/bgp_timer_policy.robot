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
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/bgpCtxP-{{ bgp_timer_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.name   {{ bgp_timer_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.descr   {{ bt.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.grCtrl   {% if bt.graceful_restart_helper | default(defaults.apic.tenants.policies.bgp_timer_policies.graceful_restart_helper) | cisco.aac.aac_bool("enabled") == "enabled" %}helper{% elif bt.graceful_restart_helper | default(defaults.apic.tenants.policies.bgp_timer_policies.graceful_restart_helper) | cisco.aac.aac_bool("enabled") == "disabled" %}{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.holdIntvl   {{ bt.hold_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.hold_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.kaIntvl   {{ bt.keepalive_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.keepalive_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.maxAsLimit   {{ bt.maximum_as_limit | default(defaults.apic.tenants.policies.bgp_timer_policies.maximum_as_limit) }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpCtxPol.attributes.staleIntvl  {% if bt.stale_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.stale_interval) == 300 %}default{% else %}{{ bt.stale_interval | default(defaults.apic.tenants.policies.bgp_timer_policies.stale_interval) }}{% endif %} 

{% endfor %}
