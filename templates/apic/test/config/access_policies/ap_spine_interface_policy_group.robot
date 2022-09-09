*** Settings ***
Documentation   Verify Spine Interface Policy Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pg in apic.access_policies.spine_interface_policy_groups | default([]) %}
{% set policy_group_name = pg.name ~ defaults.apic.access_policies.spine_interface_policy_groups.name_suffix %}

Verify Spine Interface Policy Group {{ policy_group_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/funcprof/spaccportgrp-{{ policy_group_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..infraSpAccPortGrp.attributes.name   {{ policy_group_name }}
{% if pg.link_level_policy is defined %}
{% set link_level_policy_name = pg.link_level_policy ~ defaults.apic.access_policies.interface_policies.link_level_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsHIfPol.attributes.tnFabricHIfPolName   {{ link_level_policy_name }}
{% endif %}
{% if pg.cdp_policy is defined %}
{% set cdp_policy_name = pg.cdp_policy ~ defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsCdpIfPol.attributes.tnCdpIfPolName   {{ cdp_policy_name }}
{% endif %}
{% if pg.aaep is defined %}
{% set aaep_name = pg.aaep ~ defaults.apic.access_policies.aaeps.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsAttEntP.attributes.tDn   uni/infra/attentp-{{ aaep_name }}
{% endif %}

{% endfor %}
