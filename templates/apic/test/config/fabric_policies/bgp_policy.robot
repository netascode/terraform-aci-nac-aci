*** Settings ***
Documentation   Verify BGP Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.fabric_policies is defined %}
Retrieve BGP config
    GET   "/api/mo/uni/fabric/bgpInstP-default.json?rsp-subtree=full"

{% if apic.fabric_policies.fabric_bgp_rr is defined %}
{% for item in apic.fabric_policies.fabric_bgp_rr | default([]) %}
{% set query = "nodes[?id==`" ~ item ~ "`].pod" %}
{% set pod = (apic.node_policies | community.general.json_query(query))[0] | default(defaults.apic.fabric_policies.fabric_bgp_ext_rr.pod_id) %}

Verify BGP Route Reflector {{ item }}
    ${rr}=   Set Variable   $..bgpRRP.children[?(@.bgpRRNodePEp.attributes.id=='{{ item }}')]
    String   ${rr}..bgpRRNodePEp.attributes.id   {{ item }}
    String   ${rr}..bgpRRNodePEp.attributes.podId   {{ pod }}

{% endfor %}
{% endif %}

{% if apic.fabric_policies.fabric_bgp_ext_rr is defined %}
{% for item in apic.fabric_policies.fabric_bgp_ext_rr | default([]) %}
{% set query = "nodes[?id==`" ~ item ~ "`].pod" %}
{% set pod = (apic.node_policies | community.general.json_query(query))[0] | default(defaults.apic.fabric_policies.fabric_bgp_ext_rr.pod_id) %}

Verify External BGP Route Reflector {{ item }}
    ${extrr}=   Set Variable   $..bgpExtRRP.children[?(@.bgpRRNodePEp.attributes.id=='{{ item }}')]
    String   ${extrr}..bgpRRNodePEp.attributes.id   {{ item }}
    String   ${extrr}..bgpRRNodePEp.attributes.podId   {{ pod }}

{% endfor %}
{% endif %}

{% if apic.fabric_policies.fabric_bgp_as is defined %}
Verify BGP AS Number
    String   $..bgpAsP.attributes.asn   {{ apic.fabric_policies.fabric_bgp_as }}
{% else %}

{% endif %}

{% endif %}
