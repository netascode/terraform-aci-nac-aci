{# iterate_list apic.node_policies.nodes id item[1] #}
*** Settings ***
Documentation   Verify Access FEX Interface Selector
Suite Setup     Login APIC
Default Tags    apic   day2   config   interface_policies
Resource        ../../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for _node in apic.node_policies.nodes | default([]) %}
{% if _node.role == "leaf" and _node.id | string == item[1] %}
{% set query = "nodes[?id==`" ~ _node.id ~ "`].fexes[]" %}
{% if apic.interface_policies is defined %}
{% for fex in (apic.interface_policies | default() | community.general.json_query(query) | default([])) %}
{% set fex_profile_name = (_node.id ~ ":" ~ _node.name~ ":" ~ fex.id) | regex_replace("^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$", (apic.access_policies.fex_profile_name | default(defaults.apic.access_policies.fex_profile_name))) %}

{% for int in fex.interfaces | default([]) %}
{% set module = int.module | default(defaults.apic.interface_policies.nodes.fexes.interfaces.from_module) %}
{% set fex_interface_selector_name = (module ~ ":" ~ int.port) | regex_replace("^(?P<mod>.+):(?P<port>.+)$", (apic.access_policies.fex_interface_selector_name | default(defaults.apic.access_policies.fex_interface_selector_name))) %}

Verify Access FEX Interface Profile {{ fex_profile_name }} Selector {{ fex_interface_selector_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/fexprof-{{ fex_profile_name }}/hports-{{ fex_interface_selector_name }}-typ-range.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..infraHPortS.attributes.name   {{ fex_interface_selector_name }}
{% if int.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ int.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = int.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortBlk.attributes.descr   {{ int.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortBlk.attributes.fromCard   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortBlk.attributes.fromPort   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortBlk.attributes.name   {{ module }}-{{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortBlk.attributes.toCard   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortBlk.attributes.toPort   {{ int.port }}

{% endfor %}

{% endfor %}
{% endif %}
{% endif %}
{% endfor %}
{% endif %}
