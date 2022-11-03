{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Endpoint Security Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ap in tenant.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% for esg in ap.endpoint_security_groups | default([]) %}
{% set esg_name = esg.name ~ defaults.apic.tenants.application_profiles.endpoint_security_groups.name_suffix %}

Verify Endpoint Security Group {{ esg_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/esg-{{ esg_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..fvESg.attributes.name   {{ esg_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvESg.attributes.descr   {{ esg.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvESg.attributes.pcEnfPref   {{ esg.intra_esg_isolation | default(defaults.apic.tenants.application_profiles.endpoint_security_groups.intra_esg_isolation) | cisco.aac.aac_bool("enforced") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvESg.attributes.prefGrMemb   {{ esg.preferred_group | default(defaults.apic.tenants.application_profiles.endpoint_security_groups.preferred_group) | cisco.aac.aac_bool("include") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvESg.attributes.shutdown   {{ esg.shutdown | default(defaults.apic.tenants.application_profiles.endpoint_security_groups.shutdown) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvRsScope.attributes.tnFvCtxName   {{ esg.vrf ~ ('' if esg.vrf in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) }}

{% for contract in esg.contracts.providers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} Contract Provider {{ contract_name }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvRsProv.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsProv.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in esg.contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} Contract Consumers {{ contract_name }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvRsCons.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsCons.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in esg.contracts.imported_consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.imported_contracts.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} Imported Contract {{ contract_name }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvRsConsIf.attributes.tnVzCPIfName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsConsIf.attributes.tnVzCPIfName   {{ contract_name }}

{% endfor %}

{% for contract in esg.contracts.intra_esgs | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} Intra-ESG Contract {{ contract_name }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvRsIntraEpg.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsIntraEpg.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for master in esg.contracts.masters | default([]) %}
{% set ap_name = master.application_profile | default(ap.name) ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set esg_name = master.endpoint_security_group ~ defaults.apic.tenants.application_profiles.endpoint_security_groups.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} Contract Master Tenant {{ tenant.name }} AP {{ ap_name }} ESG {{ esg_name }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvRsSecInherited.attributes.tDn=='uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/esg-{{ esg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsSecInherited.attributes.tDn   uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/esg-{{ esg_name }}

{% endfor %}

{% for sel in esg.tag_selectors | default([]) %}

Verify Endpoint Security Group {{ esg_name }} Tag Selector Key {{ sel.key }} Value {{ sel.value }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvTagSelector.attributes.rn=='tagselectorkey-[{{ sel.key }}]-value-[{{ sel.value }}]')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvTagSelector.attributes.descr   {{ sel.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvTagSelector.attributes.matchKey   {{ sel.key }}
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvTagSelector.attributes.matchValue   {{ sel.value }}
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvTagSelector.attributes.valueOperator   {{ sel.operator | default(defaults.apic.tenants.application_profiles.endpoint_security_groups.tag_selectors.operator) }}

{% endfor %}

{% for sel in esg.epg_selectors | default([]) %}
{% set ap_name = sel.application_profile | default(ap.name) ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set epg_name = sel.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}

Verify Endpoint Security Group {{ esg_name }} EPG Selector Tenant {{ master.tenant | default(tenant.name) }} AP {{ ap_name }} EPG {{ epg_name }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvEPgSelector.attributes.matchEpgDn=='uni/tn-{{ master.tenant | default(tenant.name) }}/ap-{{ ap_name }}/epg-{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvEPgSelector.attributes.descr   {{ sel.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvEPgSelector.attributes.matchEpgDn   uni/tn-{{ master.tenant | default(tenant.name) }}/ap-{{ ap_name }}/epg-{{ epg_name }}

{% endfor %}

{% for sel in esg.ip_subnet_selectors | default([]) %}

Verify Endpoint Security Group {{ esg_name }} IP Subnet Selector {{ sel.value }}
    ${con}=   Set Variable   $..fvESg.children[?(@.fvEPSelector.attributes.matchExpression=="ip=='{{ sel.value }}'")]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvEPSelector.attributes.descr   {{ sel.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvEPSelector.attributes.matchExpression   ip=='{{ sel.value }}'

{% endfor %}

{% endfor %}
{% endfor %}
