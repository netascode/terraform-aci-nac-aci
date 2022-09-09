*** Settings ***
Documentation   Verify DHCP Relay Policy
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
Get DHCP Relay Policies
    ${r}=   GET On Session   mso   /api/v1/policies/dhcp/relay
    Set Suite Variable   ${r}

{% for pol in mso.policies.dhcp_relays | default([]) %}
{% set pol_name = pol.name ~ defaults.mso.policies.dhcp_relays.name_suffix %}

Verify DHCP Relay Policy {{ pol_name }}
    ${pol}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pol}.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.desc   {{ pol.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.tenantId   %%tenants%{{ pol.tenant }}%%

{% for prov in pol.providers | default([]) %}

Verify DHCP Relay Policy {{ pol_name }} Provider {{ prov.ip }}
    ${prov}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')].provider[?(@.addr=='{{ prov.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${prov}.addr   {{ prov.ip }}
{% if prov.endpoint_group is defined %}
{% set ap_name = prov.application_profile ~ defaults.mso.schemas.templates.application_profiles.name_suffix %}
{% set epg_name = prov.endpoint_group ~ defaults.mso.schemas.templates.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.epgRef   /schemas/%%schemas%{{ prov.schema }}%%/templates/{{ prov.template }}/anps/{{ ap_name }}/epgs/{{ epg_name }}
{% else %}
{% set ext_epg_name = prov.external_endpoint_group ~ defaults.mso.schemas.templates.external_endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.externalEpgRef   /schemas/%%schemas%{{ prov.schema }}%%/templates/{{ prov.template }}/externalEpgs/{{ ext_epg_name }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.tenantId   %%tenants%{{ prov.tenant }}%%

{% endfor %}

{% endfor %}
