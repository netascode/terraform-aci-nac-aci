*** Settings ***
Documentation   Verify Fabric Link Level Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.interface_policies.link_level_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.fabric_policies.interface_policies.link_level_policies.name_suffix %}

Verify Fabric Link Level Interface Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/fintfpol-{{ policy_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..fabricFIfPol.attributes.name           {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricFIfPol.attributes.descr          {{ policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricFIfPol.attributes.linkDebounce   {{ policy.link_debounce_interval | default(defaults.apic.fabric_policies.interface_policies.link_level_policies.link_debounce_interval) }}
{% endfor %}
