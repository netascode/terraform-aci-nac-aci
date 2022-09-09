*** Settings ***
Documentation   Verify Tenant
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
Get Tenants
    ${r}=   GET On Session   mso   /api/v1/tenants
    Set Suite Variable   ${r}

{% for tenant in mso.tenants | default([]) %}

Verify Tenant {{ tenant.name }}
    ${tenant}=   Set Variable   $..tenants[?(@.name=='{{ tenant.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${tenant}.name   {{ tenant.name }}
    Should Be Equal Value Json String   ${r.json()}   ${tenant}.displayName   {{ tenant.name }}
    Should Be Equal Value Json String   ${r.json()}   ${tenant}.description   {{ tenant.description | default() }}

{% for site in tenant.sites | default([]) %}

Verify Tenant {{ tenant.name }} Site {{ site.name }}
    ${site}=   Set Variable   $..tenants[?(@.name=='{{ tenant.name }}')].siteAssociations[?(@.siteId=='%%sites%{{ site.name }}%%')]
    Should Be Equal Value Json String   ${r.json()}   ${site}.siteId   %%sites%{{ site.name }}%%
{% if site.azure_subscription_id is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${site}.cloudAccount   uni/tn-{{ site.azure_shared_tenant | default(tenant.name) }}/act-[{{ site.azure_subscription_id }}]-vendor-azure
{% if site.azure_shared_tenant is not defined %}
    Should Be Equal Value Json String   ${r.json()}   ${site}..cloudSubscriptionId   {{ site.azure_subscription_id }}   
{% endif %}
{% endif %}

{% endfor %}

{% for user in tenant.users | default([]) %}

Verify Tenant {{ tenant.name }} User {{ user }}
    ${user}=   Set Variable   $..tenants[?(@.name=='{{ tenant.name }}')].userAssociations[?(@.userId=='%%tenants/allowed-users%{{ user.domain | default('Local') }}/{{ user.name }}%%')]
    Should Be Equal Value Json String   ${r.json()}   ${user}.userId   %%tenants/allowed-users%{{ user.domain | default('Local') }}/{{ user.name }}%%

{% endfor %}

{% endfor %}
