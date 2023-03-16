{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Inband Endpoint Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for epg in tenant.inb_endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.apic.tenants.inb_endpoint_groups.name_suffix %}
{% set bd_name = epg.bridge_domain ~ defaults.apic.tenants.bridge_domains.name_suffix %}

Verify Inband Endpoint Group {{ epg_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-mgmt/mgmtp-default/inb-{{ epg_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..mgmtInB.attributes.name   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   $..mgmtInB.attributes.encap   vlan-{{ epg.vlan }}
    Should Be Equal Value Json String   ${r.json()}   $..mgmtRsMgmtBD.attributes.tnFvBDName   {{ bd_name }}

{% for contract in epg.contracts.providers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Inband Endpoint Group {{ epg_name }} Contract Provider {{ contract_name }}
    ${con}=   Set Variable   $..mgmtInB.children[?(@.fvRsProv.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsProv.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Inband Endpoint Group {{ epg_name }} Contract consumers {{ contract_name }}
    ${con}=   Set Variable   $..mgmtInB.children[?(@.fvRsCons.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsCons.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.imported_consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.imported_consumers.name_suffix %}

Verify Inband Endpoint Group {{ epg_name }} Imported Contract {{ contract_name }}
    ${con}=   Set Variable   $..mgmtInB.children[?(@.fvRsConsIf.attributes.tnVzCPIfName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsConsIf.attributes.tnVzCPIfName   {{ contract_name }}

{% endfor %}

{% for prefix in epg.static_routes | default([]) %}
Verify Inband Endpoint Group {{ epg_name }} Static Route {{ prefix }}
    ${con}=   Set Variable   $..mgmtInB.children[?(@.mgmtStaticRoute.attributes.prefix=='{{ prefix }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..mgmtStaticRoute.attributes.prefix   {{ prefix }}
{% endfor %} 

{% endfor %}
