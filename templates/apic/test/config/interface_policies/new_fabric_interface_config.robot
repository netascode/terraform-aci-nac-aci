{# iterate_list apic.node_policies.nodes id item[1] #}
*** Settings ***
Documentation   Verify Fabric Interface Configuration
Suite Setup     Login APIC
Default Tags    apic   day2   config   interface_policies
Resource        ../../../apic_common.resource

*** Test Cases ***
{% if apic.new_interface_configuration | default(defaults.apic.new_interface_configuration) %}

{% for _node in apic.node_policies.nodes | default([]) %}
{% if _node.role == "leaf" and _node.id | string == item[1] %}

{% set query = "nodes[?id==`" ~ _node.id ~ "`].interfaces[]" %}
{% if apic.interface_policies is defined %}

{% for int in (apic.interface_policies | default() | community.general.json_query(query) | default([])) %}
{% set module = int.module | default(defaults.apic.interface_policies.nodes.interfaces.module) %}
{% if int.fabric | default(defaults.apic.interface_policies.nodes.interfaces.fabric) %}

Verify Fabric Leaf Interface Node {{ _node.id }} Port {{ module }}/{{ int.port }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/portconfnode-{{ _node.id }}-card-{{ module }}-port-{{ int.port }}-sub-0.json
{% if int.policy_group is defined %}
{% set policy_group_name = int.policy_group ~ defaults.apic.fabric_policies.leaf_interface_policy_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/fabric/funcprof/leportgrp-{{ policy_group_name }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.card   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.description   {{ int.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.node   {{ _node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.port   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.role   {{ _node.role }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ int.shutdown | default(False) | cisco.aac.aac_bool("yes") }}

{% for sub in int.sub_ports | default([]) %}

Verify Fabric Leaf Interface Node {{ _node.id }} Port {{ module }}/{{ int.port }}/{{ sub.port }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/portconfnode-{{ _node.id }}-card-{{ module }}-port-{{ int.port }}-sub-{{ sub.port }}.json
{% if sub.policy_group is defined %}
{% set policy_group_name = sub.policy_group ~ defaults.apic.fabric_policies.leaf_interface_policy_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/fabric/funcprof/leportgrp-{{ policy_group_name }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.card   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.description   {{ sub.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.node   {{ _node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.port   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.subPort   {{ sub.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.role   {{ _node.role }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ sub.shutdown | default(False) | cisco.aac.aac_bool("yes") }}

{% endfor %}
{% endif %}
{% endfor %}

{% endif %}

{% endif %}
{% endfor %}

{% for _node in apic.node_policies.nodes | default([]) %}
{% if _node.role == "spine" and _node.id | string == item[1] %}

{% set query = "nodes[?id==`" ~ _node.id ~ "`].interfaces[]" %}
{% if apic.interface_policies is defined %}

{% for int in (apic.interface_policies | default() | community.general.json_query(query) | default([])) %}
{% set module = int.module | default(defaults.apic.interface_policies.nodes.interfaces.module) %}
{% if int.fabric | default(defaults.apic.interface_policies.nodes.interfaces.fabric) is false %}

Verify Access Spine Interface Node {{ _node.id }} Port {{ module }}/{{ int.port }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/portconfnode-{{ _node.id }}-card-{{ module }}-port-{{ int.port }}-sub-0.json
{% if int.policy_group is defined %}
{% set policy_group_name = int.policy_group ~ defaults.apic.access_policies.spine_interface_policy_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/spaccportgrp-{{ policy_group_name }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.card   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.description   {{ int.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.node   {{ _node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.port   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.role   {{ _node.role }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ int.shutdown | default(False) | cisco.aac.aac_bool("yes") }}

{% endif %}
{% endfor %}

{% endif %}

{% endif %}
{% endfor %}

{% endif %}