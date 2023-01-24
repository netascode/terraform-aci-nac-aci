*** Settings ***
Documentation   Verify PTP
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify PTP
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/ptpmode.json
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.state   {{ apic.fabric_policies.ptp.admin_state | default(defaults.apic.fabric_policies.ptp.admin_state) | cisco.aac.aac_bool("enabled") }}
{% if apic.fabric_policies.ptp.global_domain is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.globalDomain   {{ apic.fabric_policies.ptp.global_domain }}
{% endif %}
{% if apic.fabric_policies.ptp.profile is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.fabProfileTemplate   {{ apic.fabric_policies.ptp.profile }}
{% endif %}
{% if apic.fabric_policies.ptp.announce_interval is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.fabAnnounceIntvl   {{ apic.fabric_policies.ptp.announce_interval }}
{% endif %}
{% if apic.fabric_policies.ptp.announce_timeout is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.fabAnnounceTimeout   {{ apic.fabric_policies.ptp.announce_timeout }}
{% endif %}
{% if apic.fabric_policies.ptp.sync_interval is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.fabSyncIntvl   {{ apic.fabric_policies.ptp.sync_interval }}
{% endif %}
{% if apic.fabric_policies.ptp.delay_interval is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.fabDelayIntvl   {{ apic.fabric_policies.ptp.delay_interval }}
{% endif %}