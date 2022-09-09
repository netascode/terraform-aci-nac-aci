*** Settings ***
Documentation   Verify PSU Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.switch_policies.psu_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.fabric_policies.switch_policies.psu_policies.name_suffix %}
{% set admin_state = [] %}
{% if policy.admin_state == "combined" %}{% set admin_state = "comb" %}{% endif %}
{% if policy.admin_state == "nnred" %}{% set admin_state = "rdn" %}{% endif %}
{% if policy.admin_state == "n1red" %}{% set admin_state = "ps-rdn" %}{% endif %}

Verify PSU Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/psuInstP-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..psuInstPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..psuInstPol.attributes.adminRdnM   {{ admin_state }}

{% endfor %}

