{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify SR MPLS L3out
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.sr_mpls_l3outs | default([]) %}
{% if l3out.transport_data_plane | default(defaults.apic.tenants.sr_mpls_l3outs.transport_data_plane) == 'mpls' %}
    {% set sr = false %}
{% else %}
    {% set sr = true %}
{% endif %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.sr_mpls_l3outs.name_suffix %}
{% set domain_name = l3out.domain ~ defaults.apic.access_policies.routed_domains.name_suffix %}
{% set vrf_name = l3out.vrf ~ ('' if l3out.vrf in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}

Verify SR MPLS L3out {{ l3out_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}.json   params=rsp-subtree=full&rsp-prop-include=config-only
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..l3extOut.attributes.name   {{ l3out_name }}
    Should Be Equal Value Json String   ${r.json()}   $..l3extOut.attributes.nameAlias   {{ l3out.alias  | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..l3extOut.attributes.descr   {{ l3out.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..l3extOut.attributes.mplsEnabled   yes
{% if tenant.name == 'infra' %}
    Should Be Equal Value Json String   ${r.json()}   $..l3extRsEctx.attributes.tnFvCtxName   overlay-1
    Should Be Equal Value Json String   ${r.json()}   $..l3extRsL3DomAtt.attributes.tDn   uni/l3dom-{{ domain_name }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   $..l3extRsEctx.attributes.tnFvCtxName   {{ vrf_name }}
{% endif %}

{% for np in l3out.node_profiles | default([]) %}
{% set l3out_np_name = np.name ~ defaults.apic.tenants.sr_mpls_l3outs.node_profiles.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} Node Profile {{ l3out_np_name }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${np}..l3extLNodeP.attributes.name   {{ l3out_np_name }}
{% if np.mpls_custom_qos_policy is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${np}..l3extRsLNodePMplsCustQosPol.attributes.tDn   uni/tn-infra/qosmplscustom-{{ np.mpls_custom_qos_policy }}
{% endif %}
{% if np.bfd_multihop_node_policy is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${np}..bfdRsMhNodePol.attributes.tnBfdMhNodePolName   {{ np.bfd_multihop_node_policy }}
{% endif %}

{% for node in np.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.node_id ~ "`].pod" %}
{% set pod = node.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}

Verify SR MPLS L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Node {{ node.node_id }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${node}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.nodes.pod) }}/node-{{ node.node_id }}')]
    Should Be Equal Value Json String   ${r.json()}   ${node}..l3extRsNodeL3OutAtt.attributes.tDn   topology/pod-{{ pod | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.nodes.pod) }}/node-{{ node.node_id }}
    Should Be Equal Value Json String   ${r.json()}   ${node}..l3extRsNodeL3OutAtt.attributes.rtrId   {{ node.router_id }}
    Should Be Equal Value Json String   ${r.json()}   ${node}..l3extLoopBackIfP.attributes.addr   {{ node.bgp_evpn_loopback }}
    Should Be Equal Value Json String   ${r.json()}   ${node}..mplsNodeSidP.attributes.loopbackAddr   {{ node.mpls_transport_loopback }}
    Should Be Equal Value Json String   ${r.json()}   ${node}..mplsNodeSidP.attributes.sidoffset   {{ node.segment_id }}
{%- endfor %}

{% for peer in np.evpn_connectivity | default([]) %}
{% set ctrl = [] %}
{% if peer.allow_self_as | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.allow_self_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-self-as")] %}{% endif %}
{% if peer.disable_peer_as_check | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.disable_peer_as_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("dis-peer-as-check")] %}{% endif %}
{% set ctrl = ctrl + [("send-com")] %}
{% set ctrl = ctrl + [("send-ext-com")] %}
{% set peer_ctrl = [] %}
{% if peer.bfd | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("bfd")] %}{% endif %}

Verify SR MPLS L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} BGP Peer {{ peer.ip }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${peer}=   Set Variable   ${np}..children[?(@.bgpInfraPeerP.attributes.addr=='{{ peer.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.addr   {{ peer.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.adminSt   {{ peer.admin_state | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.descr   {{ peer.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.peerCtrl   {{ peer_ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.ttl   {{ peer.ttl | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.ttl) }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpInfraPeerP.attributes.peerT   sr-mpls
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpAsP.attributes.asn   {{ peer.remote_as }}
{% if peer.local_as is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpLocalAsnP.attributes.localAsn   {{ peer.local_as }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpLocalAsnP.attributes.asnPropagate   {{ peer.as_propagate | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.as_propagate) }}
{% endif %}
{% if peer.peer_prefix_policy is defined %}
{% set peer_prefix_policy_name = peer.peer_prefix_policy ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpRsPeerPfxPol.attributes.tnBgpPeerPfxPolName   {{ peer_prefix_policy_name }}
{% endif %}

{% endfor %}

{% for ip in np.interface_profiles | default([]) %}
{% set l3out_ip_name = ip.name ~ defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.name_suffix %}

Verify SR MPLS L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${ip}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extLIfP.attributes.name=='{{ l3out_ip_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${ip}..l3extLIfP.attributes.name   {{ l3out_ip_name }}
{% if ip.bfd_policy is defined %}
{% set bfd_name = ip.bfd_policy ~ defaults.apic.tenants.policies.bfd_interface_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${ip}..bfdRsIfPol.attributes.tnBfdIfPolName   {{ bfd_name }}
{% endif %}

{% for int in ip.interfaces | default([]) %}

Verify SR MPLS L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }} Interface {{ loop.index }}
{% if int.port is defined | cisco.aac.aac_bool("yes") == 'yes' %}
{% set type = 'ap' %}
{% set query = "nodes[?id==`" ~ int.node_id ~ "`].pod" %}
{% set pod = int.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% else %}
{% set policy_group_name = int.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ int.channel ~ "`].type" %}
{% set type = (apic.access_policies | community.general.json_query(query))[0] %}
{% if int.node_id is defined %}
    {% set node = int.node_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
{% endif %}
{% set query = "nodes[?id==`" ~ node_ ~ "`].pod" %}
{% set pod = int.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% endif %}
{% if type == 'ap' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.sr_mpls_l3outs.nodes.interfaces.pod) ~ "/paths-" ~ int.node_id ~ "/pathep-[eth" ~ int.module | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.module) ~ "/" ~ int.port ~ "]" %}
{% elif type == 'pc' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.sr_mpls_l3outs.nodes.interfaces.pod) ~ "/paths-" ~ node ~ "/pathep-[" ~ policy_group_name ~ "]" %}
{% endif %}

    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${ip}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extLIfP.attributes.name=='{{ l3out_ip_name }}')]
    ${int}=   Set Variable   ${ip}..l3extLIfP.children[?(@.l3extRsPathL3OutAtt.attributes.tDn=='{{ tDn }}')]
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.addr   {{ int.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.descr   {{ int.description | default() }}
{% if int.vlan is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.ifInstT   sub-interface
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.encap   vlan-{{ int.vlan }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.ifInstT   l3-port
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.mac   {{ int.mac | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.mac) }}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.mtu   {{ int.mtu | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.mtu) }}
{% if type == 'ap' %}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.tDn   {{ tDn }}
{% elif type == 'pc' %}
    Should Be Equal Value Json String   ${r.json()}   ${int}..l3extRsPathL3OutAtt.attributes.tDn   {{ tDn }}
{% endif %}

{% for peer in int.bgp_peers | default([]) %}
{% set ctrl = [] %}
{% if peer.allow_self_as | default(defaults.apic.tenants.sr_mpls_l3outs.nodes.interfaces.bgp_peers.allow_self_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-self-as")] %}{% endif %}
{% if peer.send_community | default(defaults.apic.tenants.sr_mpls_l3outs.nodes.interfaces.bgp_peers.send_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("send-com")] %}{% endif %}
{% if peer.send_ext_community | default(defaults.apic.tenants.sr_mpls_l3outs.nodes.interfaces.bgp_peers.send_ext_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("send-ext-com")] %}{% endif %}
{% if sr == false %}{% set ctrl = ctrl + [("segment-routing-disable")] %}{% endif %}
{% set peer_ctrl = [] %}
{% if peer.bfd | default(defaults.apic.tenants.sr_mpls_l3outs.nodes.interfaces.bgp_peers.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("bfd")] %}{% endif %}
{% set af = ["af-label-ucast"] %}
{% if peer.unicast_address_family | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.unicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-ucast")] %}{% endif %}

Verify SR MPLS L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }} Interface {{ loop.index }} BGP Peer {{ peer.ip }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${ip}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extLIfP.attributes.name=='{{ l3out_ip_name }}')]
    ${int}=   Set Variable   ${ip}..l3extLIfP.children[?(@.l3extRsPathL3OutAtt.attributes.tDn=='{{ tDn }}')]
    ${peer}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.bgpPeerP.attributes.addr=='{{ peer.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.addr   {{ peer.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.descr   {{ peer.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.peerCtrl   {{ peer_ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.ttl   {{ peer.ttl | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.ttl) }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.privateASctrl   {{ priv_as_ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.addrTCtrl   {{ af | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpPeerP.attributes.adminSt   {{ peer.admin_state | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpAsP.attributes.asn   {{ peer.remote_as }}
{% if peer.local_as is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpLocalAsnP.attributes.localAsn   {{ peer.local_as }}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpLocalAsnP.attributes.asnPropagate   {{ peer.as_propagate | default(defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.as_propagate) }}
{% endif %}
{% if peer.peer_prefix_policy is defined %}
{% set peer_prefix_policy_name = peer.peer_prefix_policy ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${peer}..bgpRsPeerPfxPol.attributes.tnBgpPeerPfxPolName   {{ peer_prefix_policy_name }}
{% endif %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% if l3out.inbound_route_map is defined %}

Verify SR MPLS L3out {{ l3out_name }} Inbound Route Map
    ${route_map}=   Set Variable   $..l3extOut.children[?(@.l3extConsLbl.attributes.name=={{ l3out.sr_mpls_infra_l3out }})]..children[?(@.l3extRsLblToProfile.attributes.direction=='import')]
    Should Be Equal Value Json String   ${r.json()}   ${route_map}..l3extRsLblToProfile.attributes.tDn   uni/tn-{{ tenant.name }}/prof-{{ l3out.inbound_route_map }}

{% endif %}

{% if l3out.outbound_route_map is defined %}

Verify SR MPLS L3out {{ l3out_name }} Outbound Route Map
    ${route_map}=   Set Variable    $..l3extOut.children[?(@.l3extConsLbl.attributes.name=={{ l3out.sr_mpls_infra_l3out }})]..children[?(@.l3extRsLblToProfile.attributes.direction=='export')]
    Should Be Equal Value Json String   ${r.json()}   ${route_map}..l3extRsLblToProfile.attributes.tDn   uni/tn-{{ tenant.name }}/prof-{{ l3out.outbound_route_map }}

{% endif %}

{% endfor %}
