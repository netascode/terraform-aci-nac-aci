*** Settings ***
Documentation   Verify Login Domain
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for login_domain in apic.fabric_policies.aaa.login_domains | default([]) %}

Verify Login Domain {{ login_domain.name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/userext/logindomain-{{ login_domain.name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..aaaLoginDomain.attributes.descr   {{ login_domain.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaLoginDomain.attributes.name   {{ login_domain.name }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaDomainAuth.attributes.realm  {{ login_domain.realm }}

{% if login_domain.realm == 'tacacs' %}
{% for prov in login_domain.tacacs_providers | default([]) %}

Verify Login Domain {{ login_domain.name }} TACACS Provider {{ prov.hostname_ip }}
    ${r}=   GET On Session   apic   api/node/mo/uni/userext/tacacsext/tacacsplusprovidergroup-{{ login_domain.name }}/providerref-{{ prov.hostname_ip }}.json
    Should Be Equal Value Json String   ${r.json()}    $..aaaProviderRef.attributes.name   {{ prov.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaProviderRef.attributes.order   {{ prov.priority | default(defaults.apic.fabric_policies.aaa.login_domains.tacacs_providers.priority) }}

{% endfor %}
{% endif %}

{% endfor %}
