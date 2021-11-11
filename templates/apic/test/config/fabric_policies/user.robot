*** Settings ***
Documentation   Verify User
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for user in apic.fabric_policies.aaa.users | default([]) %}
Verify User {{ user.username }}
    GET   "/api/mo/uni/userext/user-{{ user.username }}.json?rsp-subtree=full"
    String   $..aaaUser.attributes.accountStatus   {{ user.status | default(defaults.apic.fabric_policies.aaa.users.status) }}
    String   $..aaaUser.attributes.certAttribute   {{ user.certificate_name | default() }}
    String   $..aaaUser.attributes.descr   {{ user.description | default() }}
    String   $..aaaUser.attributes.email   {{ user.email | default() }}
    String   $..aaaUser.attributes.expires   {{ user.expires | default(defaults.apic.fabric_policies.aaa.users.expires) }}
{% if user.expires | default(defaults.apic.fabric_policies.aaa.users.expires) == 'yes' %}
    String   $..aaaUser.attributes.expiration   {{ user.expire_date | default() }}
{% endif %}
    String   $..aaaUser.attributes.firstName   {{ user.first_name | default() }}
    String   $..aaaUser.attributes.lastName   {{ user.last_name | default() }}
    String   $..aaaUser.attributes.phone   {{ user.phone | default() }}

{% for domain in user.domains | default([]) %}

Verify User {{ user.username }} Domain {{ domain.name }}
    ${domain}=   Set Variable   $..aaaUser.children[?(@.aaaUserDomain.attributes.name=='{{ domain.name }}')]
    String   ${domain}..aaaUserDomain.attributes.name   {{ domain.name }}

{% for role in domain.roles | default([]) %}

Verify User {{ user.username }} Domain {{ domain.name }} Role {{ role.name }}
    ${domain}=   Set Variable   $..aaaUser.children[?(@.aaaUserDomain.attributes.name=='{{ domain.name }}')]
    ${role}=   Set Variable   $..aaaUserDomain.children[?(@.aaaUserRole.attributes.name=='{{ role.name }}')]
    String   ${role}..aaaUserRole.attributes.name   {{ role.name }}
    String   ${role}..aaaUserRole.attributes.privType   {% if role.privilege_type | default(defaults.apic.fabric_policies.aaa.users.domains.roles.privilege_type) == "write" %}writePriv{% else %}readPriv{% endif %}

{% endfor %}

{% endfor %}

{% for cert in user.certificates | default([]) %}

Verify User {{ user.username }} Certificate {{ cert.name }}
    ${cert}=   Set Variable   $..aaaUser.children[?(@.aaaUserCert.attributes.name=='{{ cert.name }}')]
    String   ${cert}..aaaUserCert.attributes.name   {{ cert.name }}

{% endfor %}

{% for key in user.ssh_keys | default([]) %}

Verify User {{ user.username }} SSH Keys {{ key.name }}
    ${cert}=   Set Variable   $..aaaUser.children[?(@.aaaSshAuth.attributes.name=='{{ key.name }}')]
    String   ${cert}..aaaSshAuth.attributes.name   {{ key.name }}

{% endfor %}

{% endfor %}
