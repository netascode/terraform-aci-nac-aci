*** Settings ***
Documentation   Verify CA Certificates
Suite Setup     Login NDO
Default Tags    ndo   config   day0
Resource        ../../ndo_common.resource

*** Test Cases ***
Get CA Certificates
    ${r}=   GET On Session   ndo   /api/v1/auth/security/certificates
    Set Suite Variable   ${r}

{% for cert in ndo.ca_certificates | default([]) %}

Verify CA Certificate {{ cert.name }}
    ${cert}=   Set Variable   $..caCertificates[?(@.name=='{{ cert.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${cert}.name   {{ cert.name }}
    Should Be Equal Value Json String   ${r.json()}   ${cert}.description   {{ cert.description | default() }}

{% endfor %}
