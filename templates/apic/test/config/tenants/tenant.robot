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

{% endfor %}
