*** Settings ***
Documentation   Verify Remote Location
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for rl in apic.fabric_policies.remote_locations | default([]) %}
{% set rl_name = rl.name ~ defaults.apic.fabric_policies.remote_locations.name_suffix %}

Verify Remote Location {{ rl_name }}
    GET   "/api/mo/uni/fabric/path-{{ rl_name }}.json?rsp-subtree=full"
    String   $..fileRemotePath.attributes.name   {{ rl_name }}
    String   $..fileRemotePath.attributes.authType   {% if rl.auth_type | default(defaults.apic.fabric_policies.remote_locations.auth_type) == "ssh_keys" %}useSshKeyContents{% else %}usePassword{% endif %}
    String   $..fileRemotePath.attributes.descr   {{ rl.description | default() }}
    String   $..fileRemotePath.attributes.host   {{ rl.hostname_ip }}
    String   $..fileRemotePath.attributes.protocol   {{ rl.protocol }}
    String   $..fileRemotePath.attributes.remotePath   {{ rl.path | default(defaults.apic.fabric_policies.remote_locations.path) }}
{% if rl.port is defined  %}
    String   $..fileRemotePath.attributes.remotePort   {{ rl.port }}
{% endif %}
    String   $..fileRemotePath.attributes.userName   {{ rl.username | default() }}
{% if rl.auth_type | default(defaults.apic.fabric_policies.remote_locations.auth_type) == "ssh_keys" %}
    String   $..fileRemotePath.attributes.identityPublicKeyContents   {{ rl.ssh_public_key }}
{% endif %}
{% set mgmt_epg = rl.mgmt_epg | default(defaults.apic.fabric_policies.remote_locations.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    String   $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    String   $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}
