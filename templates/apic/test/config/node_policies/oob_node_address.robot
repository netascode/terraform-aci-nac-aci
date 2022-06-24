*** Settings ***
Documentation   Verify Out-of-band Node Address
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.oob_address is defined or node.oob_v6_address is defined %}

Verify Out-of-band Node Address ID {{ node.id }}
    GET   "/api/mo/uni/tn-mgmt/mgmtp-default/oob-{{ apic.node_policies.oob_endpoint_group | default(defaults.apic.node_policies.oob_endpoint_group) }}/rsooBStNode-[topology/pod-{{ node.pod | default(defaults.apic.node_policies.nodes.pod) }}/node-{{ node.id }}].json"
    String   $..mgmtRsOoBStNode.attributes.addr   {{ node.oob_address | default() }}
    String   $..mgmtRsOoBStNode.attributes.gw   {{ node.oob_gateway | default() }}
    String   $..mgmtRsOoBStNode.attributes.v6Addr   {{ node.oob_v6_address | default() }}
    String   $..mgmtRsOoBStNode.attributes.v6Gw   {{ node.oob_v6_gateway | default() }}
    String   $..mgmtRsOoBStNode.attributes.tDn   topology/pod-{{ node.pod | default(defaults.apic.node_policies.nodes.pod) }}/node-{{ node.id }}

{% endif %}
{% endfor %}
