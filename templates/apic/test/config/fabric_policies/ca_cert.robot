*** Settings ***
Documentation   Verify CA Certificate
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for ca in apic.fabric_policies.aaa.ca_certificates | default([]) %}
{% set ca_name = ca.name ~ defaults.apic.fabric_policies.aaa.ca_certificates.name_suffix %}

Verify CA Certificate {{ ca_name }}
    ${r}=   GET On Session   apic   api/node/mo/uni/userext/pkiext/tp-{{ ca_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..pkiTP.attributes.name   {{ ca_name }}
    Should Be Equal Value Json String   ${r.json()}    $..pkiTP.attributes.descr   {{ ca.description | default() }}

{% endfor %}
