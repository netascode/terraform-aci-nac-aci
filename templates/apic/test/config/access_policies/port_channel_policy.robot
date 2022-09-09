*** Settings ***
Documentation   Verify Port Channel Interface Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.port_channel_policies | default([]) %}
{% set port_channel_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix %}
{% set ctrl = [] %}
{% if policy.fast_select_standby | default(defaults.apic.access_policies.interface_policies.port_channel_policies.fast_select_standby) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("fast-sel-hot-stdby")] %}{% endif %}
{% if policy.graceful_convergence | default(defaults.apic.access_policies.interface_policies.port_channel_policies.graceful_convergence) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("graceful-conv")] %}{% endif %}
{% if policy.load_defer | default(defaults.apic.access_policies.interface_policies.port_channel_policies.load_defer) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("load-defer")] %}{% endif %}
{% if policy.suspend_individual | default(defaults.apic.access_policies.interface_policies.port_channel_policies.suspend_individual) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("susp-individual")] %}{% endif %}
{% if policy.symmetric_hash | default(defaults.apic.access_policies.interface_policies.port_channel_policies.symmetric_hash) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("symmetric-hash")] %}{% endif %}

Verify Port Channel Interface Policy {{port_channel_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/lacplagp-{{port_channel_policy_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..lacpLagPol.attributes.name   {{ port_channel_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..lacpLagPol.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}    $..lacpLagPol.attributes.maxLinks   {{ policy.max_links | default(defaults.apic.access_policies.interface_policies.port_channel_policies.max_links) }}
    Should Be Equal Value Json String   ${r.json()}    $..lacpLagPol.attributes.minLinks   {{ policy.min_links | default(defaults.apic.access_policies.interface_policies.port_channel_policies.min_links) }}
    Should Be Equal Value Json String   ${r.json()}    $..lacpLagPol.attributes.mode   {{ policy.mode }}
{% if policy.symmetric_hash | default(defaults.apic.access_policies.interface_policies.port_channel_policies.symmetric_hash) | cisco.aac.aac_bool("yes") == "yes" and policy.hash_key is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..l2LoadBalancePol.attributes.hashFields   {{ policy.hash_key }}
{% endif %}

{% endfor %}
