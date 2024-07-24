*** Settings ***
Documentation   Verify Netflow Exporter
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for exporter in apic.access_policies.interface_policies.netflow_exporters | default([]) %}
{% set exporter_name = exporter.name ~ defaults.apic.access_policies.interface_policies.netflow_exporters.name_suffix %}

Verify Netflow Exporter {{ exporter_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/exporterpol-{{ exporter_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.name    {{ exporter_name }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.descr   {{ exporter.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.dscp    {{ exporter.dscp | default(defaults.apic.access_policies.interface_policies.netflow_exporters.dscp) }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.dstAddr   {{ exporter.destination_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.dstPort   {{ exporter.destination_port }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.sourceIpType   {{ exporter.source_type | default(defaults.apic.access_policies.interface_policies.netflow_exporters.source_type) }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.srcAddr   {{ exporter.source_ip | default(defaults.apic.access_policies.interface_policies.netflow_exporters.source_ip) }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowExporterPol.attributes.ver   v9
{% if exporter.epg_type is defined %}
{% if exporter.epg_type == "epg" %}
{% set ap_name = exporter.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set epg_name = exporter.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..netflowExporterPol.children..netflowRsExporterToEPg.attributes.tDn   uni/tn-{{ exporter.tenant }}/ap-{{ ap_name }}/epg-{{ epg_name }}
{% elif exporter.epg_type == "external_epg" %}
{% set l3out_name = exporter.l3out ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set eepg_name = exporter.external_endpoint_group ~ defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..netflowExporterPol.children..netflowRsExporterToEPg.attributes.tDn   uni/tn-{{ exporter.tenant }}/out-{{ l3out_name }}/instP-{{ eepg_name }}
{% endif %}
{% set vrf_name = exporter.vrf ~ defaults.apic.tenants.vrfs.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..netflowExporterPol.children..netflowRsExporterToCtx.attributes.tDn   uni/tn-{{ exporter.tenant }}/ctx-{{ vrf_name }}
{% endif %}

{% endfor %}