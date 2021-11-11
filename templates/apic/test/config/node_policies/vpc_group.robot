*** Settings ***
Documentation   Verify Firmware Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify VPC Group Mode
    GET   "/api/mo/uni/fabric/protpol.json"
    String   $..fabricProtPol.attributes.pairT   {{ apic.node_policies.vpc_groups.mode | default(defaults.apic.node_policies.vpc_groups.mode) }}

{% for group in apic.node_policies.vpc_groups.groups | default([]) %}
{% set vpc_group_name = (group.id ~ ":" ~ group.switch_1 ~ ":" ~ group.switch_2) | regex_replace("^(?P<id>.+):(?P<switch1_id>.+):(?P<switch2_id>.+)$", (apic.access_policies.vpc_group_name | default(defaults.apic.access_policies.vpc_group_name))) %}
{% set vpc_policy_name = group.policy | default() ~ defaults.apic.access_policies.switch_policies.vpc_policies.name_suffix %}

Verify vPC Group {{ vpc_group_name }}
    GET   "/api/mo/uni/fabric/protpol/expgep-{{ group.name | default(vpc_group_name) }}.json?rsp-subtree=full"
    String   $..fabricExplicitGEp.attributes.id   {{ group.id }}
    String   $..fabricExplicitGEp.attributes.name   {{ group.name | default(vpc_group_name) }}
{% if group.policy is defined %}
    String   $..fabricRsVpcInstPol.attributes.tnVpcInstPolName   {{ vpc_policy_name }}
{% endif %}
    String   $..fabricExplicitGEp.children[*].fabricNodePEp.attributes.id   {{ group.switch_1 }}   {{ group.switch_2 }}

{% endfor %}
