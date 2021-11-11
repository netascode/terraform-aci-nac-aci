*** Settings ***
Documentation   Verify SNMP Trap Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for snmp in apic.fabric_policies.monitoring.snmp_traps | default([]) %}
{% set policy_name = snmp.name ~ defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix %}

Verify SNMP Trap Policy {{ policy_name }}
    GET   "/api/mo/uni/fabric/snmpgroup-{{ policy_name }}.json?rsp-subtree=full"
    String   $..snmpGroup.attributes.name   {{ policy_name }}
    String   $..snmpGroup.attributes.descr   {{ snmp.description | default() }}

{% for dest in snmp.destinations | default([]) %}

Verify SNMP Trap Policy {{ policy_name }} Destination {{ dest.hostname_ip }}
    ${dest}=   Set Variable   $..snmpGroup.children[?(@.snmpTrapDest.attributes.host=='{{ dest.hostname_ip }}')]
    String   ${dest}..snmpTrapDest.attributes.host   {{ dest.hostname_ip }}
    String   ${dest}..snmpTrapDest.attributes.port   {{ dest.port | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.port) }}
    String   ${dest}..snmpTrapDest.attributes.secName   {{ dest.community }}
    String   ${dest}..snmpTrapDest.attributes.v3SecLvl   {{ dest.security | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.security) }}
    String   ${dest}..snmpTrapDest.attributes.ver   {{ dest.version | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.version) }}
{% set mgmt_epg = policy.mgmt_epg | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    String   $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    String   $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}

{% endfor %}
