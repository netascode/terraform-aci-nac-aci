*** Settings ***
Documentation   Verify DHCP Relay Policy
Suite Setup     Login NDO
Default Tags    ndo   config   day2
Resource        ../../ndo_common.resource

*** Test Cases ***
Get DHCP Relay Policies
    ${r}=   GET On Session   ndo   /api/v1/policies/dhcp/relay
    Set Suite Variable   ${r}

{% for pol in ndo.policies.dhcp_relays | default([]) %}
{% set pol_name = pol.name ~ defaults.ndo.policies.dhcp_relays.name_suffix %}

Verify DHCP Relay Policy {{ pol_name }}
    ${pol}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pol}.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.desc   {{ pol.description | default() }}
    ${tenant_id}=   NDO Lookup   tenants   {{ pol.tenant }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.tenantId   ${tenant_id}

{% for prov in pol.providers | default([]) %}

Verify DHCP Relay Policy {{ pol_name }} Provider {{ prov.ip }}
    ${prov}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')].provider[?(@.addr=='{{ prov.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${prov}.addr   {{ prov.ip }}
    ${schema_id}=   NDO Lookup   schemas   {{ prov.schema }}
{% if prov.endpoint_group is defined %}
{% set ap_name = prov.application_profile ~ defaults.ndo.schemas.templates.application_profiles.name_suffix %}
{% set epg_name = prov.endpoint_group ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.epgRef   /schemas/${schema_id}/templates/{{ prov.template }}/anps/{{ ap_name }}/epgs/{{ epg_name }}
{% else %}
{% set ext_epg_name = prov.external_endpoint_group ~ defaults.ndo.schemas.templates.external_endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.externalEpgRef   /schemas/${schema_id}/templates/{{ prov.template }}/externalEpgs/{{ ext_epg_name }}
{% endif %}
    ${tenant_id}=   NDO Lookup   tenants   {{ prov.tenant }}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.tenantId   ${tenant_id}

{% endfor %}

{% endfor %}
