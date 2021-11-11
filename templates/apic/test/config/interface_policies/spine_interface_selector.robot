*** Settings ***
Documentation   Verify Access Spine Interface Selector
Suite Setup     Login APIC
Default Tags    apic   day1   config   interface_policies
Resource        ../../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) == "enabled" or apic.auto_generate_access_spine_switch_interface_profiles | default(defaults.apic.auto_generate_access_spine_switch_interface_profiles) == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" and node.id | string == item[1] %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.spine_interface_profile_name | default(defaults.apic.access_policies.spine_interface_profile_name))) %}

{% set query = "nodes[?id==`" ~ node.id ~ "`].interfaces[]" %}
{% if apic.interface_policies is defined %}
{% for int in (apic.interface_policies | default() | json_query(query) | default([])) %}
{% set module = int.module | default(defaults.apic.interface_policies.nodes.interfaces.from_module) %}
{% set spine_interface_selector_name = (module ~ ":" ~ int.port) | regex_replace("^(?P<mod>.+):(?P<port>.+)$", (apic.access_policies.spine_interface_selector_name | default(defaults.apic.access_policies.spine_interface_selector_name))) %}

Verify Access Spine Interface Profile {{ spine_interface_profile_name }} Selector {{ spine_interface_selector_name }}
    GET   "/api/mo/uni/infra/spaccportprof-{{ spine_interface_profile_name }}/shports-{{ spine_interface_selector_name }}-typ-range.json?rsp-subtree=full"
    String   $..infraSHPortS.attributes.name   {{ spine_interface_selector_name }}
    String   $..infraPortBlk.attributes.descr   "{{ int.description | default() }}"
    String   $..infraPortBlk.attributes.fromCard   {{ module }}
    String   $..infraPortBlk.attributes.fromPort   {{ int.port }}
    String   $..infraPortBlk.attributes.name   {{ module }}-{{ int.port }}
    String   $..infraPortBlk.attributes.toCard   {{ module }}
    String   $..infraPortBlk.attributes.toPort   {{ int.port }}
{% if int.policy_group is defined %}
{% set policy_group_name = int.policy_group ~ defaults.apic.access_policies.spine_interface_policy_groups.name_suffix %}
    String   $..infraRsSpAccGrp.attributes.tDn   uni/infra/funcprof/spaccportgrp-{{ policy_group_name }}
{% endif %}

{% endfor %}
{% endif %}

{% endif %}
{% endfor %}
{% endif %}
