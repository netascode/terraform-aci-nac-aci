*** Settings ***
Documentation   Verify Netflow VMM Exporter
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for exporter in apic.access_policies.interface_policies.netflow_vmm_exporters | default([]) %}
{% set exporter_name = exporter.name ~ defaults.apic.access_policies.interface_policies.netflow_vmm_exporters.name_suffix %}

Verify Netflow VMM Exporter {{ exporter_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/vmmexporterpol-{{ exporter_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..netflowVmmExporterPol.attributes.name    {{ exporter_name }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowVmmExporterPol.attributes.descr   {{ exporter.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowVmmExporterPol.attributes.dstAddr   {{ exporter.destination_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowVmmExporterPol.attributes.dstPort   {{ exporter.destination_port }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowVmmExporterPol.attributes.srcAddr   {{ exporter.source_ip | default(defaults.apic.access_policies.interface_policies.netflow_vmm_exporters.source_ip) }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowVmmExporterPol.attributes.ver   v9
{% endfor %}