*** Settings ***
Documentation   Verify VSPAN Destination Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vspan in apic.access_policies.vspan.destination_groups | default([]) %}
{% set vspan_name = vspan.name ~ defaults.apic.access_policies.vspan.destination_groups.name_suffix %}

Verify VSPAN Destination Group {{ vspan_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/vdestgrp-{{ vspan_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..spanVDestGrp.attributes.name   {{ vspan_name }}
    Should Be Equal Value Json String   ${r.json()}    $..spanVDestGrp.attributes.descr   {{ vspan.description | default() }}

{% for destination in vspan.destinations | default([]) %}
{% set destination_name = destination.name ~ defaults.apic.access_policies.vspan.destination_groups.destinations.name_suffix %}

Verify VSPAN Destination Group {{ vspan_name }} Destination {{ destination_name }}
    ${dest}=   Set Variable   $..spanVDestGrp.children[?(@.spanVDest.attributes.name=='{{ destination_name }}')].spanVDest
    Should Be Equal Value Json String   ${r.json()}    ${dest}.attributes.name   {{ destination_name }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}.attributes.descr   {{ destination.description | default() }}

{% if destination.tenant is defined and destination.application_profile is defined and destination.endpoint_group is defined and destination.endpoint is defined %}
{% set application_profile_name = destination.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set endpoint_group_name = destination.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanRsDestToVPort.attributes.tDn   uni/tn-{{ destination.tenant }}/ap-{{ application_profile_name }}/epg-{{ endpoint_group_name }}/cep-{{ destination.endpoint }}
{% endif %}
{% if destination.ip is defined %}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.dstIp   {{ destination.ip }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.dscp   {{ destination.dscp | default(defaults.apic.access_policies.vspan.destination_groups.destinations.dscp) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.flowId   {{ destination.flow_id | default(defaults.apic.access_policies.vspan.destination_groups.destinations.flow_id) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.mode   not-visible
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.mtu   {{ destination.mtu | default(defaults.apic.access_policies.vspan.destination_groups.destinations.mtu) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.srcIpPrefix   0.0.0.0
    Should Be Equal Value Json String   ${r.json()}    ${dest}..spanVEpgSummary.attributes.ttl   {{ destination.ttl | default(defaults.apic.access_policies.vspan.destination_groups.destinations.ttl) }}
{% endif %}

{% endfor %}

{% endfor %}
