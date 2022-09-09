*** Settings ***
Documentation   Verify CA Certificates
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get CA Certificates
    ${r}=   GET On Session   mso   /api/v1/auth/security/certificates
    Set Suite Variable   ${r}

{% for cert in mso.ca_certificates | default([]) %}

Verify CA Certificate {{ cert.name }}
    ${cert}=   Set Variable   $..caCertificates[?(@.name=='{{ cert.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${cert}.name   {{ cert.name }}
    Should Be Equal Value Json String   ${r.json()}   ${cert}.description   {{ cert.description | default() }}

{% endfor %}
