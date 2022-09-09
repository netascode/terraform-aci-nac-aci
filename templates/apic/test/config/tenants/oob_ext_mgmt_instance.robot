{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify External Management Instance
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ext in tenant.ext_mgmt_instances | default([]) %}
{% set ext_name = ext.name ~ defaults.apic.tenants.ext_mgmt_instances.name_suffix %}

Verify External Management Instance {{ ext_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-mgmt/extmgmt-default/instp-{{ ext_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..mgmtInstP.attributes.name   {{ ext_name }}

{% for subnet in ext.subnets | default([]) %}

Verify External Management Instance {{ ext_name }} Subnet {{ subnet }}
    ${subnet}=   Set Variable   $..mgmtInstP.children[?(@.mgmtSubnet.attributes.ip=='{{ subnet }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..mgmtSubnet.attributes.ip   {{ subnet }}

{% endfor %}

{% for contract in ext.oob_contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.oob_contracts.name_suffix %}

Verify External Management Instance {{ ext_name }} Consumed OOB Contract {{ contract_name }}
    ${con}=   Set Variable   $..mgmtInstP.children[?(@.mgmtRsOoBCons.attributes.tnVzOOBBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..mgmtRsOoBCons.attributes.tnVzOOBBrCPName   {{ contract_name }}

{% endfor %}

{% endfor %}
