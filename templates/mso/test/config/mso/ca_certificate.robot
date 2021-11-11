*** Settings ***
Documentation   Verify CA Certificates
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get CA Certificates
    GET   "/api/v1/auth/security/certificates"

{% for cert in mso.ca_certificates | default([]) %}

Verify CA Certificate {{ cert.name }}
    ${cert}=   Set Variable   $..caCertificates[?(@.name=='{{ cert.name }}')]
    String   ${cert}.name   {{ cert.name }}
    String   ${cert}.description   {{ cert.description | default() }}

{% endfor %}
