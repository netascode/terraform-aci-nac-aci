*** Settings ***
Documentation   Verify RADIUS Providers
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for prov in apic.fabric_policies.aaa.radius_providers | default([]) %}

Verify RADIUS Provider {{ prov.hostname_ip }}
    ${r}=   GET On Session   apic   /api/mo/uni/userext/radiusext/radiusprovider-{{ prov.hostname_ip }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.name   {{ prov.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.authProtocol   {{ prov.protocol | default(defaults.apic.fabric_policies.aaa.radius_providers.protocol) }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.descr   {{ prov.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.authPort   {{ prov.port | default(defaults.apic.fabric_policies.aaa.radius_providers.port) }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.retries   {{ prov.retries | default(defaults.apic.fabric_policies.aaa.radius_providers.retries) }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.timeout   {{ prov.timeout | default(defaults.apic.fabric_policies.aaa.radius_providers.timeout) }}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.monitorServer   {{ prov.monitoring | default(defaults.apic.fabric_policies.aaa.radius_providers.monitoring) | cisco.aac.aac_bool("enabled") }}
{% if prov.monitoring | default(defaults.apic.fabric_policies.aaa.radius_providers.monitoring) %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRadiusProvider.attributes.monitoringUser   {{ prov.monitoring_username | default() }}
{% endif %}
{% set mgmt_epg = prov.mgmt_epg | default(defaults.apic.fabric_policies.aaa.radius_providers.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRsSecProvToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRsSecProvToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}