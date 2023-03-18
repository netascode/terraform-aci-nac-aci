*** Settings ***
Documentation   L2 MTU
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify L2 MTU
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/l2pol-default.json
    Should Be Equal Value Json String   ${r.json()}    $..l2InstPol.attributes.fabricMtu   {{ apic.fabric_policies.l2_port_mtu | default(defaults.apic.fabric_policies.l2_port_mtu) }}

{% for policy in apic.fabric_policies.l2_mtu_policies | default([]) %}
{% if policy.name != 'default' %}
{% set mtu_policy_name = policy.name ~ defaults.apic.fabric_policies.l2_mtu_policies.name_suffix %}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/l2pol-{{ mtu_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..l2InstPol.attributes.fabricMtu   {{ policy.port_mtu_size | default(defaults.apic.fabric_policies.l2_mtu_policies.port_mtu_size) }}
{% endif %}
{% endfor %}