*** Settings ***
Documentation   Verify vPC Switch Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.switch_policies.vpc_policies | default([]) %}
{% set vpc_policy_name = policy.name ~ defaults.apic.access_policies.switch_policies.vpc_policies.name_suffix %}

Verify vPC Switch Policy {{vpc_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/vpcInst-{{vpc_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..vpcInstPol.attributes.name   {{ vpc_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..vpcInstPol.attributes.deadIntvl   {{ policy.peer_dead_interval | default(defaults.apic.access_policies.switch_policies.vpc_policies.peer_dead_interval) }}

{% endfor %}
