*** Settings ***
Documentation   Verify VSPAN Session
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vspan in apic.access_policies.vspan.sessions | default([]) %}
{% set vspan_name = vspan.name ~ defaults.apic.access_policies.vspan.sessions.name_suffix %}

Verify VSPAN Session {{ vspan_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/vsrcgrp-{{ vspan_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..spanVSrcGrp.attributes.name   {{ vspan_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanVSrcGrp.attributes.descr   {{ vspan.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..spanVSrcGrp.attributes.adminSt   {% if vspan.admin_state | default(defaults.apic.access_policies.vspan.sessions.admin_state) | cisco.aac.aac_bool("enabled") == "enabled" %}start{% else %}stop{% endif %}

{% for source in vspan.sources | default([]) %}
{% set source_name = source.name ~ defaults.apic.access_policies.vspan.sessions.sources.name_suffix %}
Verify VSPAN Session {{ vspan_name }} Source {{ source_name }}
    ${source}=   Set Variable   $..spanVSrcGrp.children[?(@.spanVSrc.attributes.name=='{{ source_name }}')].spanVSrc
    Should Be Equal Value Json String   ${r.json()}    ${source}.attributes.name   {{ source_name }}
    Should Be Equal Value Json String   ${r.json()}    ${source}.attributes.descr   {{ source.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    ${source}.attributes.dir   {{ source.direction | default(defaults.apic.access_policies.vspan.sessions.sources.direction) }}

{% for path in source.access_paths| default([]) %}
{% if path.node_id is defined and path.channel is not defined%}
{% set query = "nodes[?id==`" ~ path.node_id ~ "`].pod" %}
{% set pod = path.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.vspan.sessions.sources.access_paths.module) }}/{{ path.port }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.vspan.sessions.sources.access_paths.module) }}/{{ path.port }}]
{% else %}
{% set policy_group_name = path.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ path.channel ~ "`].type" %}
{% if path.type is defined %}
    {% set type = path.type %}
{% else %}
    {% set type = (apic.access_policies | community.general.json_query(query))[0] | default('vpc' if path.node2_id is defined else 'pc') %}
{% endif %}
{% if path.node_id is defined %}
    {% set node = path.node_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ path.channel ~ "`]].id" %}
    {% set node = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
{% endif %}
{% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
{% set pod = path.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% if type == 'vpc' %}
{% if path.node2_id is defined %}
    {% set node2 = path.node2_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ path.channel ~ "`]].id" %}
    {% set node2 = (apic.interface_policies | default() | community.general.json_query(query))[1] %}
    {% if node2 < node %}{% set node_tmp = node %}{% set node = node2 %}{% set node2 = node_tmp %}{% endif %}
{% endif %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]')].spanRsSrcToPathEp 
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]
{% else %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
{% endif %}
{% endif %}

{% endfor %}

{% if source.tenant is defined and source.application_profile is defined and source.endpoint_group is defined and source.endpoint is not defined %}
{% set application_profile_name = source.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}      
{% set endpoint_group_name = source.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    ${source}..spanRsSrcToEpg.attributes.tDn   uni/tn-{{ source.tenant }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}                           
{% endif %}
{% if source.tenant is defined and source.application_profile is defined and source.endpoint_group is defined and source.endpoint is defined %}
{% set application_profile_name = source.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}      
{% set endpoint_group_name = source.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    ${source}..spanRsSrcToVPort.attributes.tDn   uni/tn-{{ source.tenant }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}/cep-{{ source.endpoint}}                           
{% endif %}

{% endfor %}

{% set destination_name = vspan.destination.name ~ defaults.apic.access_policies.vspan.destination_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..spanVSrcGrp.children..spanSpanLbl.attributes.name   {{ destination_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanVSrcGrp.children..spanSpanLbl.attributes.descr   {{ vspan.destination.description | default() }}
{% endfor %}
