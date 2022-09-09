*** Settings ***
Documentation   Verify SNMP Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***

{% for policy in apic.fabric_policies.pod_policies.snmp_policies | default([]) %}
{% set snmp_policy_name = policy.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix %}
Verify SNMP Policy '{{ snmp_policy_name }}'
    [Documentation]    Verify SNMP Policy '{{ policy.name }}'
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/snmppol-{{ snmp_policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..snmpPol.attributes.name   {{ snmp_policy_name }}
    # Verify admin state
    Should Be Equal Value Json String   ${r.json()}    $..snmpPol.attributes.adminSt   {{ policy.admin_state | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.admin_state) | cisco.aac.aac_bool("enabled") }}
    # Verify location
    Should Be Equal Value Json String   ${r.json()}    $..snmpPol.attributes.loc   {{ policy.location | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.location) }}
    # Verify contact information
    Should Be Equal Value Json String   ${r.json()}    $..snmpPol.attributes.contact   {{ policy.contact | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.contact) }}

# Verify whether a given user exists in ACI for SNMP Policy and it is configured as expected
{% for user in policy.users | default([]) %}

Verify SNMP Policy '{{ snmp_policy_name }}' User '{{ user.name }}'
    [Documentation]    Verify whether a given user exists in ACI for SNMP Policy and it is configured as expected
    ${usr}=   Set Variable   $..snmpPol.children[?(@.snmpUserP.attributes.name=='{{ user.name }}')]
    Should Be Equal Value Json String   ${r.json()}     ${usr}..snmpUserP.attributes.name   {{ user.name }}
    Should Be Equal Value Json String   ${r.json()}     ${usr}..snmpUserP.attributes.authType   {{ user.authorization_type | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.users.authorization_type) }}
    Should Be Equal Value Json String   ${r.json()}     ${usr}..snmpUserP.attributes.privType   {{ user.privacy_type | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.users.privacy_type)}}
{% endfor %}

{% for client in policy.clients | default([]) %}
{% set snmp_client_name = client.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.clients.name_suffix %}
# Verify whether a given Client Group exists in ACI for SNMP Policy and it is configured as expected
Verify SNMP Policy '{{ snmp_policy_name }}' Client Group '{{ snmp_client_name }}'
    [Documentation]    Verify whether a given Client Group exists in ACI for SNMP Policy and it is configured as expected
    ${client}=   Set Variable   $..snmpPol.children[?(@.snmpClientGrpP.attributes.name=='{{ snmp_client_name }}')]
    Should Be Equal Value Json String   ${r.json()}     ${client}..snmpClientGrpP.attributes.name   {{ snmp_client_name }}
    {% if client.mgmt_epg == "oob" %}
    ${mgmt_epg}=   Set Variable   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
    {% elif client.mgmt_epg == "inb" %}
    ${mgmt_epg}=   Set Variable   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
    {% endif %}
    Should Be Equal Value Json String   ${r.json()}     ${client}..snmpClientGrpP.attributes.epgDn   ${mgmt_epg}

{% for client_entry in client.entries | default([]) %}

Verify SNMP Policy '{{ snmp_policy_name }}' Client Group '{{ snmp_client_name }}' Entry '{{ client_entry.name }}'
    [Documentation]    Verify SNMP Client Entry
    ${client}=   Set Variable   $..snmpPol.children[?(@.snmpClientGrpP.attributes.name=='{{ snmp_client_name }}')]
    ${ent}=   Set Variable   ${client}..snmpClientGrpP.children[?(@.snmpClientP.attributes.name=='{{ client_entry.name }}')]
    Should Be Equal Value Json String   ${r.json()}     ${ent}..snmpClientP.attributes.name   {{ client_entry.name }}
    Should Be Equal Value Json String   ${r.json()}     ${ent}..snmpClientP.attributes.addr   {{ client_entry.ip }}
{% endfor %}

{% endfor %}

{% for community in policy.communities | default([]) %}

# Verify whether a given community exists in ACI for SNMP Policy and it is configured as expected
Verify SNMP Policy '{{ snmp_policy_name }}' Community '{{ community }}'
    [Documentation]    Verify whether a given community exists in ACI for SNMP Policy and it is configured as expected
    ${comm}=   Set Variable   $..snmpPol.children[?(@.snmpCommunityP.attributes.name=='{{ community }}')]
    Should Be Equal Value Json String   ${r.json()}     ${comm}..snmpCommunityP.attributes.name   {{ community }}
{% endfor %}

{% for trap_forwarder in policy.trap_forwarders | default([]) %}

# Verify whether a given Trap Forward Server exists in ACI for SNMP Policy and it is configured as expected
Verify SNMP Policy '{{ snmp_policy_name }}' Trap Forward Server '{{ trap_forwarder.ip }}'
    [Documentation]    Check if a given Trap Forward Server exists in ACI for SNMP Policy and it is configured as expected
    ${tfs}=   Set Variable   $..snmpPol.children[?(@.snmpTrapFwdServerP.attributes.addr=='{{ trap_forwarder.ip }}')]
    Should Be Equal Value Json String   ${r.json()}     ${tfs}..snmpTrapFwdServerP.attributes.addr   {{ trap_forwarder.ip }}
    Should Be Equal Value Json String   ${r.json()}     ${tfs}..snmpTrapFwdServerP.attributes.port   {{ trap_forwarder.port | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.trap_forwarders.port) }}
{% endfor %}

{% endfor %}
