*** Settings ***
Documentation   Verify CA Certificate
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for ca in apic.fabric_policies.aaa.ca_certificates | default([]) %}
{% set ca_name = ca.name ~ defaults.apic.fabric_policies.aaa.ca_certificates.name_suffix %}

Verify CA Certificate {{ ca_name }}
    GET   "api/node/mo/uni/userext/pkiext/tp-{{ ca_name }}.json"
    String   $..pkiTP.attributes.name   {{ ca_name }}
    String   $..pkiTP.attributes.descr   {{ ca.description | default() }}

{% endfor %}
