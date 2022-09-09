*** Settings ***
Documentation   Verify DHCP Option Policy
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
Get DHCP Option Policies
    ${r}=   GET On Session   mso   /api/v1/policies/dhcp/option
    Set Suite Variable   ${r}

{% for pol in mso.policies.dhcp_options | default([]) %}
{% set pol_name = pol.name ~ defaults.mso.policies.dhcp_options.name_suffix %}

Verify DHCP Option Policy {{ pol_name }}
    ${pol}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pol}.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.desc   {{ pol.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.tenantId   %%tenants%{{ pol.tenant }}%%

{% for opt in pol.options | default([]) %}
{% set opt_name = opt.name ~ defaults.mso.policies.dhcp_options.options.name_suffix %}

Verify DHCP Option Policy {{ pol_name }} Option {{ opt_name }}
    ${opt}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')].dhcpOption[?(@.name=='{{ opt_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${opt}.name   {{ opt_name }}
    Should Be Equal Value Json String   ${r.json()}   ${opt}.id   {{ opt.id | default(defaults.mso.schemas.templates.policies.dhcp_options.options.id) }}
    Should Be Equal Value Json String   ${r.json()}   ${opt}.data   {{ opt.data | default() }}

{% endfor %}

{% endfor %}
