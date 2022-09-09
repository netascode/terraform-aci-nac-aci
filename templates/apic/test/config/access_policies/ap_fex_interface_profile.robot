*** Settings ***
Documentation   Verify Access FEX Interface Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.interface_policies.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.id ~ "`]" %}
{% set full_node = (apic.node_policies | community.general.json_query(query))[0] %}
{% if full_node.role == "leaf" %}
{% for fex in node.fexes | default([]) %}
{% set fex_profile_name = (full_node.id ~ ":" ~ full_node.name~ ":" ~ fex.id) | regex_replace("^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$", (apic.access_policies.fex_profile_name | default(defaults.apic.access_policies.fex_profile_name))) %}

Verify Access FEX Interface Profile {{ fex_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/fexprof-{{ fex_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraFexP.attributes.name   {{ fex_profile_name }}
    Should Be Equal Value Json String   ${r.json()}    $..infraFexBndlGrp.attributes.name   {{ fex_profile_name }}

{% endfor %}
{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.access_policies.fex_interface_profiles | default([]) %}
{% set fex_interface_profile_name = prof.name ~ defaults.apic.access_policies.fex_interface_profiles.name_suffix %}

Verify Access FEX Interface Profile {{ fex_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/fexprof-{{ fex_interface_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraFexP.attributes.name   {{ fex_interface_profile_name }}
    Should Be Equal Value Json String   ${r.json()}    $..infraFexBndlGrp.attributes.name   {{ fex_interface_profile_name }}

{% for sel in prof.selectors | default([]) %}
{% set fex_interface_selector_name = sel.name ~ defaults.apic.access_policies.fex_interface_profiles.selectors.name_suffix %}

Verify Access FEX Interface Profile {{ fex_interface_profile_name }} Selector {{ fex_interface_selector_name }}
    ${sel}=   Set Variable   $..infraFexP.children[?(@.infraHPortS.attributes.name=='{{ fex_interface_selector_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraHPortS.attributes.name   {{ fex_interface_selector_name }}
{% if sel.policy_group is defined %}
{% set query = "leaf_interface_policy_groups[?name=='" ~ sel.policy_group ~ "'].type[]" %}
{% set type = (apic.access_policies | community.general.json_query(query)) %}
{% set policy_group_name = sel.policy_group ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type[0] in ["pc", "vpc"] %}
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accbundle-{{ policy_group_name }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    ${sel}..infraRsAccBaseGrp.attributes.tDn   uni/infra/funcprof/accportgrp-{{ policy_group_name }}
{% endif %}
{% endif %}

{% for blk in sel.port_blocks | default([]) %}
{% set block_name = blk.name ~ defaults.apic.access_policies.fex_interface_profiles.selectors.port_blocks.name_suffix %}

Verify Access FEX Interface Profile {{ fex_interface_profile_name }} Selector {{ fex_interface_selector_name }} Port Block {{ block_name }}
    ${blk}=   Set Variable   $..infraFexP.children[?(@.infraHPortS.attributes.name=='{{ fex_interface_selector_name }}')].infraHPortS.children[?(@.infraPortBlk.attributes.name=='{{ block_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.name   {{ block_name }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.fromCard   {{ blk.from_module | default(defaults.apic.access_policies.fex_interface_profiles.selectors.port_blocks.from_module) }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.fromPort   {{ blk.from_port }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.toCard   {{ blk.to_module | default(blk.from_module | default(defaults.apic.access_policies.fex_interface_profiles.selectors.port_blocks.from_module)) }}
    Should Be Equal Value Json String   ${r.json()}    ${blk}..infraPortBlk.attributes.toPort   {{ blk.to_port | default(blk.from_port) }}

{% endfor %}
{% endfor %}
{% endfor %}
