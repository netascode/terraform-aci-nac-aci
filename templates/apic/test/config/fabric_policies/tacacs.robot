*** Settings ***
Documentation   Verify TACACS Providers
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for prov in apic.fabric_policies.aaa.tacacs_providers | default([]) %}

Verify TACACS Provider {{ prov.hostname_ip }}
    GET   "/api/mo/uni/userext/tacacsext/tacacsplusprovider-{{ prov.hostname_ip }}.json?rsp-subtree=full"
    String   $..aaaTacacsPlusProvider.attributes.name   {{ prov.hostname_ip }}
    String   $..aaaTacacsPlusProvider.attributes.authProtocol   {{ prov.protocol | default(defaults.apic.fabric_policies.aaa.tacacs_providers.protocol) }}
    String   $..aaaTacacsPlusProvider.attributes.descr   {{ prov.description | default() }}
    String   $..aaaTacacsPlusProvider.attributes.port   {{ prov.port | default(defaults.apic.fabric_policies.aaa.tacacs_providers.port) }}
    String   $..aaaTacacsPlusProvider.attributes.retries   {{ prov.retries | default(defaults.apic.fabric_policies.aaa.tacacs_providers.retries) }}
    String   $..aaaTacacsPlusProvider.attributes.timeout   {{ prov.timeout | default(defaults.apic.fabric_policies.aaa.tacacs_providers.timeout) }}
    String   $..aaaTacacsPlusProvider.attributes.monitorServer   {{ prov.monitoring | default(defaults.apic.fabric_policies.aaa.tacacs_providers.monitoring) | cisco.aac.aac_bool("enabled") }}
{% if prov.monitoring | default(defaults.apic.fabric_policies.aaa.tacacs_providers.monitoring) | cisco.aac.aac_bool("enabled") == "enabled" %}
    String   $..aaaTacacsPlusProvider.attributes.monitoringUser   {{ prov.monitoring_username | default() }}
{% endif %}
{% set mgmt_epg = prov.mgmt_epg | default(defaults.apic.fabric_policies.aaa.tacacs_providers.mgmt_epg) %}
{% if mgmt_epg == "oob" %}
    String   $..aaaRsSecProvToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}
{% elif mgmt_epg == "inb" %}
    String   $..aaaRsSecProvToEpg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}
