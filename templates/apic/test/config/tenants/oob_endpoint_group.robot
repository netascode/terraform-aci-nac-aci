{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify OOB Endpoint Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for epg in tenant.oob_endpoint_groups | default([]) %}
{% if epg.name is not defined %}
{% set epg_name = defaults.apic.tenants.oob_endpoint_groups.name %}
{% else %}
{% set epg_name = epg.name ~ defaults.apic.tenants.oob_endpoint_groups.name_suffix %}
{% endif %}

Verify OOB Endpoint Group {{ epg_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-mgmt/mgmtp-default/oob-{{ epg_name }}.json   params=rsp-subtree=full  
    Set Suite Variable   ${r}  
    Should Be Equal Value Json String   ${r.json()}   $..mgmtOoB.attributes.name   {{ epg_name }}

{% for oob_contract in epg.oob_contracts.providers | default([]) %}
{% set oob_contract_name = oob_contract ~ defaults.apic.tenants.oob_contracts.name_suffix %}

Verify OOB Endpoint Group {{ epg_name }} Contract Provider {{ oob_contract_name }}
    ${con}=   Set Variable   $..mgmtOoB.children[?(@.mgmtRsOoBProv.attributes.tnVzOOBBrCPName=="{{ oob_contract_name }}")]
    Should Be Equal Value Json String   ${r.json()}   ${con}.mgmtRsOoBProv.attributes.tnVzOOBBrCPName   {{ oob_contract_name }}

{% endfor %}

{% for prefix in epg.static_routes | default([]) %}
Verify Out-of-Band Endpoint Group {{ epg_name }} Static Route {{ prefix }}
    ${con}=   Set Variable   $..mgmtInB.children[?(@.mgmtStaticRoute.attributes.prefix=='{{ prefix }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..mgmtStaticRoute.attributes.prefix   {{ prefix }}
{% endfor %} 

{% endfor %}
