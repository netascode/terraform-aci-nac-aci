*** Settings ***
Documentation   Verify SPAN Source Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for span in apic.access_policies.span.source_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.access_policies.span.source_groups.name_suffix %}

Verify SPAN Source Group {{ span_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/srcgrp-{{ span_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..spanSrcGrp.attributes.name   {{ span_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanSrcGrp.attributes.descr   {{ span.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..spanSrcGrp.attributes.adminSt   {{ span.admin_state | default(defaults.apic.access_policies.span.source_groups.admin_state) | cisco.aac.aac_bool("enabled") }}

{% for source in span.sources | default([]) %}
{% set source_name = source.name ~ defaults.apic.access_policies.span.source_groups.sources.name_suffix %}
Verify SPAN Source Group {{ span_name }} Source {{ source_name }}
    ${source}=   Set Variable   $..spanSrcGrp.children[?(@.spanSrc.attributes.name=='{{ source_name }}')].spanSrc
    Should Be Equal Value Json String   ${r.json()}    ${source}.attributes.name   {{ source_name }}
    Should Be Equal Value Json String   ${r.json()}    ${source}.attributes.dir   {{ source.direction | default(defaults.apic.access_policies.span.source_groups.sources.direction) }}
    Should Be Equal Value Json String   ${r.json()}    ${source}.attributes.spanOnDrop   {{ source.span_drop | default(defaults.apic.access_policies.span.source_groups.sources.span_drop) | cisco.aac.aac_bool("yes") }}
{% if source.tenant is defined and source.application_profile is defined and source.endpoint_group is defined %}
{% set application_profile_name = source.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}      
{% set endpoint_group_name = source.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    ${source}..spanRsSrcToEpg.attributes.tDn   uni/tn-{{ source.tenant }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}                          
{% endif %}
{% if source.tenant is defined and source.l3out is defined %}
{% set l3out_name = source.l3out ~ defaults.apic.tenants.l3outs.name_suffix %}   
    Should Be Equal Value Json String   ${r.json()}    ${source}..spanRsSrcToL3extOut.attributes.tDn   uni/tn-{{ source.tenant }}/out-{{ l3out_name }}                           
    Should Be Equal Value Json String   ${r.json()}    ${source}..spanRsSrcToL3extOut.attributes.encap   vlan-{{ source.vlan }}
{% endif %}
{% for path in source.access_paths| default([]) %}

{% if path.node_id is defined and path.channel is not defined %}
    {% set query = "nodes[?id==`" ~ path.node_id ~ "`].pod" %}
    {% set pod = path.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
    {% if path.sub_port is defined %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}/{{ path.sub_port }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}/{{ path.sub_port }}]
    {% elif path.fex_id is defined %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ path.node_id }}/extpaths-{{ path.fex_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ path.node_id }}/extpaths-{{ path.fex_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}] 
    {%else%}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.access_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]
    {% endif %}                                                    
{% else %}
    {% set policy_group_name = path.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
    {% set query = "leaf_interface_policy_groups[?name==`" ~ path.channel ~ "`].type" %}
    {% set type = (apic.access_policies | community.general.json_query(query))[0] | default('vpc' if path.node2_id is defined else 'pc') %}
    {% set query_sub_ports = "nodes[?interfaces[?sub_ports[?policy_group==`" ~ path.channel ~ "`]]].id" %}
    {% set id_sub_ports = (apic.interface_policies | default() | community.general.json_query(query_sub_ports)) %}
    {% set query_ports = "nodes[?interfaces[?policy_group==`" ~ path.channel ~ "`]].id" %}
    {% set id_ports = (apic.interface_policies | default() | community.general.json_query(query_ports)) %}
    {% if id_sub_ports | length > 0 %}
        {% if path.node_id is defined %}
            {% set node = path.node_id %}
        {% else %}
            {% set query = "nodes[?interfaces[?sub_ports[?policy_group==`" ~ path.channel ~ "`]]].id" %}
            {% set node = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
        {% endif %}
        {% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
        {% set pod = path.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
        {% if type == 'vpc' %}
            {% if path.node2_id is defined %}
                {% set node2 = path.node2_id %}
            {% else %}
                {% set query = "nodes[?interfaces[?sub_ports[?policy_group==`" ~ path.channel ~ "`]]].id" %}
                {% set node2 = (apic.interface_policies | default() | community.general.json_query(query))[1] %}
                {% if node2 < node %}{% set node_tmp = node %}{% set node = node2 %}{% set node2 = node_tmp %}{% endif %}
            {% endif %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]
        {% else %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]')].spanRsSrcToPathEp
    Should Be Equal Value Json String   ${r.json()}    ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
        {% endif %}                                                    
    {% elif id_ports | length > 0 %}
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
{% endif %}

{% endfor %}


{% endfor %}

{% if span.filter_group is defined %}
{% set filter_group_name = span.filter_group ~ defaults.apic.access_policies.span.filter_groups.name_suffix %}
Verify SPAN Source Group {{ span_name }} Filter Group
    Should Be Equal Value Json String   ${r.json()}    $..spanSrcGrp.children..spanRsSrcGrpToFilterGrp.attributes.tDn   uni/infra/filtergrp-{{ filter_group_name }}
{% endif  %}

{% set destination_name = span.destination.name ~ defaults.apic.access_policies.span.destination_groups.name_suffix %}
Verify SPAN Source Group {{ span_name }} Destination Group
    Should Be Equal Value Json String   ${r.json()}    $..spanSrcGrp.children..spanSpanLbl.attributes.name   {{ destination_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanSrcGrp.children..spanSpanLbl.attributes.descr   {{ span.destination.description | default() }}
{% endfor %}
