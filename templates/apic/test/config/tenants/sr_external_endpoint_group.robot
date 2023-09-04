{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify SR MPLS External Endpoint Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.sr_mpls_l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.sr_mpls_l3outs.name_suffix %}

Get SR MPLS L3out {{ l3out_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}.json   params=rsp-subtree=full&rsp-prop-include=config-only
    Set Suite Variable   ${r}

{%- if tenant.name != 'infra' %}

{% for epg in l3out.external_endpoint_groups | default([]) %}
{% set eepg_name = epg.name ~ defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} External EPG {{ eepg_name }}
    ${eepg}=   Set Variable   $..l3extOut.children[?(@.l3extInstP.attributes.name=='{{ eepg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${eepg}..l3extInstP.attributes.name   {{ eepg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${eepg}..l3extInstP.attributes.nameAlias   {{ epg.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${eepg}..l3extInstP.attributes.descr   {{ epg.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${eepg}..l3extInstP.attributes.prefGrMemb   {{ epg.preferred_group | default(defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.preferred_group) | cisco.aac.aac_bool("include") }}

{% for subnet in epg.subnets | default([]) %}
{% set scope = ["import-security"] %}
{% if subnet.route_leaking | default(defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.subnets.route_leaking) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("shared-rtctrl")] %}{% endif %}
{% if subnet.security | default(defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.subnets.security) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("shared-security")] %}{% endif %}
{% set agg = [] %}
{% if subnet.aggregate_shared_route_control | default(defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.subnets.aggregate_shared_route_control) | cisco.aac.aac_bool("yes") == "yes" %}{% set agg = agg + [("shared-rtctrl")] %}{% endif %}

Verify SR MPLS L3out {{ l3out_name }} External EPG {{ eepg_name }} Subnet {{ subnet.prefix }}
    ${eepg}=   Set Variable   $..l3extOut.children[?(@.l3extInstP.attributes.name=='{{ eepg_name }}')]
    ${subnet}=   Set Variable   ${eepg}..l3extInstP.children[?(@.l3extSubnet.attributes.ip=='{{ subnet.prefix }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..l3extSubnet.attributes.aggregate   {{ agg | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..l3extSubnet.attributes.ip   {{ subnet.prefix }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..l3extSubnet.attributes.name   {{ subnet.name | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..l3extSubnet.attributes.scope   {{ scope | join(',') }}

{% endfor %}

{% for contract in epg.contracts.providers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} External EPG {{ eepg_name }} Provided Contract {{ contract_name }}
    ${eepg}=   Set Variable   $..l3extOut.children[?(@.l3extInstP.attributes.name=='{{ eepg_name }}')]
    ${contract}=   Set Variable   ${eepg}..l3extInstP.children[?(@.fvRsProv.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${contract}..fvRsProv.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify L3out {{ l3out_name }} External EPG {{ eepg_name }} Consumed Contract {{ contract_name }}
    ${eepg}=   Set Variable   $..l3extOut.children[?(@.l3extInstP.attributes.name=='{{ eepg_name }}')]
    ${contract}=   Set Variable   ${eepg}..l3extInstP.children[?(@.fvRsCons.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${contract}..fvRsCons.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.imported_consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.imported_contracts.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} External EPG {{ eepg_name }} Consumed Contract {{ contract_name }}
    ${eepg}=   Set Variable   $..l3extOut.children[?(@.l3extInstP.attributes.name=='{{ eepg_name }}')]
    ${contract}=   Set Variable   ${eepg}..l3extInstP.children[?(@.fvRsConsIf.attributes.tnVzCPIfName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${contract}..fvRsConsIf.attributes.tnVzCPIfName   {{ contract_name }}

{% endfor %}

{% endfor %}

{% endif %}

{% endfor %}
