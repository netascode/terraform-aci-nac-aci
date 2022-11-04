*** Settings ***
Documentation   Verify Syslog Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for syslog in apic.fabric_policies.monitoring.syslogs | default([]) %}
{% set policy_name = syslog.name ~ defaults.apic.fabric_policies.monitoring.syslogs.name_suffix %}

Verify Syslog Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/slgroup-{{ policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..syslogGroup.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogGroup.attributes.descr   {{ syslog.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogGroup.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogGroup.attributes.includeMilliSeconds   {% if syslog.show_millisecond | default(defaults.apic.fabric_policies.monitoring.syslogs.show_millisecond) | cisco.aac.aac_bool("enabled") == 'enabled' %}yes{% else %}no{% endif %}

{% for dest in syslog.destinations | default([]) %}

Verify Syslog Policy {{ policy_name }} Destination {{ dest.hostname_ip }}
    ${dest}=   Set Variable   $..syslogGroup.children[?(@.syslogRemoteDest.attributes.host=='{{ dest.hostname_ip }}')]
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.name   {{ dest.name | default() }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.host   {{ dest.hostname_ip }}
{% if dest.protocol is defined %}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.protocol   {{ dest.protocol | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.protocol) }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.port   {{ dest.port | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.port) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.adminState   {{ dest.admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.forwardingFacility   {{ dest.facility | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.facility) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..syslogRemoteDest.attributes.severity   {{ dest.severity | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.severity) }}
{% set mgmt_epg = dest.mgmt_epg | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..syslogProf.attributes.adminState   {{ syslog.admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogFile.attributes.adminState   {{ syslog.local_admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.local_admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogFile.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogFile.attributes.severity   {{ syslog.local_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.local_severity) }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogConsole.attributes.adminState   {{ syslog.console_admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.console_admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogConsole.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    Should Be Equal Value Json String   ${r.json()}    $..syslogConsole.attributes.severity   {{ syslog.console_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.console_severity) }}

{% endfor %}

{% endfor %}
