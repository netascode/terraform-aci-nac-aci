*** Settings ***
Documentation   Verify Node Registration
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role in ["leaf","spine"] and node.serial_number is defined %}

Verify Node {{ node.id }} Registration
    ${r}=   GET On Session   apic   /api/mo/uni/controller/nodeidentpol/nodep-{{ node.serial_number }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeIdentP.attributes.serial   {{ node.serial_number }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeIdentP.attributes.name   {{ node.name }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeIdentP.attributes.nodeId   {{ node.id }}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeIdentP.attributes.podId   {{ node.pod | default(defaults.apic.node_policies.nodes.pod) }}
{% if node.role == "leaf" and node.type is defined %}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeIdentP.attributes.nodeType   {{ node.type }}
{% endif %}
{% if node.type | default() == "remote-leaf-wan" %}
    Should Be Equal Value Json String   ${r.json()}    $..fabricNodeIdentP.attributes.extPoolId   {{ node.remote_pool_id }}
{% endif %}

{% endif %}
{% endfor %}
