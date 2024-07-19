*** Settings ***
Documentation   Verify Netflow Monitor
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies    netflow
Resource        ../../apic_common.resource

*** Test Cases ***
{% for monitor in apic.access_policies.interface_policies.netflow_monitors | default([]) %}
{% set monitor_name = monitor.name ~ defaults.apic.access_policies.interface_policies.netflow_monitors.name_suffix %}

Verify Netflow Monitor {{ monitor_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/monitorpol-{{ monitor_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..netflowMonitorPol.attributes.name   {{ monitor_name }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowMonitorPol.attributes.descr   {{ monitor.description | default() }}

{% if monitor.flow_record is defined %}
{% set record_name = monitor.flow_record ~ defaults.apic.access_policies.interface_policies.netflow_records.name_suffix %}
Verify Netflow Monitor {{ monitor_name }} Record {{ record_name }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowMonitorPol.children..tnNetflowRecordPolName   {{ record_name }}
{% endif %}                 

{% for exporter in monitor.flow_exporters | default([]) %}
{% set exporter_name = exporter ~ defaults.apic.access_policies.interface_policies.netflow_exporters.name_suffix %}
Verify Netflow Monitor {{ monitor_name }} Exporter {{ exporter_name }}
    ${exp}=   Set Variable   $..netflowMonitorPol.children[?(@.netflowRsMonitorToExporter.attributes.tnNetflowExporterPolName=='{{ exporter_name }}')].netflowRsMonitorToExporter
    Should Be Equal Value Json String   ${r.json()}    ${exp}.attributes.tnNetflowExporterPolName   {{ exporter_name }}
{% endfor %}

{% endfor %}