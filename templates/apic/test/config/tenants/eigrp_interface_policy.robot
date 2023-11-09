{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify EIGRP Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for eip in tenant.policies.eigrp_interface_policies | default([]) %}
{% set policy_name = eip.name ~ defaults.apic.tenants.policies.eigrp_interface_policies.name_suffix %}
{% set ctrl = [] %}
{% if eip.split_horizon | default(defaults.apic.tenants.policies.eigrp_interface_policies.split_horizon) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("split-horizon")] %}{% endif %}
{% if eip.bfd | default(defaults.apic.tenants.policies.eigrp_interface_policies.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("bfd")] %}{% endif %}
{% if eip.self_nexthop | default(defaults.apic.tenants.policies.eigrp_interface_policies.self_nexthop) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("nh-self")] %}{% endif %}
{% if eip.passive_interface | default(defaults.apic.tenants.policies.eigrp_interface_policies.passive_interface) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("passive")] %}{% endif %}

Verify EIGRP Interface Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/eigrpIfPol-{{ policy_name }}.json
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.descr   {{ eip.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.holdIntvl   {{ eip.hold_interval | default(defaults.apic.tenants.policies.eigrp_interface_policies.hold_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.helloIntvl   {{ eip.hello_interval | default(defaults.apic.tenants.policies.eigrp_interface_policies.hello_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.bw   {{ eip.bandwidth | default(defaults.apic.tenants.policies.eigrp_interface_policies.bandwidth) }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.delay   {{ eip.delay | default(defaults.apic.tenants.policies.eigrp_interface_policies.delay) }}
    Should Be Equal Value Json String   ${r.json()}   $..eigrpIfPol.attributes.delayUnit   {{ eip.delay_unit | default(defaults.apic.tenants.policies.eigrp_interface_policies.delay_unit) }}
{% endfor %}

