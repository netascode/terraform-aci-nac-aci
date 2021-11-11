*** Settings ***
Documentation   Verify OOB Endpoint Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for epg in tenant.oob_endpoint_groups | default([]) %}
{% if epg.name is not defined %}
{% set epg_name = defaults.apic.tenants.oob_endpoint_groups.name %}
{% else %}
{% set epg_name = epg.name ~ defaults.apic.tenants.oob_endpoint_groups.name_suffix %}
{% endif %}

Verify OOB Endpoint Group {{ epg_name }}
    GET   "/api/mo/uni/tn-mgmt/mgmtp-default/oob-{{ epg_name }}.json?rsp-subtree=full"    
    String   $..mgmtOoB.attributes.name   {{ epg_name }}

{% for oob_contract in epg.oob_contracts.providers | default([]) %}
{% set oob_contract_name = oob_contract ~ defaults.apic.tenants.oob_contracts.name_suffix %}

Verify OOB Endpoint Group {{ epg_name }} Contract Provider {{ oob_contract_name }}
    ${con}=   Set Variable   $..mgmtOoB.children[?(@.mgmtRsOoBProv.attributes.tnVzOOBBrCPName=="{{ oob_contract_name }}")]
    String   ${con}.mgmtRsOoBProv.attributes.tnVzOOBBrCPName   {{ oob_contract_name }}

{% endfor %}

{% endfor %}
