*** Settings ***
Documentation   Verify User
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for user in apic.fabric_policies.aaa.users | default([]) %}
Verify User {{ user.username }}
    ${r}=   GET On Session   apic   /api/mo/uni/userext/user-{{ user.username }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.accountStatus   {{ user.status | default(defaults.apic.fabric_policies.aaa.users.status) }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.certAttribute   {{ user.certificate_name | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.descr   {{ user.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.email   {{ user.email | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.expires   {{ user.expires | default(defaults.apic.fabric_policies.aaa.users.expires) | cisco.aac.aac_bool("yes") }}
{% if user.expires | default(defaults.apic.fabric_policies.aaa.users.expires) | cisco.aac.aac_bool("yes") == 'yes' %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.expiration   {{ user.expire_date | default() }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.firstName   {{ user.first_name | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.lastName   {{ user.last_name | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaUser.attributes.phone   {{ user.phone | default() }}

{% for domain in user.domains | default([]) %}

Verify User {{ user.username }} Domain {{ domain.name }}
    ${domain}=   Set Variable   $..aaaUser.children[?(@.aaaUserDomain.attributes.name=='{{ domain.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${domain}..aaaUserDomain.attributes.name   {{ domain.name }}

{% for role in domain.roles | default([]) %}

Verify User {{ user.username }} Domain {{ domain.name }} Role {{ role.name }}
    ${domain}=   Set Variable   $..aaaUser.children[?(@.aaaUserDomain.attributes.name=='{{ domain.name }}')]
    ${role}=   Set Variable   $..aaaUserDomain.children[?(@.aaaUserRole.attributes.name=='{{ role.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${role}..aaaUserRole.attributes.name   {{ role.name }}
    Should Be Equal Value Json String   ${r.json()}    ${role}..aaaUserRole.attributes.privType   {% if role.privilege_type | default(defaults.apic.fabric_policies.aaa.users.domains.roles.privilege_type) == "write" %}writePriv{% else %}readPriv{% endif %}

{% endfor %}

{% endfor %}

{% for cert in user.certificates | default([]) %}

Verify User {{ user.username }} Certificate {{ cert.name }}
    ${cert}=   Set Variable   $..aaaUser.children[?(@.aaaUserCert.attributes.name=='{{ cert.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${cert}..aaaUserCert.attributes.name   {{ cert.name }}

{% endfor %}

{% for key in user.ssh_keys | default([]) %}

Verify User {{ user.username }} SSH Keys {{ key.name }}
    ${cert}=   Set Variable   $..aaaUser.children[?(@.aaaSshAuth.attributes.name=='{{ key.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${cert}..aaaSshAuth.attributes.name   {{ key.name }}

{% endfor %}

{% endfor %}
