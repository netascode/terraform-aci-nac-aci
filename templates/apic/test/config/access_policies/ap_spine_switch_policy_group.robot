*** Settings ***
Documentation   Verify Spine Switch Policy Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pg in apic.access_policies.spine_switch_policy_groups | default([]) %}
{% set policy_group_name = pg.name ~ defaults.apic.access_policies.spine_switch_policy_groups.name_suffix %}

Verify Spine Switch Policy Group {{ policy_group_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/funcprof/spaccnodepgrp-{{ policy_group_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..infraSpineAccNodePGrp.attributes.name   {{ policy_group_name }}
{% if pg.lldp_policy is defined %}
{% set lldp_policy_name = pg.lldp_policy ~ defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsSpinePGrpToLldpIfPol.attributes.tnLldpIfPolName   {{ lldp_policy_name }}
{% endif %}

{% endfor %}
