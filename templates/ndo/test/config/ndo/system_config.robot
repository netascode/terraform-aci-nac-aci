*** Settings ***
Documentation   Verify System Config
Suite Setup     Login NDO
Default Tags    ndo   config   day0
Resource        ../../ndo_common.resource

*** Test Cases ***
Verify System Config
    ${r}=   GET On Session   ndo   /api/v1/platform/systemConfig
    Set Suite Variable   ${r}
    Should Be Equal Value Json Integer   ${r.json()}   $.systemConfigs.baseLockoutTime   {{ ndo.system_config.lockout_time | default(defaults.ndo.system_config.lockout_time) }}
    Should Be Equal Value Json Integer   ${r.json()}   $.systemConfigs.allowedConsecutiveAttempts   {{ ndo.system_config.allowed_consecutive_attempts | default(defaults.ndo.system_config.allowed_consecutive_attempts) }}
{% if ndo.system_config.banner.alias is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].alias   {{ ndo.system_config.banner.alias | default() }}
{% endif %}
{% if ndo.system_config.banner.type is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].banner.bannerType   {{ ndo.system_config.banner.type | default(defaults.ndo.system_config.banner.type) }}
{% endif %}
{% if ndo.system_config.banner.message is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].banner.message   {{ ndo.system_config.banner.message | default() }}
{% endif %}
{% if ndo.system_config.banner.bannerState is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.systemConfigs.bannerConfig[0].banner.bannerState   {{ ndo.system_config.banner.state | default(defaults.ndo.system_config.banner.state) }}
{% endif %}
