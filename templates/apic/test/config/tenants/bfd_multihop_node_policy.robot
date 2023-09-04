{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify BFD Multihop Node Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bfd in tenant.policies.bfd_multihop_node_policies | default([]) %}
{% set bfd_name = bfd.name ~ defaults.apic.tenants.policies.bfd_multihop_node_policies.name_suffix %}

Verify BFD Multihop Node Policy {{ bfd_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/bfdMhNodePol-{{ bfd_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bfdMhNodePol.attributes.name   {{ bfd_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdMhNodePol.attributes.descr   {{ bfd.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdMhNodePol.attributes.detectMult   {{ bfd.detection_multiplier | default(defaults.apic.tenants.policies.bfd_multihop_node_policies.detection_multiplier) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdMhNodePol.attributes.minRxIntvl   {{ bfd.min_rx_interval | default(defaults.apic.tenants.policies.bfd_multihop_node_policies.min_rx_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdMhNodePol.attributes.minTxIntvl   {{ bfd.min_tx_interval | default(defaults.apic.tenants.policies.bfd_multihop_node_policies.min_tx_interval) }}

{% endfor %}
