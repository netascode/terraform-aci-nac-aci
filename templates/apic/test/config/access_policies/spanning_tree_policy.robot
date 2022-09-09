*** Settings ***
Documentation   Verify Spanning Tree Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.spanning_tree_policies | default([]) %}
{% set spanning_tree_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.spanning_tree_policies.name_suffix %}
{% set ctrl = [] %}
{% if policy.bpdu_filter | default(defaults.apic.access_policies.interface_policies.spanning_tree_policies.bpdu_filter) | cisco.aac.aac_bool("yes")  == "yes" %}{% set ctrl = ctrl + [("bpdu-filter")] %}{% endif %}
{% if policy.bpdu_guard | default(defaults.apic.access_policies.interface_policies.spanning_tree_policies.bpdu_guard) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("bpdu-guard")] %}{% endif %}

Verify Spanning Tree Interface Policy {{spanning_tree_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/ifPol-{{spanning_tree_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..stpIfPol.attributes.name   {{ spanning_tree_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..stpIfPol.attributes.ctrl   {{ ctrl | join(',') }}

{% endfor %}
