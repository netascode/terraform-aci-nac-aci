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

Verify AAA Security Domains
    ${r}=   GET On Session   apic   /api/node/class/aaaDomain.json
{% for sd in apic.fabric_policies.aaa.security_domains| default([]) %}
    Should Be Equal Value Json String   ${r.json()}   $..imdata[?(@.aaaDomain.attributes.name=='{{ sd.name }}')].aaaDomain.attributes.name   {{ sd.name }}
    Should Be Equal Value Json String   ${r.json()}   $..imdata[?(@.aaaDomain.attributes.name=='{{ sd.name }}')].aaaDomain.attributes.descr   {{ sd.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..imdata[?(@.aaaDomain.attributes.name=='{{ sd.name }}')].aaaDomain.attributes.restrictedRbacDomain   {% if sd.restricted_rbac_domain | default(defaults.apic.fabric_policies.aaa.security_domains.restricted_rbac_domain) %}yes{% else %}no{% endif %} 
{% endfor %}

Verify AAA Password Strength Check
    ${r}=   GET On Session   apic   /api/mo/uni/userext.json
    Should Be Equal Value Json String   ${r.json()}    $..aaaUserEp.attributes.pwdStrengthCheck   {{ apic.fabric_policies.aaa.management_settings.password_strength_check | default(defaults.apic.fabric_policies.aaa.management_settings.password_strength_check) | cisco.aac.aac_bool("yes") }} 

Verify AAA Web Token Settings
    ${r}=   GET On Session   apic   /api/mo/uni/userext/pkiext/webtokendata.json
    Should Be Equal Value Json String   ${r.json()}    $..pkiWebTokenData.attributes.webtokenTimeoutSeconds   {{ apic.fabric_policies.aaa.management_settings.web_token_timeout | default(defaults.apic.fabric_policies.aaa.management_settings.web_token_timeout) }}
    Should Be Equal Value Json String   ${r.json()}    $..pkiWebTokenData.attributes.maximumValidityPeriod   {{ apic.fabric_policies.aaa.management_settings.web_token_max_validity | default(defaults.apic.fabric_policies.aaa.management_settings.web_token_max_validity) }}
    Should Be Equal Value Json String   ${r.json()}    $..pkiWebTokenData.attributes.uiIdleTimeoutSeconds   {{ apic.fabric_policies.aaa.management_settings.web_session_idle_timeout | default(defaults.apic.fabric_policies.aaa.management_settings.web_session_idle_timeout) }}
