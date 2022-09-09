*** Settings ***
Documentation   Verify Firmware Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify VPC Group Mode
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/protpol.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricProtPol.attributes.pairT   {{ apic.node_policies.vpc_groups.mode | default(defaults.apic.node_policies.vpc_groups.mode) }}

{% for group in apic.node_policies.vpc_groups.groups | default([]) %}
{% set vpc_group_name = (group.id ~ ":" ~ group.switch_1 ~ ":" ~ group.switch_2) | regex_replace("^(?P<id>.+):(?P<switch1_id>.+):(?P<switch2_id>.+)$", (apic.access_policies.vpc_group_name | default(defaults.apic.access_policies.vpc_group_name))) %}
{% set vpc_policy_name = group.policy | default() ~ defaults.apic.access_policies.switch_policies.vpc_policies.name_suffix %}

Verify vPC Group {{ vpc_group_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/protpol/expgep-{{ group.name | default(vpc_group_name) }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..fabricExplicitGEp.attributes.id   {{ group.id }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricExplicitGEp.attributes.name   {{ group.name | default(vpc_group_name) }}
{% if group.policy is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..fabricRsVpcInstPol.attributes.tnVpcInstPolName   {{ vpc_policy_name }}
{% endif %}
    ${list} =   Create List   {{ group.switch_1 }}   {{ group.switch_2 }}
    Should Be Equal Value Json List   ${r.json()}    $..fabricExplicitGEp.children[*].fabricNodePEp.attributes.id   ${list}

{% endfor %}
