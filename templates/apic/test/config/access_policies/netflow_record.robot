*** Settings ***
Documentation   Verify Netflow Record
Suite Setup     Login APIC
Default Tags    apic   day2   config   access_policies    netflow
Resource        ../../apic_common.resource

*** Test Cases ***
{% for record in apic.access_policies.interface_policies.netflow_records | default([]) %}
{% set record_name = record.name ~ defaults.apic.access_policies.interface_policies.netflow_records.name_suffix %}

Verify Netflow Record {{ record_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/recordpol-{{ record_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..netflowRecordPol.attributes.name   {{ record_name }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowRecordPol.attributes.descr   {{ record.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..netflowRecordPol.attributes.match   {{ record.match_parameters | default() | sort() | join(',') }}

{% endfor %}