*** Settings ***
Documentation   Verify Link Level Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.link_level_policies | default([]) %}
{% set link_level_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.link_level_policies.name_suffix %}

Verify Link Level Interface Policy {{ link_level_policy_name }}
    GET   "/api/mo/uni/infra/hintfpol-{{ link_level_policy_name }}.json"
    String   $..fabricHIfPol.attributes.name   {{ link_level_policy_name }}
    String   $..fabricHIfPol.attributes.speed   {{ policy.speed | default(defaults.apic.access_policies.interface_policies.link_level_policies.speed) }}
    String   $..fabricHIfPol.attributes.autoNeg   {{ policy.auto | default(defaults.apic.access_policies.interface_policies.link_level_policies.auto) }}
    String   $..fabricHIfPol.attributes.fecMode   {{ policy.fec_mode | default(defaults.apic.access_policies.interface_policies.link_level_policies.fec_mode) }}

{% endfor %}
