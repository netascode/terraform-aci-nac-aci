*** Settings ***
Documentation   Verify AAA Settings
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify AAA Settings
    ${r}=   GET On Session   apic   /api/mo/uni/userext/authrealm.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..aaaAuthRealm.attributes.defRolePolicy   {{ apic.fabric_policies.aaa.remote_user_login_policy | default(defaults.apic.fabric_policies.aaa.remote_user_login_policy) }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaDefaultAuth.attributes.fallbackCheck   {% if apic.fabric_policies.aaa.default_fallback_check | default(defaults.apic.fabric_policies.aaa.default_fallback_check) | cisco.aac.aac_bool("enabled") == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    $..aaaDefaultAuth.attributes.realm   {{ apic.fabric_policies.aaa.default_realm | default(defaults.apic.fabric_policies.aaa.default_realm) }}
{% if apic.fabric_policies.aaa.default_realm | default(defaults.apic.fabric_policies.aaa.default_realm) == "tacacs" %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaDefaultAuth.attributes.providerGroup   {{ apic.fabric_policies.aaa.default_login_domain | default(defaults.apic.fabric_policies.aaa.default_login_domain) }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaConsoleAuth.attributes.realm   {{ apic.fabric_policies.aaa.console_realm | default(defaults.apic.fabric_policies.aaa.console_realm) }}
{% if apic.fabric_policies.aaa.console_realm | default(defaults.apic.fabric_policies.aaa.console_realm) == "tacacs" %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaConsoleAuth.attributes.providerGroup   {{ apic.fabric_policies.aaa.console_login_domain | default(defaults.apic.fabric_policies.aaa.console_login_domain) }}
{% endif %}
