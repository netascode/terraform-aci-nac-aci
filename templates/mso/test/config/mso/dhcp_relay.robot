*** Settings ***
Documentation   Verify DHCP Relay Policy
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
Get DHCP Relay Policies
    GET   "/api/v1/policies/dhcp/relay"

{% for pol in mso.policies.dhcp_relays | default([]) %}
{% set pol_name = pol.name ~ defaults.mso.policies.dhcp_relays.name_suffix %}

Verify DHCP Relay Policy {{ pol_name }}
    ${pol}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')]
    String   ${pol}.name   {{ pol_name }}
    String   ${pol}.desc   {{ pol.description | default() }}
    String   ${pol}.tenantId   %%tenants%{{ pol.tenant }}%%

{% for prov in pol.providers | default([]) %}

Verify DHCP Relay Policy {{ pol_name }} Provider {{ prov.ip }}
    ${prov}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')].provider[?(@.addr=='{{ prov.ip }}')]
    String   ${prov}.addr   {{ prov.ip }}
{% if prov.endpoint_group is defined %}
{% set ap_name = prov.application_profile ~ defaults.mso.schemas.templates.application_profiles.name_suffix %}
{% set epg_name = prov.endpoint_group ~ defaults.mso.schemas.templates.application_profiles.endpoint_groups.name_suffix %}
    String   ${prov}.epgRef   /schemas/%%schemas%{{ prov.schema }}%%/templates/{{ prov.template }}/anps/{{ ap_name }}/epgs/{{ epg_name }}
{% else %}
{% set ext_epg_name = prov.external_endpoint_group ~ defaults.mso.schemas.templates.external_endpoint_groups.name_suffix %}
    String   ${prov}.externalEpgRef   /schemas/%%schemas%{{ prov.schema }}%%/templates/{{ prov.template }}/externalEpgs/{{ ext_epg_name }}
{% endif %}
    String   ${prov}.tenantId   %%tenants%{{ prov.tenant }}%%

{% endfor %}

{% endfor %}
