*** Settings ***
Documentation   Verify SNMP Trap Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for snmp in apic.fabric_policies.monitoring.snmp_traps | default([]) %}
{% set policy_name = snmp.name ~ defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix %}

Verify SNMP Trap Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/snmpgroup-{{ policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..snmpGroup.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..snmpGroup.attributes.descr   {{ snmp.description | default() }}

{% for dest in snmp.destinations | default([]) %}

Verify SNMP Trap Policy {{ policy_name }} Destination {{ dest.hostname_ip }}
    ${dest}=   Set Variable   $..snmpGroup.children[?(@.snmpTrapDest.attributes.host=='{{ dest.hostname_ip }}')]
    Should Be Equal Value Json String   ${r.json()}    ${dest}..snmpTrapDest.attributes.host   {{ dest.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..snmpTrapDest.attributes.port   {{ dest.port | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.port) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..snmpTrapDest.attributes.secName   {{ dest.community }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..snmpTrapDest.attributes.v3SecLvl   {{ dest.security | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.security) }}
    Should Be Equal Value Json String   ${r.json()}    ${dest}..snmpTrapDest.attributes.ver   {{ dest.version | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.version) }}
{% set mgmt_epg = dest.mgmt_epg | default(defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}

{% endfor %}
