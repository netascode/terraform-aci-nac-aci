*** Settings ***
Documentation   Verify System Config
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Verify System Config
    ${r}=   GET On Session   mso   /api/v1/platform/systemConfig
    Set Suite Variable   ${r}
    Should Be Equal Value Json Integer   ${r.json()}   $.systemConfigs.baseLockoutTime   {{ mso.system_config.lockout_time | default(defaults.mso.system_config.lockout_time) }}
    Should Be Equal Value Json Integer   ${r.json()}   $.systemConfigs.allowedConsecutiveAttempts   {{ mso.system_config.allowed_consecutive_attempts | default(defaults.mso.system_config.allowed_consecutive_attempts) }}
{% if mso.system_config.banner.alias is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].alias   {{ mso.system_config.banner.alias | default() }}
{% endif %}
{% if mso.system_config.banner.type is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].banner.bannerType   {{ mso.system_config.banner.type | default(defaults.mso.system_config.banner.type) }}
{% endif %}
{% if mso.system_config.banner.message is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].banner.message   {{ mso.system_config.banner.message | default() }}
{% endif %}
{% if mso.system_config.banner.bannerState is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].banner.bannerState   {{ mso.system_config.banner.state | default(defaults.mso.system_config.banner.state) }}
{% endif %}
