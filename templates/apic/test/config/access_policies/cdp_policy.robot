*** Settings ***
Documentation   Verify CDP Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.cdp_policies | default([]) %}
{% set cdp_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix %}

Verify CDP Interface Policy {{ cdp_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/cdpIfP-{{ cdp_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..cdpIfPol.attributes.name   {{ cdp_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..cdpIfPol.attributes.adminSt   {{ policy.admin_state | cisco.aac.aac_bool("enabled") }}

{% endfor %}
