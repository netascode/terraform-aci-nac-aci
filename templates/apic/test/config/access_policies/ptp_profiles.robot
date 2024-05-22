*** Settings ***
Documentation   Verify PTP Profiles
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for ptp_profile in apic.access_policies.ptp_profiles | default([]) %}
{% set ptp_profile_name = ptp_profile.name %}

Verify PTP Profile {{ ptp_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/ptpprofile-{{ ptp_profile_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.name   {{ ptp_profile_name }}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.announceIntvl   {{ ptp_profile.announce_interval | default(defaults.apic.access_policies.ptp_profiles.announce_interval) }}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.announceTimeout   {{ ptp_profile.announce_timeout | default(defaults.apic.access_policies.ptp_profiles.announce_timeout) }}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.delayIntvl   {{ ptp_profile.delay_interval | default(defaults.apic.access_policies.ptp_profiles.delay_interval) }}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.syncIntvl   {{ ptp_profile.sync_interval | default(defaults.apic.access_policies.ptp_profiles.sync_interval) }}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.profileTemplate   {% if ptp_profile.template | default(defaults.apic.access_policies.ptp_profiles.template) == "telecom" %}telecom_full_path{% elif ptp_profile.template | default(defaults.apic.access_policies.ptp_profiles.template) == "smpte" %}smpte{% else %}aes67{% endif %} 
    {% if ptp_profile.template | default(defaults.apic.access_policies.ptp_profiles.template) == "telecom" %}
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.ptpoeDstMacType   {% if ptp_profile.forwardable | default(defaults.apic.access_policies.ptp_profiles.forwardable) %}forwardable{% else %}non-forwardable{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.ptpoeDstMacRxNoMatch   {% if prof.mismatch_handling | default(defaults.apic.access_policies.ptp_profiles.mismatch_handling) == 'configured' %}replyWithCfgMac{% elif prof.mismatch_handling | default(defaults.apic.access_policies.ptp_profiles.mismatch_handling) == 'received' %}replyWithRxMac{% else %}drop{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    $..ptpProfile.attributes.localPriority   {{ ptp_profile.priority | default(defaults.apic.access_policies.ptp_profiles.priority) }}
    {% endif %}
{% endfor %}