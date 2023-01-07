*** Settings ***
Documentation   Verify L2 Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.l2_policies | default([]) %}
{% set l2_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.l2_policies.name_suffix %}

Verify L2 Interface Policy {{ l2_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/l2IfP-{{ l2_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..l2IfPol.attributes.name   {{ l2_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..l2IfPol.attributes.vlanScope   {{ policy.vlan_scope | default(defaults.apic.access_policies.interface_policies.l2_policies.vlan_scope) }}
    Should Be Equal Value Json String   ${r.json()}    $..l2IfPol.attributes.qinq   {{ policy.qinq | default(defaults.apic.access_policies.interface_policies.l2_policies.qinq) }}
    Should Be Equal Value Json String   ${r.json()}    $..l2IfPol.attributes.vepa   {% if policy.reflective_relay | default(defaults.apic.access_policies.interface_policies.l2_policies.reflective_relay) == true %}enabled{% else %}disabled{% endif %}
    
{% endfor %}
