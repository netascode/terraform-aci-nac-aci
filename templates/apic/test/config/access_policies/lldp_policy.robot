*** Settings ***
Documentation   Verify LLDP Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.lldp_policies | default([]) %}
{% set lldp_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix %}

Verify LLDP Interface Policy {{ lldp_policy_name }}
    GET   "/api/mo/uni/infra/lldpIfP-{{ lldp_policy_name }}.json"
    String   $..lldpIfPol.attributes.name   {{ lldp_policy_name }}
    String   $..lldpIfPol.attributes.adminRxSt   {{ policy.admin_rx_state }}
    String   $..lldpIfPol.attributes.adminTxSt   {{ policy.admin_tx_state }}

{% endfor %}
