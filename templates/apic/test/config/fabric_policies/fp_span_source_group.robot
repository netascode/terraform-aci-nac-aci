*** Settings ***
Documentation   Verify Fabric SPAN Source Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for span in apic.fabric_policies.span.source_groups | default([]) %}
{% set span_name = span.name ~ defaults.apic.fabric_policies.span.source_groups.name_suffix %}

Verify SPAN Source Group {{ span_name }}
    GET  "/api/mo/uni/fabric/srcgrp-{{ span_name }}.json?rsp-subtree=full"
    String   $..spanSrcGrp.attributes.name   {{ span_name }}
    String   $..spanSrcGrp.attributes.descr   {{ span.description | default() }}
    String   $..spanSrcGrp.attributes.adminSt   {{ span.admin_state | default(defaults.apic.fabric_policies.span.source_groups.admin_state) }}

{% for source in span.sources | default([]) %}
{% set source_name = source.name ~ defaults.apic.fabric_policies.span.source_groups.sources.name_suffix %}
Verify SPAN Source Group {{ span_name }} Source {{ source_name }}
    ${source}=   Set Variable   $..spanSrcGrp.children[?(@.spanSrc.attributes.name=='{{ source_name }}')].spanSrc
    String   ${source}.attributes.name   {{ source_name }}
    String   ${source}.attributes.dir   {{ source.direction | default(defaults.apic.fabric_policies.span.source_groups.sources.direction) }}
    String   ${source}.attributes.spanOnDrop   {{ source.span_drop | default(defaults.apic.fabric_policies.span.source_groups.sources.span_drop) }}
{% if source.tenant is defined and source.vrf is defined %}
{% set vrf_name = source.vrf ~ defaults.apic.tenants.vrfs.name_suffix %} 
    String   ${source}..spanRsSrcToCtx.attributes.tDn   uni/tn-{{ source.tenant }}/ctx-{{ vrf_name }}                     
{% endif %}
{% if source.tenant is defined and source.bridge_domain is defined %}
{% set bd_name = source.bridge_domain ~ defaults.apic.tenants.bridge_domains.name_suffix %}
    String   ${source}..spanRsSrcToBD.attributes.tDn   uni/tn-{{ source.tenant }}/BD-{{ bd_name }}                           
{% endif %}

{% for path in source.fabric_paths| default([]) %}
{% set query = "nodes[?id==`" ~ path.node_id ~ "`].pod" %}
{% set pod = path.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
    ${path}=   Set Variable   ${source}.children[?(@.spanRsSrcToPathEp.attributes.tDn=='topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.fabric_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]')].spanRsSrcToPathEp
    String   ${path}.attributes.tDn   topology/pod-{{ pod }}/paths-{{ path.node_id }}/pathep-[eth{{ path.module | default(defaults.apic.fabric_policies.span.source_groups.sources.access_paths.module) }}/{{ path.port }}]

{% endfor %}


{% endfor %}

{% set destination_name = span.destination.name ~ defaults.apic.fabric_policies.span.destination_groups.name_suffix %}
    String   $..spanSrcGrp.children..spanSpanLbl.attributes.name   {{ destination_name }}
    String   $..spanSrcGrp.children..spanSpanLbl.attributes.descr   {{ span.destination.description | default() }}
    String   $..spanSrcGrp.children..spanSpanLbl.attributes.nameAlias   {{ span.destination.alias | default() }}
{% endfor %}