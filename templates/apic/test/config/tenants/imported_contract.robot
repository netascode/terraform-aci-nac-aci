*** Settings ***
Documentation   Verify Imported Contract
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for con in tenant.imported_contracts | default([]) %}
{% set imported_con_name = con.name ~ defaults.apic.tenants.imported_contracts.name_suffix %}
{% set con_name = con.contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Imported Contract {{ imported_con_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/cif-{{ imported_con_name }}.json?rsp-subtree=full"
    String   $..vzCPIf.attributes.name   {{ imported_con_name }}
    String   $..vzCPIf.children..vzRsIf.attributes.tDn   "uni/tn-{{ con.tenant }}/brc-{{ con_name }}"

{% endfor %}
