*** Settings ***
Documentation   Verify Date and Time Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.pod_policies.date_time_policies | default([]) %}
{% set date_time_policy_name = policy.name ~ defaults.apic.fabric_policies.pod_policies.date_time_policies.name_suffix %}
Verify Date and Time Policy {{ date_time_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/time-{{ date_time_policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..datetimePol.attributes.name   {{ date_time_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..datetimePol.attributes.StratumValue   {{ policy.apic_ntp_server_master_stratum | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.apic_ntp_server_master_stratum) }}
    Should Be Equal Value Json String   ${r.json()}    $..datetimePol.attributes.adminSt   {{ policy.ntp_admin_state | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..datetimePol.attributes.authSt   {{ policys.ntp_auth_state | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_auth_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..datetimePol.attributes.serverState   {{ policy.apic_ntp_server_state | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.apic_ntp_server_state) | cisco.aac.aac_bool("enabled") }}

{% for server in policy.ntp_servers | default([]) %}

Verify NTP Server {{ server.hostname_ip }}
    ${server}=   Set Variable   $..datetimePol.children[?(@.datetimeNtpProv.attributes.name=='{{ server.hostname_ip }}')]
    Should Be Equal Value Json String   ${r.json()}    ${server}..datetimeNtpProv.attributes.name   {{ server.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    ${server}..datetimeNtpProv.attributes.preferred   {{ server.preferred | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.preferred) | cisco.aac.aac_bool("yes") }}
{% set mgmt_epg = server.mgmt_epg | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    Should Be Equal Value Json String   ${r.json()}    ${server}..datetimeRsNtpProvToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    Should Be Equal Value Json String   ${r.json()}    ${server}..datetimeRsNtpProvToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}
{% if server.auth_key_id is defined %}
    Should Be Equal Value Json String   ${r.json()}    ${server}..datetimeRsNtpProvToNtpAuthKey.attributes.tnDatetimeNtpAuthKeyId   {{ server.auth_key_id }}
{% endif %}

{% endfor %}

{% for key in policy.ntp_keys | default([]) %}

Verify NTP Key {{ key.id }}
    ${key}=   Set Variable   $..datetimePol.children[?(@.datetimeNtpAuthKey.attributes.id=='{{ key.id }}')]
    Should Be Equal Value Json String   ${r.json()}    ${key}.datetimeNtpAuthKey.attributes.id   {{ key.id }}
    Should Be Equal Value Json String   ${r.json()}    ${key}.datetimeNtpAuthKey.attributes.keyType   {{ key.auth_type }}
    Should Be Equal Value Json String   ${r.json()}    ${key}.datetimeNtpAuthKey.attributes.trusted   {{ key.trusted | cisco.aac.aac_bool("yes") }}

{% endfor %}

{% endfor %}






