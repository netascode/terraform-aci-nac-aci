*** Settings ***
Documentation   Verify Login Domain
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource
   
*** Test Cases ***
Get Login Domains
    ${r}=   GET On Session   mso   /api/v1/auth/domains
    Set Suite Variable   ${r}

{% for domain in mso.login_domains | default([]) %}

Verify Login Domain {{ domain.name }}
    ${login_domain}=   Set Variable   $..domains[?(@.name=='{{ domain.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${login_domain}.description   {{ domain.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${login_domain}.name   {{ domain.name }}
    Should Be Equal Value Json String   ${r.json()}   ${login_domain}.realm   {{ domain.realm }}
    Should Be Equal Value Json String   ${r.json()}   ${login_domain}.status   {{ domain.status | default(defaults.mso.login_domains.status) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${login_domain}.isDefault   {% if domain.default | default(defaults.mso.login_domains.default) == True %}true{% else %}false{% endif %} 

{% if domain.realm == 'tacacs' %}
{% for provider in domain.providers | default([]) %}

Verify Login Domain {{ domain.name }} TACACS Provider {{ provider.hostname_ip }}
    ${provider}=   Set Variable   $..domains[?(@.name=='{{ domain.name }}')].providerAssociations[?(@.providerId=='%%auth/providers/{{ domain.realm }}%{{ provider.hostname_ip }}%%')]
    Should Be Equal Value Json String   ${r.json()}   ${provider}.providerId   %%auth/providers/{{ domain.realm }}%{{ provider.hostname_ip }}%%
    Should Be Equal Value Json Integer   ${r.json()}   ${provider}.priority   {{ provider.priority | default(defaults.mso.login_domains.providers.priority) }}

{% endfor %}
{% endif %}

{% endfor %}
