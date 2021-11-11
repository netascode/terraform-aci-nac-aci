*** Settings ***
Documentation   Verify Spine Switch Policy Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pg in apic.fabric_policies.spine_switch_policy_groups | default([]) %}
{% set policy_group_name = pg.name ~ defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix %}

Verify Spine Switch Policy Group {{ policy_group_name }}
    GET   "/api/mo/uni/fabric/funcprof/spnodepgrp-{{ policy_group_name }}.json?rsp-subtree=full"
    String   $..fabricSpNodePGrp.attributes.name   {{ policy_group_name }}
{% if pg.psu_policy is defined %}
{% set psu_policy_name = pg.psu_policy ~ defaults.apic.fabric_policies.switch_policies.psu_policies.name_suffix %}
    String   $..fabricRsPsuInstPol.attributes.tnPsuInstPolName   {{ psu_policy_name }}
{% endif %}
{% if pg.node_control_policy is defined %}
{% set node_control_policy_name = pg.node_control_policy ~ defaults.apic.fabric_policies.switch_policies.node_control_policies.name_suffix %}
    String   $..fabricRsNodeCtrl.attributes.tnFabricNodeControlName   {{ node_control_policy_name }}
{% endif %}

{% endfor %}
