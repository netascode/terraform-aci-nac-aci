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
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ospfCtxP-{{ policy_name }}.json"
    String   $..ospfCtxPol.attributes.name   {{ policy_name }}
    String   $..ospfCtxPol.attributes.ctrl   {{ ctrl_strings | join(",") }}
    String   $..ospfCtxPol.attributes.bwRef   {{ otp.reference_bandwidth | default(defaults.apic.tenants.policies.ospf_timer_policies.reference_bandwidth) }}
    String   $..ospfCtxPol.attributes.descr   {{ otp.description | default() }}
    String   $..ospfCtxPol.attributes.dist   {{ otp.distance | default(defaults.apic.tenants.policies.ospf_timer_policies.distance) }}
    String   $..ospfCtxPol.attributes.dn   uni/tn-{{ tenant.name }}/ospfCtxP-{{ policy_name }}
    String   $..ospfCtxPol.attributes.grCtrl   {{ graceful_restart }}
    String   $..ospfCtxPol.attributes.lsaArrivalIntvl   {{ otp.lsa_arrival_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_arrival_interval) }}
    String   $..ospfCtxPol.attributes.lsaGpPacingIntvl   {{ otp.lsa_group_pacing_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_group_pacing_interval) }}
    String   $..ospfCtxPol.attributes.lsaHoldIntvl   {{ otp.lsa_hold_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_hold_interval) }}
    String   $..ospfCtxPol.attributes.lsaMaxIntvl   {{ otp.lsa_max_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_max_interval) }}
    String   $..ospfCtxPol.attributes.lsaStartIntvl   {{ otp.lsa_start_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.lsa_start_interval) }}
    String   $..ospfCtxPol.attributes.maxEcmp   {{ otp.max_ecmp | default(defaults.apic.tenants.policies.ospf_timer_policies.max_ecmp) }}
    String   $..ospfCtxPol.attributes.maxLsaAction   {{ otp.max_lsa_action | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_action) }}
    String   $..ospfCtxPol.attributes.maxLsaNum   {{ otp.max_lsa_num | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_num) }}
    String   $..ospfCtxPol.attributes.maxLsaResetIntvl   {{ otp.max_lsa_reset_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_reset_interval) }}
    String   $..ospfCtxPol.attributes.maxLsaSleepCnt   {{ otp.max_lsa_sleep_count | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_sleep_count)  }}
    String   $..ospfCtxPol.attributes.maxLsaSleepIntvl   {{ otp.max_lsa_sleep_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_sleep_interval) }}
    String   $..ospfCtxPol.attributes.maxLsaThresh   {{ otp.max_lsa_threshold | default(defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_threshold) }}
    String   $..ospfCtxPol.attributes.spfHoldIntvl   {{ otp.spf_hold_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.spf_hold_interval) }}
    String   $..ospfCtxPol.attributes.spfInitIntvl   {{ otp.spf_init_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.spf_init_interval) }}
    String   $..ospfCtxPol.attributes.spfMaxIntvl   {{ otp.spf_max_interval | default(defaults.apic.tenants.policies.ospf_timer_policies.spf_max_interval) }}
{% endfor %}
