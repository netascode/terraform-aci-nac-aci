*** Settings ***
Documentation   Verify TACACS Provider
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get TACACS Providers
    GET   "/api/v1/auth/providers/tacacs"

{% for tacacs in mso.tacacs_providers | default([]) %}

Verify TACACS Provider {{ tacacs.hostname_ip }}
    ${prov}=   Set Variable   $..tacacsProviders[?(@.host=='{{ tacacs.hostname_ip }}')]
    String   ${prov}.host   {{ tacacs.hostname_ip }}
    String   ${prov}.description   {{ tacacs.description | default() }}
    Integer   ${prov}.port   {{ tacacs.port | default(defaults.mso.tacacs_providers.port) }}
    String   ${prov}.protocol   {{ tacacs.protocol | default(defaults.mso.tacacs_providers.protocol) }}
    Integer   ${prov}.timeoutInSeconds   {{ tacacs.timeout | default(defaults.mso.tacacs_providers.timeout) }}
    Integer   ${prov}.retries   {{ tacacs.retries | default(defaults.mso.tacacs_providers.retries) }}

{% endfor %}
