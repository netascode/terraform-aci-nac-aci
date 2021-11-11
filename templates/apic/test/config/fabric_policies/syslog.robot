*** Settings ***
Documentation   Verify Syslog Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for syslog in apic.fabric_policies.monitoring.syslogs | default([]) %}
{% set policy_name = syslog.name ~ defaults.apic.fabric_policies.monitoring.syslogs.name_suffix %}

Verify Syslog Policy {{ policy_name }}
    GET   "/api/mo/uni/fabric/slgroup-{{ policy_name }}.json?rsp-subtree=full"
    String   $..syslogGroup.attributes.name   {{ policy_name }}
    String   $..syslogGroup.attributes.descr   {{ syslog.description | default() }}
    String   $..syslogGroup.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    String   $..syslogGroup.attributes.includeMilliSeconds   {% if syslog.show_millisecond | default(defaults.apic.fabric_policies.monitoring.syslogs.show_millisecond) == 'enabled' %}yes{% else %}no{% endif %}

{% for dest in syslog.destinations | default([]) %}

Verify Syslog Policy {{ policy_name }} Destination {{ dest.hostname_ip }}
    ${dest}=   Set Variable   $..syslogGroup.children[?(@.syslogRemoteDest.attributes.host=='{{ dest.hostname_ip }}')]
    String   ${dest}..syslogRemoteDest.attributes.host   {{ dest.hostname_ip }}
    String   ${dest}..syslogRemoteDest.attributes.port   {{ dest.port | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.port) }}
    String   ${dest}..syslogRemoteDest.attributes.adminState   {{ dest.admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.admin_state) }}
    String   ${dest}..syslogRemoteDest.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    String   ${dest}..syslogRemoteDest.attributes.forwardingFacility   {{ dest.facility | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.facility) }}
    String   ${dest}..syslogRemoteDest.attributes.severity   {{ dest.severity | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.severity) }}
{% set mgmt_epg = dest.mgmt_epg | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    String   $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    String   $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}
    String   $..syslogProf.attributes.adminState   {{ syslog.admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.admin_state) }}
    String   $..syslogFile.attributes.adminState   {{ syslog.local_admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.local_admin_state) }}
    String   $..syslogFile.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    String   $..syslogFile.attributes.severity   {{ syslog.local_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.local_severity) }}
    String   $..syslogConsole.attributes.adminState   {{ syslog.console_admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.console_admin_state) }}
    String   $..syslogConsole.attributes.format   {{ syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format) }}
    String   $..syslogConsole.attributes.severity   {{ syslog.console_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.console_severity) }}

{% endfor %}

{% endfor %}
