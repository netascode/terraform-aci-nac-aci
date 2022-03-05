*** Settings ***
Documentation   Verify Access Leaf Interface Selector
Suite Setup     Login APIC
Default Tags    apic   day2   config   interface_policies
Resource        ../../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for _node in apic.node_policies.nodes | default([]) %}
{% if _node.role == "leaf" and _node.id | string == item[1] %}
{% set leaf_interface_profile_name = (_node.id ~ ":" ~ _node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}

{% set query = "nodes[?id==`" ~ _node.id ~ "`].interfaces[]" %}
{% if apic.interface_policies is defined %}
{% for int in (apic.interface_policies | default() | community.general.json_query(query) | default([])) %}
{% set module = int.module | default(defaults.apic.interface_policies.nodes.interfaces.from_module) %}
{% set leaf_interface_selector_name = (module ~ ":" ~ int.port) | regex_replace("^(?P<mod>.+):(?P<port>.+)$", (apic.access_policies.leaf_interface_selector_name | default(defaults.apic.access_policies.leaf_interface_selector_name))) %}

Verify Access Leaf Interface Profile {{ leaf_interface_profile_name }} Selector {{ leaf_interface_selector_name }}
    GET   "/api/mo/uni/infra/accportprof-{{ leaf_interface_profile_name }}/hports-{{ leaf_interface_selector_name }}-typ-range.json?rsp-subtree=full"
    String   $..infraHPortS.attributes.name   {{ leaf_interface_selector_name }}
{% if int.fex_id is defined %}
{% set fex_profile_name = (_node.id ~ ":" ~ _node.name~ ":" ~ int.fex_id) | regex_replace("^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$", (apic.access_policies.fex_profile_name | default(defaults.apic.access_policies.fex_profile_name))) %}
    String   $..infraRsAccBaseGrp.attributes.fexId   {{ int.fex_id }}
    String   $..infraRsAccBaseGrp.attributes.tDn   uni/infra/fexprof-{{ fex_profile_name }}/fexbundle-{{ fex_profile_name }}
{% elif int.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ int.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = int.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    String   $..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% else %}
    String   $..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% endif %}
    String   $..infraPortBlk.attributes.descr   "{{ int.description | default() }}"
    String   $..infraPortBlk.attributes.fromCard   {{ module }}
    String   $..infraPortBlk.attributes.fromPort   {{ int.port }}
    String   $..infraPortBlk.attributes.name   {{ module }}-{{ int.port }}
    String   $..infraPortBlk.attributes.toCard   {{ module }}
    String   $..infraPortBlk.attributes.toPort   {{ int.port }}

{% endfor %}
{% endif %}

{% endif %}
{% endfor %}
{% endif %}
