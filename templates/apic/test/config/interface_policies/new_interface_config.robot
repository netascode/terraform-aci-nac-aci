{# iterate_list apic.node_policies.nodes id item[1] #}
*** Settings ***
Documentation   Verify Access Interface Configuration
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
{% if int.fabric | default(defaults.apic.interface_policies.nodes.interfaces.fabric) is false %}

Verify Access Leaf Interface Node {{ _node.id }} Port {{ module }}/{{ int.port }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/portconfnode-{{ _node.id }}-card-{{ module }}-port-{{ int.port }}-sub-0.json
{% if (int.breakout is not defined) and (int.breakout != 'none') %}
{% if int.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ int.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = int.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% if int.port_channel_member_policy is defined %}
{% set pc_member_policy_name = int.port_channel_member_policy ~ defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.pcMember   {{ pc_member_policy_name }}
{% endif %}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% elif int.fex_id is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.connectedFex   {{ int.fex_id }}
{% endif %}
{% elif int.breakout is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.brkoutMap   {{ int.breakout }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.card   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.description   {{ int.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.node   {{ _node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.port   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.role   {{ _node.role }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ 'yes' if int.shutdown | default(defaults.apic.interface_policies.nodes.interfaces.shutdown) else 'no' }}

{% for sub in int.sub_ports | default([]) %}

Verify Access Leaf Interface Node {{ _node.id }} Port {{ module }}/{{ int.port }}/{{ sub.port }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/portconfnode-{{ _node.id }}-card-{{ module }}-port-{{ int.port }}-sub-{{ sub.port }}.json
{% if sub.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ sub.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = sub.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% if int.port_channel_member_policy is defined %}
{% set pc_member_policy_name = int.port_channel_member_policy ~ defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.pcMember   {{ pc_member_policy_name }}
{% endif %}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% elif int.fex_id is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.connectedFex   {{ sub.fex_id }}
{% endif %}  
    Should Be Equal Value Json String   ${r.json()}    $..attributes.card   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.description   {{ sub.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.node   {{ _node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.port   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.subPort   {{ sub.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.role   {{ _node.role }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ 'yes' if sub.shutdown | default(defaults.apic.interface_policies.nodes.interfaces.sub_ports.shutdown) else 'no' }}

{% endfor %}
{% endif %}
{% endfor %}
{% set query = "nodes[?id==`" ~ _node.id ~ "`].fexes[]" %}
{% for fex in (apic.interface_policies | default() | community.general.json_query(query) | default([])) %}
{% for int in fex.interfaces | default([]) %}
{% set module = int.module | default(defaults.apic.interface_policies.nodes.fexes.interfaces.module) %}

Verify Fex {{ fex.id }} Access Interface Port {{ module }}/{{ int.port }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/portconfnode-{{ _node.id }}-card-{{ fex.id }}-port-{{ module }}-sub-{{ int.port }}.json
{% if int.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ int.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = int.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% if int.port_channel_member_policy is defined %}
{% set pc_member_policy_name = int.port_channel_member_policy ~ defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.pcMember   {{ pc_member_policy_name }}
{% endif %}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.assocGrp   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.card   {{ fex.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.description   {{ int.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.node   {{ _node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.port   {{ module }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.subPort   {{ int.port }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.role   {{ _node.role }}
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ 'yes' if int.shutdown | default(defaults.apic.interface_policies.nodes.fexes.interfaces.shutdown) else 'no' }}

{% endfor %}
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
    Should Be Equal Value Json String   ${r.json()}    $..attributes.shutdown   {{ 'yes' if int.shutdown | default(defaults.apic.interface_policies.nodes.interfaces.shutdown) else 'no' }}

{% endif %}
{% endfor %}

{% endif %}

{% endif %}
{% endfor %}

{% endif %}
