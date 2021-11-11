*** Settings ***
Documentation   Verify Login Domain
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource
   
*** Test Cases ***
Get Login Domains
    GET   "/api/v1/auth/domains"

{% for domain in mso.login_domains | default([]) %}

Verify Login Domain {{ domain.name }}
    ${login_domain}=   Set Variable   $..domains[?(@.name=='{{ domain.name }}')]
    String   ${login_domain}.description   {{ domain.description | default() }}
    String   ${login_domain}.name   {{ domain.name }}
    String   ${login_domain}.realm   {{ domain.realm }}
    String   ${login_domain}.status   {{ domain.status | default(defaults.mso.login_domains.status) }}
    Boolean   ${login_domain}.isDefault   {% if domain.default | default(defaults.mso.login_domains.default) == True %}true{% else %}false{% endif %} 

{% if domain.realm == 'tacacs' %}
{% for provider in domain.providers | default([]) %}

Verify Login Domain {{ domain.name }} TACACS Provider {{ provider.hostname_ip }}
    ${provider}=   Set Variable   $..domains[?(@.name=='{{ domain.name }}')].providerAssociations[?(@.providerId=='%%auth/providers/{{ domain.realm }}%{{ provider.hostname_ip }}%%')]
    String   ${provider}.providerId   %%auth/providers/{{ domain.realm }}%{{ provider.hostname_ip }}%%
    Integer   ${provider}.priority   {{ provider.priority | default(defaults.mso.login_domains.providers.priority) }}

{% endfor %}
{% endif %}

{% endfor %}
