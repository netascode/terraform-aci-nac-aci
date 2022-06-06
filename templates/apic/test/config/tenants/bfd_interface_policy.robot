{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify BFD Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bfd in tenant.policies.bfd_interface_policies | default([]) %}
{% set bfd_name = bfd.name ~ defaults.apic.tenants.policies.bfd_interface_policies.name_suffix %}

Verify BFD Interface Policy {{ bfd_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/bfdIfPol-{{ bfd_name }}.json"
    String   $..bfdIfPol.attributes.name   {{ bfd_name }}
    String   $..bfdIfPol.attributes.descr   {{ bfd.description | default() }}
    String   $..bfdIfPol.attributes.ctrl   {{ 'opt-subif' if bfd.subinterface_optimization | default(defaults.apic.tenants.policies.bfd_interface_policies.subinterface_optimization) | cisco.aac.aac_bool("enabled") == "enabled" else ''}}
    String   $..bfdIfPol.attributes.detectMult   {{ bfd.detection_multiplier | default(defaults.apic.tenants.policies.bfd_interface_policies.detection_multiplier) }}
    String   $..bfdIfPol.attributes.echoAdminSt   {{ bfd.echo_admin_state | default(defaults.apic.tenants.policies.bfd_interface_policies.echo_admin_state) | cisco.aac.aac_bool("enabled") }}
    String   $..bfdIfPol.attributes.echoRxIntvl   {{ bfd.echo_rx_interval | default(defaults.apic.tenants.policies.bfd_interface_policies.echo_rx_interval) }}
    String   $..bfdIfPol.attributes.minRxIntvl   {{ bfd.min_rx_interval | default(defaults.apic.tenants.policies.bfd_interface_policies.min_rx_interval) }}
    String   $..bfdIfPol.attributes.minTxIntvl   {{ bfd.min_tx_interval | default(defaults.apic.tenants.policies.bfd_interface_policies.min_tx_interval) }}

{% endfor %}
