*** Settings ***
Documentation   Verify Tenant
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../apic_common.resource

*** Test Cases ***
{% for tenant in apic.tenants | default([]) %}

Verify Tenant {{ tenant.name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..fvTenant.attributes.name   {{ tenant.name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTenant.attributes.nameAlias   {{ tenant.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTenant.attributes.descr   {{ tenant.description | default() }}

Verify Tenant {{ tenant.name }} Security Domains 
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}.json    params=query-target=children&target-subtree-class=aaaDomainRef
{% for sd in tenant.security_domains | default([]) %}
    Should Be Equal Value Json String   ${r.json()}   $..imdata[?(@.aaaDomainRef.attributes.name=='{{ sd }}')].aaaDomainRef.attributes.name   {{ sd }}
{% endfor %}

{% endfor %}
