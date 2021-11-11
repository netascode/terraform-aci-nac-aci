*** Settings ***
Documentation   Verify Tenant
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../apic_common.resource

*** Test Cases ***
{% for tenant in apic.tenants | default([]) %}

Verify Tenant {{ tenant.name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}.json"
    String   $..fvTenant.attributes.name   {{ tenant.name }}
    String   $..fvTenant.attributes.nameAlias   {{ tenant.alias  | default() }}
    String   $..fvTenant.attributes.descr   {{ tenant.description | default() }}

{% endfor %}
