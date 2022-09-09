*** Settings ***
Documentation   Verify Interface Type
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Port Interface Type
    ${r}=   GET On Session   apic   /api/mo/uni/infra/prtdirec.json   params=rsp-subtree=full
{% for node in apic.interface_policies.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.id ~ "`]" %}
{% set full_node = (apic.node_policies | community.general.json_query(query))[0] %}
{% if full_node.role == "leaf" %}
{% for interface in node.interfaces | default([]) %}
{% if interface.type is defined %}
    ${port}=   Set Variable   $..infraPortDirecPol.children[?(@.infraRsPortDirection.attributes.tDn=='topology/pod-{{ full_node.pod | default(defaults.apic.node_policies.nodes.pod) }}/paths-{{ node.id }}/pathep-[eth{{ interface.module | default(defaults.apic.interface_policies.nodes.interfaces.module) }}/{{ interface.port }}]')].infraRsPortDirection
    Should Be Equal Value Json String   ${r.json()}    ${port}.attributes.tDn   topology/pod-{{ full_node.pod | default(defaults.apic.node_policies.nodes.pod) }}/paths-{{ node.id }}/pathep-[eth{{ interface.module | default(defaults.apic.interface_policies.nodes.interfaces.module) }}/{{ interface.port }}]
    Should Be Equal Value Json String   ${r.json()}    ${port}.attributes.direc   {% if interface.type == "uplink" %}UpLink{% else %}DownLink{% endif %}


{% endif %}
{% endfor %}
{% endif %}
{% endfor %}   