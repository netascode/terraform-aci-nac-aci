*** Settings ***
Documentation   Verify Login Domain
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies   ldap
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
{% elif login_domain.realm == 'ldap' %}

Verify Login Domain {{ login_domain.name }} LDAP Provider Group
    ${r}=   GET On Session   apic   api/node/mo/uni/userext/ldapext/ldapprovidergroup-{{ login_domain.name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..aaaLdapProviderGroup.attributes.authChoice   {{ login_domain.auth_choice | default(defaults.apic.fabric_policies.aaa.login_domains.auth_choice) }}
{% if login_domain.auth_choice == 'LdapGroupMap' and login_domain.ldap_group_map is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaLdapProviderGroup.attributes.ldapGroupMapRef   {{ login_domain.ldap_group_map }}
{% endif %}

{% for prov in login_domain.ldap.providers | default([]) %}

Verify Login Domain {{ login_domain.name }} LDAP Provider {{ prov.hostname_ip }}
    ${r}=   GET On Session   apic   api/node/mo/uni/userext/ldapext/ldapprovidergroup-{{ login_domain.name }}/providerref-{{ prov.hostname_ip }}.json
    Should Be Equal Value Json String   ${r.json()}    $..aaaProviderRef.attributes.name   {{ prov.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaProviderRef.attributes.order   {{ prov.priority | default(defaults.apic.fabric_policies.aaa.login_domains.tacacs_providers.priority) }}

{% endfor %}

{% endif %}

{% endfor %}
