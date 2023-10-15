*** Settings ***
Documentation   Verify OSPF Timer Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for otp in tenant.policies.ospf_timer_policies | default([]) %}
{% set policy_name = otp.name ~ defaults.apic.tenants.policies.ospf_timer_policies.name_suffix %}

{% set graceful_restart = "" %}
{% if otp.graceful_restart | default(defaults.apic.tenants.policies.ospf_timer_policies.graceful_restart) %}
    {% set graceful_restart = "helper" %}
{% endif %}

{% set ctrl_strings = [] %}
{% if otp.router_id_lookup | default(defaults.apic.tenants.policies.ospf_timer_policies.router_id_lookup) %}
    {{ ctrl_strings.append("name-lookup") }}
{% endif %}
{% if otp.prefix_suppression | default(defaults.apic.tenants.policies.ospf_timer_policies.prefix_suppression) %}
    {{ ctrl_strings.append("pfx-suppress") }}
{% endif %}

Verify OSPF Timer Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ospfCtxP-{{ policy_name }}.json
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.ctrl   {{ ctrl_strings | join(",") }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.bwRef   {{ otp.reference_bandwidth | default(defaults.apic.tenants.policies.ospf_timer_policies.reference_bandwidth) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.descr   {{ otp.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.dist   {{ otp.distance | default(defaults.apic.tenants.policies.ospf_timer_policies.distance) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.dn   uni/tn-{{ tenant.name }}/ospfCtxP-{{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.grCtrl   {{ graceful_restart }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.lsaArrivalIntvl   {{ otp.lsa_arrival_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_arrival_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.lsaGpPacingIntvl   {{ otp.lsa_group_pacing_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_group_pacing_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.lsaHoldIntvl   {{ otp.lsa_hold_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_hold_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.lsaMaxIntvl   {{ otp.lsa_max_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_max_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.lsaStartIntvl   {{ otp.lsa_start_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_start_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxEcmp   {{ otp.max_ecmp | default(defaults.apic.tenants.policies.ospf_timer_policies.max_ecmp) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxLsaAction   {{ otp.max_lsa_action | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_action) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxLsaNum   {{ otp.max_lsa_num | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_num) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxLsaResetIntvl   {{ otp.max_lsa_reset_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_reset_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxLsaSleepCnt   {{ otp.max_lsa_sleep_count | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_sleep_count)  }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxLsaSleepIntvl   {{ otp.max_lsa_sleep_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_sleep_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.maxLsaThresh   {{ otp.max_lsa_threshold | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_threshold) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.spfHoldIntvl   {{ otp.spf_hold_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.spf_hold_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.spfInitIntvl   {{ otp.spf_init_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.spf_init_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..ospfCtxPol.attributes.spfMaxIntvl   {{ otp.spf_max_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.spf_max_interval) }}
{% endfor %}
