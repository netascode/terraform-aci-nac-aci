{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify OSPF Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for oip in tenant.policies.ospf_interface_policies | default([]) %}
{% set policy_name = oip.name ~ defaults.apic.tenants.policies.ospf_interface_policies.name_suffix %}
{% set ctrl = [] %}
{% if oip.advertise_subnet | default(defaults.apic.tenants.policies.ospf_interface_policies.advertise_subnet) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("advert-subnet")] %}{% endif %}
{% if oip.bfd | default(defaults.apic.tenants.policies.ospf_interface_policies.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("bfd")] %}{% endif %}
{% if oip.mtu_ignore | default(defaults.apic.tenants.policies.ospf_interface_policies.mtu_ignore) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("mtu-ignore")] %}{% endif %}
{% if oip.passive_interface | default(defaults.apic.tenants.policies.ospf_interface_policies.passive_interface) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("passive")] %}{% endif %}

Verify OSPF Interface Policy {{ policy_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ospfIfPol-{{ policy_name }}.json"
    String   $..ospfIfPol.attributes.name   {{ policy_name }}
    String   $..ospfIfPol.attributes.descr   {{ oip.description | default() }}
    String   $..ospfIfPol.attributes.cost   {{ oip.cost | default(defaults.apic.tenants.policies.ospf_interface_policies.cost) }}
    String   $..ospfIfPol.attributes.ctrl   {{ ctrl | join(',') }}
    String   $..ospfIfPol.attributes.deadIntvl   {{ oip.dead_interval | default(defaults.apic.tenants.policies.ospf_interface_policies.dead_interval) }}
    String   $..ospfIfPol.attributes.helloIntvl   {{ oip.hello_interval | default(defaults.apic.tenants.policies.ospf_interface_policies.hello_interval) }}
    String   $..ospfIfPol.attributes.nwT   {{ oip.network_type | default(defaults.apic.tenants.policies.ospf_interface_policies.network_type) }}
    String   $..ospfIfPol.attributes.prio   {{ oip.priority | default(defaults.apic.tenants.policies.ospf_interface_policies.priority) }}
    String   $..ospfIfPol.attributes.rexmitIntvl   {{ oip.lsa_retransmit_interval | default(defaults.apic.tenants.policies.ospf_interface_policies.lsa_retransmit_interval) }}
    String   $..ospfIfPol.attributes.xmitDelay   {{ oip.lsa_transmit_delay | default(defaults.apic.tenants.policies.ospf_interface_policies.lsa_transmit_delay) }}

{% endfor %}
