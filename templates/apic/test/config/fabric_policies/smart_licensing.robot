*** Settings ***
Documentation   Smart Licensing
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.fabric_policies.smart_licensing is defined %}
Verify Smart Licensing
    ${r}=   GET On Session   apic   /api/node/mo/uni/fabric/licensepol.json
    Should Be Equal Value Json String   ${r.json()}    $..licenseLicPolicy.attributes.mode   {{ apic.fabric_policies.smart_licensing.mode | default(defaults.apic.fabric_policies.smart_licensing.mode) }}
{% if apic.fabric_policies.smart_licensing.mode == "proxy" %}
    Should Be Equal Value Json String   ${r.json()}    $..licenseLicPolicy.attributes.ipAddr   {{ apic.fabric_policies.smart_licensing.proxy.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    $..licenseLicPolicy.attributes.port   {{ apic.fabric_policies.smart_licensing.proxy.port | default(defaults.apic.fabric_policies.smart_licensing.proxy.port) }}
    Should Be Equal Value Json String   ${r.json()}    $..licenseLicPolicy.attributes.url   {{ defaults.apic.fabric_policies.smart_licensing.url }}
{% elif apic.fabric_policies.smart_licensing.mode == "satellite" or apic.fabric_policies.smart_licensing.mode == "cslu" or apic.fabric_policies.smart_licensing.mode == "smart-transport-gateway" %}
    Should Be Equal Value Json String   ${r.json()}    $..licenseLicPolicy.attributes.url   {{ apic.fabric_policies.smart_licensing.url }}
{% endif %}
{% endif %}