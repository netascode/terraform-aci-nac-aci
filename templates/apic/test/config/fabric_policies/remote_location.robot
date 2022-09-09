*** Settings ***
Documentation   Verify Remote Location
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for rl in apic.fabric_policies.remote_locations | default([]) %}
{% set rl_name = rl.name ~ defaults.apic.fabric_policies.remote_locations.name_suffix %}

Verify Remote Location {{ rl_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/path-{{ rl_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.name   {{ rl_name }}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.authType   {% if rl.auth_type | default(defaults.apic.fabric_policies.remote_locations.auth_type) == "ssh_keys" %}useSshKeyContents{% else %}usePassword{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.descr   {{ rl.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.host   {{ rl.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.protocol   {{ rl.protocol }}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.remotePath   {{ rl.path | default(defaults.apic.fabric_policies.remote_locations.path) }}
{% if rl.port is defined  %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.remotePort   {{ rl.port }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.userName   {{ rl.username | default() }}
{% if rl.auth_type | default(defaults.apic.fabric_policies.remote_locations.auth_type) == "ssh_keys" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRemotePath.attributes.identityPublicKeyContents   {{ rl.ssh_public_key }}
{% endif %}
{% set mgmt_epg = rl.mgmt_epg | default(defaults.apic.fabric_policies.remote_locations.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    Should Be Equal Value Json String   ${r.json()}    $..fileRsARemoteHostToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}
