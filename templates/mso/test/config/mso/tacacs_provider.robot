*** Settings ***
Documentation   Verify TACACS Provider
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get TACACS Providers
    ${r}=   GET On Session   mso   /api/v1/auth/providers/tacacs
    Set Suite Variable   ${r}

{% for tacacs in mso.tacacs_providers | default([]) %}

Verify TACACS Provider {{ tacacs.hostname_ip }}
    ${prov}=   Set Variable   $..tacacsProviders[?(@.host=='{{ tacacs.hostname_ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${prov}.host   {{ tacacs.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.description   {{ tacacs.description | default() }}
    Should Be Equal Value Json Integer   ${r.json()}   ${prov}.port   {{ tacacs.port | default(defaults.mso.tacacs_providers.port) }}
    Should Be Equal Value Json String   ${r.json()}   ${prov}.protocol   {{ tacacs.protocol | default(defaults.mso.tacacs_providers.protocol) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${prov}.timeoutInSeconds   {{ tacacs.timeout | default(defaults.mso.tacacs_providers.timeout) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${prov}.retries   {{ tacacs.retries | default(defaults.mso.tacacs_providers.retries) }}

{% endfor %}
