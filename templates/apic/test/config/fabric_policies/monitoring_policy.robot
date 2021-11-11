*** Settings ***
Documentation   Verify Monitoring Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for snmp in apic.fabric_policies.monitoring.snmp_traps | default([]) %}
{% set snmp_policy_name = snmp.name ~ defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix %}

Verify Monitoring Policy SNMP Trap Policy {{ snmp_policy_name }}
    GET   "/api/mo/uni/fabric/moncommon/snmpsrc-{{ snmp_policy_name }}.json?rsp-subtree=full"
    String   $..snmpSrc.attributes.name   {{ snmp_policy_name }}
    String   $..snmpRsDestGroup.attributes.tDn   uni/fabric/snmpgroup-{{ snmp_policy_name }}

{% endfor %}

{% for syslog in apic.fabric_policies.monitoring.syslogs | default([]) %}
{% set syslog_policy_name = syslog.name ~ defaults.apic.fabric_policies.monitoring.syslogs.name_suffix %}
{% set include = [] %}
{% if syslog.audit | default(defaults.apic.fabric_policies.monitoring.syslogs.audit) == "yes" %}{% set include = include + [("audit")] %}{% endif %}
{% if syslog.events | default(defaults.apic.fabric_policies.monitoring.syslogs.events) == "yes" %}{% set include = include + [("events")] %}{% endif %}
{% if syslog.faults | default(defaults.apic.fabric_policies.monitoring.syslogs.faults) == "yes" %}{% set include = include + [("faults")] %}{% endif %}
{% if syslog.session | default(defaults.apic.fabric_policies.monitoring.syslogs.session) == "yes" %}{% set include = include + [("session")] %}{% endif %}
{% if include == ['audit', 'events', 'faults', 'session'] %}{% set include = [("all")] + include %}{% endif %}

Verify Monitoring Policy Syslog Policy {{ syslog_policy_name }}
    GET   "/api/mo/uni/fabric/moncommon/slsrc-{{ syslog_policy_name }}.json?rsp-subtree=full"
    String   $..syslogSrc.attributes.name   {{ syslog_policy_name }}
    String   $..syslogSrc.attributes.incl   {{ include | join(',') }}
    String   $..syslogSrc.attributes.minSev   {{ syslog.minimum_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.minimum_severity) }}
    String   $..syslogRsDestGroup.attributes.tDn   uni/fabric/slgroup-{{ syslog_policy_name }}

{% endfor %}
