*** Settings ***
Documentation   Verify Login Domain
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for login_domain in apic.fabric_policies.aaa.login_domains | default([]) %}

Verify Login Domain {{ login_domain.name }}
    GET   "/api/node/mo/uni/userext/logindomain-{{ login_domain.name }}.json?rsp-subtree=full"
    String   $..aaaLoginDomain.attributes.descr   {{ login_domain.description | default() }}
    String   $..aaaLoginDomain.attributes.name   {{ login_domain.name }}
    String   $..aaaDomainAuth.attributes.realm  {{ login_domain.realm }}

{% if login_domain.realm == 'tacacs' %}
{% for prov in login_domain.tacacs_providers | default([]) %}

Verify Login Domain {{ login_domain.name }} TACACS Provider {{ prov.hostname_ip }}
    GET   "api/node/mo/uni/userext/tacacsext/tacacsplusprovidergroup-{{ login_domain.name }}/providerref-{{ prov.hostname_ip }}.json"
    String   $..aaaProviderRef.attributes.name   {{ prov.hostname_ip }}
    String   $..aaaProviderRef.attributes.order   {{ prov.priority | default(defaults.apic.fabric_policies.aaa.login_domains.tacacs_providers.priority) }}

{% endfor %}
{% endif %}

{% endfor %}
