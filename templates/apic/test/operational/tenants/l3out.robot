{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify L3out Operational State
Suite Setup     Login APIC
Default Tags    apic   day2   operational   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set vrf_name = l3out.vrf ~ ('' if l3out.vrf in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}
{% for node in l3out.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.node_id ~ "`].pod" %}
{% set pod = node.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% for int in node.interfaces | default([]) %}
{% for peer in int.bgp_peers | default([]) %}

Verify L3out {{ l3out_name }} BGP Neighbor {{ peer.ip }}
    ${r}=   GET On Session   apic   /api/node/mo/topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node.node_id }}/sys/bgp/inst/dom-{{ tenant.name }}:{{ vrf_name }}/peer-[{{ peer.ip }}/32]/ent-[{{ peer.ip }}].json
    ${state}=   Get Value From Json   ${r.json()}   $..bgpPeerEntry.attributes.operSt
    Run Keyword If   "${state}" != "established"   Run Keyword And Continue On Failure
    ...   Fail  "Peer {{ peer.ip }}: BGP is not established"

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}


{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set vrf_name = l3out.vrf ~ ('' if l3out.vrf in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}
{% for np in l3out.node_profiles | default([]) %}
{% for ip in np.interface_profiles | default([]) %}
{% for int in ip.interfaces | default([]) %}
{% set query = "nodes[?id==`" ~ int.node_id ~ "`].pod" %}
{% set pod = int.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% set node_list = [int.node_id] %}
{% if int.node2_id is defined %}
    {% set node_list = [int.node_id, int.node2_id] %}
{% endif %}
{% for peer in int.bgp_peers | default([]) %}
{% for node in node_list %}

Verify L3out {{ l3out_name }} BGP Neighbor {{ peer.ip }} node {{ node }}
    ${r}=   GET On Session   apic   /api/node/mo/topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node }}/sys/bgp/inst/dom-{{ tenant.name }}:{{ vrf_name }}/peer-[{{ peer.ip }}/32]/ent-[{{ peer.ip }}].json
    ${state}=   Get Value From Json   ${r.json()}   $..bgpPeerEntry.attributes.operSt
    Run Keyword If   "${state}[0]" != "established"   Run Keyword And Continue On Failure
    ...   Fail  "Node {{ node }} Peer {{ peer.ip }}: BGP is not established"

{% set bfd = peer.bfd | default('no') %}
{% if bfd == 'yes' %}

Verify L3out {{ l3out_name }} BFD Neighbor {{ peer.ip }} node {{ node }}
    ${r}=   GET On Session   apic   /api/node/mo/topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node }}/sys/bfd/inst.json   params=query-target=children&query-target-filter=and(eq(bfdSess.destAddr,\\"{{ peer.ip }}\\"),eq(bfdSess.vrfName,\\"{{ tenant.name }}:{{ vrf_name }}\\"))
    ${state}=   Get Value From Json   ${r.json()}   $..bfdSess.attributes.operSt
    Run Keyword If   "${state}[0]" != "up"   Run Keyword And Continue On Failure
    ...   Fail  "Node {{ node }} Peer {{ peer.ip }}: BFD is not established"
{% endif %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
