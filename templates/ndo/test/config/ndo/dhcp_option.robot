*** Settings ***
Documentation   Verify DHCP Option Policy
Suite Setup     Login NDO
Default Tags    ndo   config   day2
Resource        ../../ndo_common.resource

*** Test Cases ***
Get DHCP Option Policies
    ${r}=   GET On Session   ndo   /api/v1/policies/dhcp/option
    Set Suite Variable   ${r}

{% for pol in ndo.policies.dhcp_options | default([]) %}
{% set pol_name = pol.name ~ defaults.ndo.policies.dhcp_options.name_suffix %}

Verify DHCP Option Policy {{ pol_name }}
    ${pol}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pol}.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.desc   {{ pol.description | default() }}
    ${tenant_id}=   NDO Lookup   tenants   {{ pol.tenant }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.tenantId   ${tenant_id}

{% for opt in pol.options | default([]) %}
{% set opt_name = opt.name ~ defaults.ndo.policies.dhcp_options.options.name_suffix %}

Verify DHCP Option Policy {{ pol_name }} Option {{ opt_name }}
    ${opt}=   Set Variable   $..DhcpRelayPolicies[?(@.name=='{{ pol_name }}')].dhcpOption[?(@.name=='{{ opt_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${opt}.name   {{ opt_name }}
    Should Be Equal Value Json String   ${r.json()}   ${opt}.id   {{ opt.id | default(defaults.ndo.schemas.templates.policies.dhcp_options.options.id) }}
    Should Be Equal Value Json String   ${r.json()}   ${opt}.data   {{ opt.data | default() }}

{% endfor %}

{% endfor %}
