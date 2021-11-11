*** Settings ***
Documentation   Verify Node Registration
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role in ["leaf","spine"] and node.serial_number is defined %}

Verify Node {{ node.id }} Registration
    GET   "/api/mo/uni/controller/nodeidentpol/nodep-{{ node.serial_number }}.json"
    String   $..fabricNodeIdentP.attributes.serial   {{ node.serial_number }}
    String   $..fabricNodeIdentP.attributes.name   {{ node.name }}
    String   $..fabricNodeIdentP.attributes.nodeId   {{ node.id }}
    String   $..fabricNodeIdentP.attributes.podId   {{ node.pod | default(defaults.apic.node_policies.nodes.pod) }}
{% if node.role == "leaf" and node.type is defined %}
    String   $..fabricNodeIdentP.attributes.nodeType   {{ node.type }}
{% endif %}

{% endif %}
{% endfor %}
