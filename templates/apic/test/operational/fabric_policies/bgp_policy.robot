*** Settings ***
Documentation   Verify BGP Policy Operational State
Suite Setup     Login APIC
Default Tags    apic   day1   operational   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for rr in apic.fabric_policies.fabric_bgp_rr | default([]) %}
{% set query = "nodes[?id==`" ~ rr ~ "`].pod" %}
{% set pod = (apic.node_policies | community.general.json_query(query))[0] | default(defaults.apic.fabric_policies.fabric_bgp_rr.pod_id) %}

Verify BGP Route Reflector {{ rr }} Peerings
    ${r}=   GET On Session   apic   /api/mo/uni/controller/setuppol/setupp-{{ pod }}.json
    ${tep_pool}=   Get Value From Json   ${r.json()}   $..fabricSetupP.attributes.tepPool
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
    ${r}=   GET On Session   apic   api/node/class/fabricNode.json
    ${node_ip}=   Get Value From Json   ${r.json()}   $..imdata[?(@.fabricNode.attributes.id=='{{ node.id }}')].fabricNode.attributes.address
    ${r}=   GET On Session   apic   /api/node/mo/topology/pod-{{ pod }}/node-{{ rr }}/sys/bgp/inst/dom-overlay-1/peer-[${tep_pool}[0]]/ent-[${node_ip}[0]].json
    ${bgp_state}=   Get Value From Json   ${r.json()}   $..bgpPeerEntry.attributes.operSt
    Run Keyword If   "${bgp_state}[0]" != "established"   Run Keyword And Continue On Failure
    ...   Fail  "Node {{ node.id }}: BGP is not established"
{% endif %}
{% endfor %}    

{% endfor %}