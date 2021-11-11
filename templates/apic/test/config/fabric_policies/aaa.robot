*** Settings ***
Documentation   Verify AAA Settings
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify AAA Settings
    GET   "/api/mo/uni/userext/authrealm.json?rsp-subtree=full"
    String   $..aaaAuthRealm.attributes.defRolePolicy   {{ apic.fabric_policies.aaa.remote_user_login_policy | default(defaults.apic.fabric_policies.aaa.remote_user_login_policy) }}
    String   $..aaaDefaultAuth.attributes.fallbackCheck   {% if apic.fabric_policies.aaa.default_fallback_check | default(defaults.apic.fabric_policies.aaa.default_fallback_check) == "enabled" %}true{% else %}false{% endif %} 
    String   $..aaaDefaultAuth.attributes.realm   {{ apic.fabric_policies.aaa.default_realm | default(defaults.apic.fabric_policies.aaa.default_realm) }}
{% if apic.fabric_policies.aaa.default_realm | default(defaults.apic.fabric_policies.aaa.default_realm) == "tacacs" %}
    String   $..aaaDefaultAuth.attributes.providerGroup   {{ apic.fabric_policies.aaa.default_login_domain | default(defaults.apic.fabric_policies.aaa.default_login_domain) }}
{% endif %}
    String   $..aaaConsoleAuth.attributes.realm   {{ apic.fabric_policies.aaa.console_realm | default(defaults.apic.fabric_policies.aaa.console_realm) }}
{% if apic.fabric_policies.aaa.console_realm | default(defaults.apic.fabric_policies.aaa.console_realm) == "tacacs" %}
    String   $..aaaConsoleAuth.attributes.providerGroup   {{ apic.fabric_policies.aaa.console_login_domain | default(defaults.apic.fabric_policies.aaa.console_login_domain) }}
{% endif %}
