*** Settings ***
Documentation   Verify DHCP Option Policy
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
Get DHCP Option Policies
    GET   "/api/v1/policies/dhcp/option"

{% for pol in mso.policies.dhcp_options | default([]) %}
{% set pol_name = pol.name ~ defaults.mso.policies.dhcp_options.name_suffix %}

Verify DHCP Option Policy {{ pol_name }}
    ${pol}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')]
    String   ${pol}.name   {{ pol_name }}
    String   ${pol}.desc   {{ pol.description | default() }}
    String   ${pol}.tenantId   %%tenants%{{ pol.tenant }}%%

{% for opt in pol.options | default([]) %}
{% set opt_name = opt.name ~ defaults.mso.policies.dhcp_options.options.name_suffix %}

Verify DHCP Option Policy {{ pol_name }} Option {{ opt_name }}
    ${opt}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')].dhcpOption[?(@.name=='{{ opt_name }}')]
    String   ${opt}.name   {{ opt_name }}
    String   ${opt}.id   {{ opt.id | default(defaults.mso.schemas.templates.policies.dhcp_options.options.id) }}
    String   ${opt}.data   {{ opt.data | default() }}

{% endfor %}

{% endfor %}
