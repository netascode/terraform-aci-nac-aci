*** Settings ***
Documentation   Verify Tenant
Suite Setup     Login NDO
Default Tags    ndo   config   day2
Resource        ../../ndo_common.resource

*** Test Cases ***
Get Tenants
    ${r}=   GET On Session   ndo   /api/v1/tenants
    Set Suite Variable   ${r}

{% for tenant in ndo.tenants | default([]) %}

Verify Tenant {{ tenant.name }}
    ${tenant}=   Set Variable   $..tenants[?(@.name=='{{ tenant.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${tenant}.name   {{ tenant.name }}
    Should Be Equal Value Json String   ${r.json()}   ${tenant}.displayName   {{ tenant.name }}
    Should Be Equal Value Json String   ${r.json()}   ${tenant}.description   {{ tenant.description | default() }}

{% for site in tenant.sites | default([]) %}

Verify Tenant {{ tenant.name }} Site {{ site.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${site}=   Set Variable   $..tenants[?(@.name=='{{ tenant.name }}')].siteAssociations[?(@.siteId=='${site_id}')]
    Should Be Equal Value Json String   ${r.json()}   ${site}.siteId   ${site_id}
{% if site.azure_subscription_id is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${site}.cloudAccount   uni/tn-{{ site.azure_shared_tenant | default(tenant.name) }}/act-[{{ site.azure_subscription_id }}]-vendor-azure
{% if site.azure_shared_tenant is not defined %}
    Should Be Equal Value Json String   ${r.json()}   ${site}..cloudSubscriptionId   {{ site.azure_subscription_id }}   
{% endif %}
{% endif %}

{% endfor %}

{% for user in tenant.users | default([]) %}

Verify Tenant {{ tenant.name }} User {{ user.name }}
    ${user_id}=   Ndo Lookup   users   {{ user.name }}
    ${user}=   Set Variable   $..tenants[?(@.name=='{{ tenant.name }}')].userAssociations[?(@.userId=='${user_id}')]
    Should Be Equal Value Json String   ${r.json()}   ${user}.userId   ${user_id}

{% endfor %}

{% endfor %}
