*** Settings ***
Documentation   Verify Inband Node Address
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.inb_address is defined %}

Verify Inband Node Address ID {{ node.id }}
    GET   "/api/mo/uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}/rsinBStNode-[topology/pod-{{ node.pod | default(defaults.apic.node_policies.nodes.pod) }}/node-{{ node.id }}].json"
    String   $..mgmtRsInBStNode.attributes.addr   {{ node.inb_address }}
    String   $..mgmtRsInBStNode.attributes.gw   {{ node.inb_gateway }}
    String   $..mgmtRsInBStNode.attributes.tDn   topology/pod-{{ node.pod | default(defaults.apic.node_policies.nodes.pod) }}/node-{{ node.id }}

{% endif %}
{% endfor %}
