*** Settings ***
Documentation   Verify System Config
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Verify System Config
    GET   "/api/v1/platform/systemConfig"
    Integer   $.systemConfigs.baseLockoutTime   {{ mso.system_config.lockout_time | default(defaults.mso.system_config.lockout_time) }}
    Integer   $.systemConfigs.allowedConsecutiveAttempts   {{ mso.system_config.allowed_consecutive_attempts | default(defaults.mso.system_config.allowed_consecutive_attempts) }}
{% if mso.system_config.banner.alias is defined %}
    String   $.systemConfigs.bannerConfig[0].alias   {{ mso.system_config.banner.alias | default() }}
{% endif %}
{% if mso.system_config.banner.type is defined %}
    String   $.systemConfigs.bannerConfig[0].banner.bannerType   {{ mso.system_config.banner.type | default(defaults.mso.system_config.banner.type) }}
{% endif %}
{% if mso.system_config.banner.message is defined %}
    String   $.systemConfigs.bannerConfig[0].banner.message   {{ mso.system_config.banner.message | default() }}
{% endif %}
{% if mso.system_config.banner.bannerState is defined %}
    String   $.systemConfigs.bannerConfig[0].banner.bannerState   {{ mso.system_config.banner.state | default(defaults.mso.system_config.banner.state) }}
{% endif %}
