*** Settings ***
Documentation   Verify Node Control Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.switch_policies.node_control_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.fabric_policies.switch_policies.node_control_policies.name_suffix %}

Verify Node Control {{ policy_name }} Policy
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/nodecontrol-{{ policy_name }}.json
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeControl.attributes.name   {{ policy_name }}

Verify Dom enablement for {{ policy_name }}
{% set dom = "" %}
{% if policy.dom | default(defaults.apic.fabric_policies.switch_policies.node_control_policies.dom) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set dom = "Dom" %}{% endif %}     
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeControl.attributes.control   {{ dom }}

Verify Feature Selection for {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeControl.attributes.featureSel   {{ policy.telemetry | default(defaults.apic.fabric_policies.switch_policies.node_control_policies.telemetry) }}

{% endfor %}

