*** Settings ***
Documentation   Verify Leaf Switch Policy Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pg in apic.access_policies.leaf_switch_policy_groups | default([]) %}
{% set policy_group_name = pg.name ~ defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix %}

Verify Leaf Switch Policy Group {{ policy_group_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/funcprof/accnodepgrp-{{ policy_group_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..infraAccNodePGrp.attributes.name   {{ policy_group_name }}
{% if pg.forwarding_scale_policy is defined %}
{% set forwarding_scale_policy_name = pg.forwarding_scale_policy ~ defaults.apic.access_policies.switch_policies.forwarding_scale_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsTopoctrlFwdScaleProfPol.attributes.tnTopoctrlFwdScaleProfilePolName   {{ forwarding_scale_policy_name }}
{% endif %}

{% endfor %}
