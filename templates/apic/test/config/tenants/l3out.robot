{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify L3out
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% macro area_name(name) %}
    {% if name is number %}
    {% set area = "0.0.0." ~ name %}
    {% else %}
    {% set area = name %}
    {% endif %}
    {% set area_map = {"0.0.0.0": "backbone"} %}
    {{ area_map[area] | default(area) }}
{% endmacro %}

{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for l3out in tenant.l3outs | default([]) %}
{% set ns = namespace(bgp=false) %}
{% set l3out_name = l3out.name ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set l3out_np_name = l3out.name ~ defaults.apic.tenants.l3outs.node_profiles.name_suffix %}
{% set l3out_ip_name = l3out.name ~ defaults.apic.tenants.l3outs.node_profiles.interface_profiles.name_suffix %}
{% set domain_name = l3out.domain ~ defaults.apic.access_policies.routed_domains.name_suffix %}
{% set vrf_name = l3out.vrf ~ ('' if l3out.vrf in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}

Verify L3out {{ l3out_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/out-{{ l3out_name }}.json?rsp-subtree=full&rsp-prop-include=config-only"
    String   $..l3extOut.attributes.name   {{ l3out_name }}
    String   $..l3extOut.attributes.nameAlias   {{ l3out.alias  | default() }}
    String   $..l3extOut.attributes.descr   {{ l3out.description | default() }}
    String   $..l3extOut.attributes.targetDscp   {{ l3out.target_dscp | default(defaults.apic.tenants.l3outs.target_dscp) }}
    String   $..l3extRsL3DomAtt.attributes.tDn   uni/l3dom-{{ domain_name }}
    String   $..l3extRsEctx.attributes.tnFvCtxName   {{ vrf_name }}
{% if l3out.ospf is defined %}
    String   $..ospfExtP.attributes.areaCost   {{ l3out.ospf.area_cost | default(defaults.apic.tenants.l3outs.ospf.area_cost) }}
    String   $..ospfExtP.attributes.areaId   {{ area_name(l3out.ospf.area) }}
    String   $..ospfExtP.attributes.areaType   {{ l3out.ospf.area_type | default(defaults.apic.tenants.l3outs.ospf.area_type) }}
{% endif %}

{% if ((l3out.nodes | default([])) | length) > 0 %}

Verify L3out {{ l3out_name }} Profiles
    String   $..l3extLNodeP.attributes.name   {{ l3out_np_name }}
    String   $..l3extLIfP.attributes.name   {{ l3out_ip_name }}
    String   $..l3extLIfP.attributes.prio   {{ l3out.qos_class | default(defaults.apic.tenants.l3outs.qos_class) }}
{% if l3out.ospf is defined %}
    String   $..ospfIfP.attributes.name   {{ l3out.ospf.ospf_interface_profile_name | default(l3out.name) }}
    String   $..ospfIfP.attributes.authKeyId   {{ l3out.ospf.auth_key_id | default(defaults.apic.tenants.l3outs.ospf.auth_key_id) }}
    String   $..ospfIfP.attributes.authType   {{ l3out.ospf.auth_type | default(defaults.apic.tenants.l3outs.ospf.auth_type) }}
{% if l3out.ospf.policy is defined %}
{% set policy_name = l3out.ospf.policy ~ defaults.apic.tenants.policies.ospf_interface_policies.name_suffix %}
    String   $..ospfRsIfPol.attributes.tnOspfIfPolName   {{ policy_name }}
{% endif %}
{% endif %}
{% if l3out.bfd_policy is defined %}
{% set bfd_name = l3out.bfd_policy ~ defaults.apic.tenants.policies.bfd_interface_policies.name_suffix %}
    String   $..bfdRsIfPol.attributes.tnBfdIfPolName   {{ bfd_name }}
{% endif %}
{% if l3out.pim_policy is defined %}
{% set pim_name = l3out.pim_policy ~ defaults.apic.tenants.policies.pim_policies.name_suffix %}
    String   $..pimRsIfPol.attributes.tDn   uni/tn-{{tenant.name}}/pimifpol-{{ pim_name }}
{% endif %}
{% if l3out.igmp_interface_policy is defined %}
{% set igmp_name = l3out.igmp_interface_policy ~ defaults.apic.tenants.policies.igmp_interface_policies.name_suffix %}
    String   $..igmpRsIfPol.attributes.tDn   uni/tn-{{tenant.name}}/igmpIfPol-{{ igmp_name }}
{% endif %}
{% if l3out.custom_qos_policy is defined %}
{% set custom_qos_policy_name = l3out.custom_qos_policy ~ defaults.apic.tenants.policies.custom_qos.name_suffix %}
    String   $..l3extRsLIfPCustQosPol.attributes.tnQosCustomPolName   {{ custom_qos_policy_name }}
{% endif %}

{% for node in l3out.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.node_id ~ "`].pod" %}
{% set pod = node.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}

Verify L3out {{ l3out_name }} Node {{ node.node_id }}
    ${node}=   Set Variable   $..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node.node_id }}')]
    String   ${node}..l3extRsNodeL3OutAtt.attributes.tDn   topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node.node_id }}
    String   ${node}..l3extRsNodeL3OutAtt.attributes.rtrId   {{ node.router_id }}
    String   ${node}..l3extRsNodeL3OutAtt.attributes.rtrIdLoopBack   {{ node.router_id_as_loopback | default(defaults.apic.tenants.l3outs.nodes.router_id_as_loopback) | cisco.aac.aac_bool("yes") }}
{% if node.router_id_as_loopback | default(defaults.apic.tenants.l3outs.nodes.router_id_as_loopback) | cisco.aac.aac_bool("yes") == 'no' and node.loopback is defined %}
    String   ${node}..l3extLoopBackIfP.attributes.addr   {{ node.loopback }}
{% endif %}
{% if tenant.name == 'infra' %}
    String   ${node}..l3extInfraNodeP.attributes.fabricExtCtrlPeering   yes
{% endif %}

{% for sr in node.static_routes | default([]) %}

Verify L3out {{ l3out_name }} Node {{ node.node_id }} Static Route {{ sr.prefix }}
    ${node}=   Set Variable   $..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node.node_id }}')]
    ${route}=   Set Variable   ${node}..l3extRsNodeL3OutAtt.children[?(@.ipRouteP.attributes.ip=='{{ sr.prefix }}')]
    String   ${route}..ipRouteP.attributes.ip   {{ sr.prefix }}
    String   ${route}..ipRouteP.attributes.descr   {{ sr.description | default() }}
    String   ${route}..ipRouteP.attributes.pref   {{ sr.preference | default(defaults.apic.tenants.l3outs.nodes.static_routes.preference) }}
    String   ${route}..ipRouteP.attributes.rtCtrl   "{% if sr.bfd | default(defaults.apic.tenants.l3outs.nodes.static_routes.bfd) | cisco.aac.aac_bool("enabled") == "enabled" %}bfd{% endif %}"

{% for nh in sr.next_hops | default([]) %}

Verify L3out {{ l3out_name }} Node {{ node.node_id }} Static Route {{ sr.prefix }} Next Hop {{ nh.ip }}
    ${node}=   Set Variable   $..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.pod) }}/node-{{ node.node_id }}')]
    ${route}=   Set Variable   ${node}..l3extRsNodeL3OutAtt.children[?(@.ipRouteP.attributes.ip=='{{ sr.prefix }}')]
    ${nh}=   Set Variable   ${route}..ipRouteP.children[?(@.ipNexthopP.attributes.nhAddr=='{{ nh.ip }}')]
    String   ${nh}..ipNexthopP.attributes.nhAddr   {{ nh.ip }}
    String   ${nh}..ipNexthopP.attributes.pref   {{ nh.preference | default(defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.next_hops.preference) }}
    String   ${nh}..ipNexthopP.attributes.type   {{ nh.type | default(defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.next_hops.type) }}

{% endfor %}

{% endfor %}

{% endfor %}

{% for peer in l3out.bgp_peers | default([]) %}
{% set ctrl = [] %}
{% if peer.allow_self_as | default(defaults.apic.tenants.l3outs.bgp_peers.allow_self_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-self-as")] %}{% endif %}
{% if peer.as_override | default(defaults.apic.tenants.l3outs.bgp_peers.as_override) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("as-override")] %}{% endif %}
{% if peer.disable_peer_as_check | default(defaults.apic.tenants.l3outs.bgp_peers.disable_peer_as_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("dis-peer-as-check")] %}{% endif %}
{% if peer.next_hop_self | default(defaults.apic.tenants.l3outs.bgp_peers.next_hop_self) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("nh-sel")] %}{% endif %}
{% if peer.send_community | default(defaults.apic.tenants.l3outs.bgp_peers.send_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("send-com")] %}{% endif %}
{% if peer.send_ext_community | default(defaults.apic.tenants.l3outs.bgp_peers.send_ext_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("end-ext-com")] %}{% endif %}
{% set peer_ctrl = [] %}
{% if peer.bfd | default(defaults.apic.tenants.l3outs.bgp_peers.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("bfd")] %}{% endif %}
{% if peer.disable_connected_check | default(defaults.apic.tenants.l3outs.bgp_peers.disable_connected_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("dis-conn-check")] %}{% endif %}
{% set priv_as_ctrl = [] %}
{% if peer.remove_all_private_as | default(defaults.apic.tenants.l3outs.bgp_peers.remove_all_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-all")] %}{% endif %}
{% if peer.remove_private_as | default(defaults.apic.tenants.l3outs.bgp_peers.remove_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-exclusive")] %}{% endif %}
{% if peer.replace_private_as_with_local_as | default(defaults.apic.tenants.l3outs.bgp_peers.replace_private_as_with_local_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("replace-as")] %}{% endif %}
{% set af = [] %}
{% if peer.multicast_address_family | default(defaults.apic.tenants.l3outs.bgp_peers.multicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-mcast")] %}{% endif %}
{% if peer.unicast_address_family | default(defaults.apic.tenants.l3outs.bgp_peers.unicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-ucast")] %}{% endif %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} BGP Peer {{ peer.ip }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${peer}=   Set Variable   ${np}..children[?(@.bgpPeerP.attributes.addr=='{{ peer.ip }}')]
    String   ${peer}..bgpPeerP.attributes.addr   {{ peer.ip }}
    String   ${peer}..bgpPeerP.attributes.descr   {{ peer.description | default() }}
    String   ${peer}..bgpPeerP.attributes.ctrl   {{ ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.allowedSelfAsCnt   {{ peer.allowed_self_as_count |default(defaults.apic.tenants.l3outs.bgp_peers.allowed_self_as_count) }}
    String   ${peer}..bgpPeerP.attributes.peerCtrl   {{ peer_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.ttl   {{ peer.ttl | default(defaults.apic.tenants.l3outs.bgp_peers.ttl) }}
    String   ${peer}..bgpPeerP.attributes.weight   {{ peer.weight | default(defaults.apic.tenants.l3outs.bgp_peers.weight) }}
    String   ${peer}..bgpPeerP.attributes.privateASctrl   {{ priv_as_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.addrTCtrl   {{ af | join(',') }}
    String   ${peer}..bgpPeerP.attributes.adminSt   {{ peer.admin_state | default(defaults.apic.tenants.l3outs.bgp_peers.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   ${peer}..bgpAsP.attributes.asn   {{ peer.remote_as }}
{% if peer.local_as is defined %}
    String   ${peer}..bgpLocalAsnP.attributes.localAsn   {{ peer.local_as }}
    String   ${peer}..bgpLocalAsnP.attributes.asnPropagate   {{ peer.as_propagate | default(defaults.apic.tenants.l3outs.bgp_peers.as_propagate) }}
{% endif %}
{% if peer.peer_prefix_policy is defined %}
{% set peer_prefix_policy_name = peer.peer_prefix_policy ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}
    String   ${peer}..bgpRsPeerPfxPol.attributes.tnBgpPeerPfxPolName   {{ peer_prefix_policy_name }}
{% endif %}
{% if peer.export_route_control is defined %}
{% set export_route_control_name = peer.export_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${export_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='export')]
    String   ${export_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name }}/prof-{{ export_route_control_name }}
{% endif %}
{% if peer.import_route_control is defined %}
{% set import_route_control_name = peer.import_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${import_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='import')]
    String   ${import_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name}}/prof-{{ import_route_control_name }}
{% endif %}

{% endfor %}

{% for node in l3out.nodes | default([]) %}
{% for int in node.interfaces | default([]) %}

Verify L3out {{ l3out_name }} Node {{ node.node_id }} Interface {{ loop.index }}
{% if int.port is defined or int.floating_svi | default(defaults.apic.tenants.l3outs.nodes.interfaces.floating_svi) | cisco.aac.aac_bool("yes") == 'yes' %}
{% set type = 'ap' %}
{% set query = "nodes[?id==`" ~ node.node_id ~ "`].pod" %}
{% set pod = node.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% else %}
{% set policy_group_name = int.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ int.channel ~ "`].type" %}
{% set type = (apic.access_policies | community.general.json_query(query))[0] %}
{% if int.node_id is defined %}
    {% set node_ = int.node_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node_ = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
{% endif %}
{% set query = "nodes[?id==`" ~ node_ ~ "`].pod" %}
{% set pod = node.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% if type == 'vpc' %}
{% if int.node2_id is defined %}
    {% set node2 = int.node2_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node2 = (apic.interface_policies | default() | community.general.json_query(query))[1] %}
{% endif %}
{% endif %}
{% endif %}
{% if int.floating_svi | default(defaults.apic.tenants.l3outs.nodes.interfaces.floating_svi) | cisco.aac.aac_bool("yes") == 'no' %}
{% if type == 'ap' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.l3outs.nodes.interfaces.pod) ~ "/paths-" ~ node.node_id ~ "/pathep-[eth" ~ int.module | default(defaults.apic.tenants.l3outs.nodes.interfaces.module) ~ "/" ~ int.port ~ "]" %}
{% elif type == 'pc' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.l3outs.nodes.interfaces.pod) ~ "/paths-" ~ node_ ~ "/pathep-[" ~ policy_group_name ~ "]" %}
{% elif type == 'vpc' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.l3outs.nodes.interfaces.pod) ~ "/protpaths-" ~ node_ ~ "-" ~ node2 ~ "/pathep-[" ~ policy_group_name ~ "]" %}
{% endif %}
    ${int}=   Set Variable   $..l3extLIfP.children[?(@.l3extRsPathL3OutAtt.attributes.tDn=='{{ tDn }}')]
    String   ${int}..l3extRsPathL3OutAtt.attributes.addr   {{ defaults.apic.tenants.l3outs.nodes.interfaces.ip if type == 'vpc' else int.ip }}
    String   ${int}..l3extRsPathL3OutAtt.attributes.descr   {{ int.description | default() }}
{% if int.vlan is defined %}
    String   ${int}..l3extRsPathL3OutAtt.attributes.ifInstT   {{ 'ext-svi' if int.svi | default(defaults.apic.tenants.l3outs.nodes.interfaces.svi) | cisco.aac.aac_bool("yes") == 'yes' else 'sub-interface'}}
    String   ${int}..l3extRsPathL3OutAtt.attributes.encap   vlan-{{ int.vlan }}
{% else %}
    String   ${int}..l3extRsPathL3OutAtt.attributes.ifInstT   l3-port
{% endif %}
    String   ${int}..l3extRsPathL3OutAtt.attributes.mac   {{ int.mac | default(defaults.apic.tenants.l3outs.nodes.interfaces.mac) }}
    String   ${int}..l3extRsPathL3OutAtt.attributes.mtu   {{ int.mtu | default(defaults.apic.tenants.l3outs.nodes.interfaces.mtu) }}
    String   ${int}..l3extRsPathL3OutAtt.attributes.tDn   {{ tDn }}
{% if type != 'vpc' and int.ip_shared is defined %}
    String   ${int}..l3extIp.attributes.addr   {{ int.ip_shared }}
{% endif %}
{% if type == 'vpc' %}
    ${ip1}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.l3extMember.attributes.addr=='{{ int.ip_a }}')]
    String   ${ip1}..l3extMember.attributes.addr   {{ int.ip_a }}
    String   ${ip1}..l3extIp.attributes.addr   {{ int.ip_shared }}
    ${ip2}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.l3extMember.attributes.addr=='{{ int.ip_b }}')]
    String   ${ip2}..l3extMember.attributes.addr   {{ int.ip_b }}
    String   ${ip2}..l3extIp.attributes.addr   {{ int.ip_shared }}
{% endif %}
{% else %}
    ${int}=   Set Variable   $..l3extLIfP.children[?(@.l3extVirtualLIfP.attributes.nodeDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.interfaces.pod) }}/node-{{ node.node_id }}' & @.l3extVirtualLIfP.attributes.encap=='vlan-{{ int.vlan }}')]
    String   ${int}..l3extVirtualLIfP.attributes.addr   {{ int.ip }}
    String   ${int}..l3extVirtualLIfP.attributes.descr   {{ int.description | default() }}
    String   ${int}..l3extVirtualLIfP.attributes.ifInstT   ext-svi
    String   ${int}..l3extVirtualLIfP.attributes.encap   vlan-{{ int.vlan }}
    String   ${int}..l3extVirtualLIfP.attributes.mac   {{ int.mac | default(defaults.apic.tenants.l3outs.nodes.interfaces.mac) }}
    String   ${int}..l3extVirtualLIfP.attributes.mode   regular
    String   ${int}..l3extVirtualLIfP.attributes.mtu   {{ int.mtu | default(defaults.apic.tenants.l3outs.nodes.interfaces.mtu) }}
    String   ${int}..l3extVirtualLIfP.attributes.nodeDn   topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.interfaces.pod) }}/node-{{ node.node_id }}
{% endif %}

{% if int.floating_svi | default(defaults.apic.tenants.l3outs.nodes.interfaces.floating_svi) | cisco.aac.aac_bool("yes") == 'yes' %}
{% for path in int.paths | default([]) %}

Verify L3out {{ l3out_name }} Node {{ node.node_id }} Interface {{ loop.index }} Path {{ path.floating_ip }}
    ${int}=   Set Variable   $..l3extLIfP.children[?(@.l3extVirtualLIfP.attributes.nodeDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.nodes.interfaces.pod) }}/node-{{ node.node_id }}' & @.l3extVirtualLIfP.attributes.encap=='vlan-{{ int.vlan }}')]
    ${path}=   Set Variable   ${int}..l3extVirtualLIfP.children[?(@.l3extRsDynPathAtt.attributes.floatingAddr=='{{ path.floating_ip }}')]
    String   ${path}..l3extRsDynPathAtt.attributes.floatingAddr   {{ path.floating_ip }}
    String   ${path}..l3extRsDynPathAtt.attributes.tDn   uni/phys-{{ path.physical_domain }}

{% endfor %}
{% endif %}

{% for peer in int.bgp_peers | default([]) %}
{% set ns.bgp = true %}
{% set ctrl = [] %}
{% if peer.allow_self_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.allow_self_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-self-as")] %}{% endif %}
{% if peer.as_override | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.as_override) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("as-override")] %}{% endif %}
{% if peer.disable_peer_as_check | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.disable_peer_as_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("dis-peer-as-check")] %}{% endif %}
{% if peer.next_hop_self | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.next_hop_self) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("nh-sel")] %}{% endif %}
{% if peer.send_community | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.send_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("send-com")] %}{% endif %}
{% if peer.send_ext_community | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.send_ext_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("end-ext-com")] %}{% endif %}
{% set peer_ctrl = [] %}
{% if peer.bfd | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("bfd")] %}{% endif %}
{% if peer.disable_connected_check | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.disable_connected_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("dis-conn-check")] %}{% endif %}
{% set priv_as_ctrl = [] %}
{% if peer.remove_all_private_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.remove_all_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-all")] %}{% endif %}
{% if peer.remove_private_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.remove_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-exclusive")] %}{% endif %}
{% if peer.replace_private_as_with_local_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.replace_private_as_with_local_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("replace-as")] %}{% endif %}
{% set af = [] %}
{% if peer.multicast_address_family | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.multicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-mcast")] %}{% endif %}
{% if peer.unicast_address_family | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.unicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-ucast")] %}{% endif %}

Verify L3out {{ l3out_name }} Node {{ node.node_id }} Interface {{ loop.index }} BGP Peer {{ peer.ip }}
    ${int}=   Set Variable   $..l3extLIfP.children[?(@.l3extRsPathL3OutAtt.attributes.tDn=='{{ tDn }}')]
    ${peer}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.bgpPeerP.attributes.addr=='{{ peer.ip }}')]
    String   ${peer}..bgpPeerP.attributes.addr   {{ peer.ip }}
    String   ${peer}..bgpPeerP.attributes.descr   {{ peer.description | default() }}
    String   ${peer}..bgpPeerP.attributes.ctrl   {{ ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.allowedSelfAsCnt   {{ peer.allowed_self_as_count |default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.allowed_self_as_count) }}
    String   ${peer}..bgpPeerP.attributes.peerCtrl   {{ peer_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.ttl   {{ peer.ttl | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.ttl) }}
    String   ${peer}..bgpPeerP.attributes.weight   {{ peer.weight | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.weight) }}
    String   ${peer}..bgpPeerP.attributes.privateASctrl   {{ priv_as_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.addrTCtrl   {{ af | join(',') }}
    String   ${peer}..bgpPeerP.attributes.adminSt   {{ peer.admin_state | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   ${peer}..bgpAsP.attributes.asn   {{ peer.remote_as }}
{% if peer.local_as is defined %}
    String   ${peer}..bgpLocalAsnP.attributes.localAsn   {{ peer.local_as }}
    String   ${peer}..bgpLocalAsnP.attributes.asnPropagate   {{ peer.as_propagate | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.as_propagate) }}
{% endif %}
{% if peer.peer_prefix_policy is defined %}
{% set peer_prefix_policy_name = peer.peer_prefix_policy ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}
    String   ${peer}..bgpRsPeerPfxPol.attributes.tnBgpPeerPfxPolName   {{ peer_prefix_policy_name }}
{% endif %}
{% if peer.export_route_control is defined %}
{% set export_route_control_name = peer.export_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${export_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='export')]
    String   ${export_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name }}/prof-{{ export_route_control_name }}
{% endif %}
{% if peer.import_route_control is defined %}
{% set import_route_control_name = peer.import_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${import_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='import')]
    String   ${import_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name}}/prof-{{ import_route_control_name }}
{% endif %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endif %}

{% for np in l3out.node_profiles | default([]) %}
{% set l3out_np_name = np.name ~ defaults.apic.tenants.l3outs.node_profiles.name_suffix %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    String   ${np}..l3extLNodeP.attributes.name   {{ l3out_np_name }}

{% for node in np.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.node_id ~ "`].pod" %}
{% set pod = node.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Node {{ node.node_id }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${node}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.nodes.pod) }}/node-{{ node.node_id }}')]
    String   ${node}..l3extRsNodeL3OutAtt.attributes.tDn   topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.nodes.pod) }}/node-{{ node.node_id }}
    String   ${node}..l3extRsNodeL3OutAtt.attributes.rtrId   {{ node.router_id }}
    String   ${node}..l3extRsNodeL3OutAtt.attributes.rtrIdLoopBack   {{ node.router_id_as_loopback | default(defaults.apic.tenants.l3outs.node_profiles.nodes.router_id_as_loopback) | cisco.aac.aac_bool("yes") }}
{% if node.router_id_as_loopback | default(defaults.apic.tenants.l3outs.node_profiles.nodes.router_id_as_loopback) | cisco.aac.aac_bool("yes") == 'no' and node.loopback is defined %}
    String   ${node}..l3extLoopBackIfP.attributes.addr   {{ node.loopback }}
{% endif %}
{% if tenant.name == 'infra' %}
    String   ${node}..l3extInfraNodeP.attributes.fabricExtCtrlPeering   yes
{% endif %}

{% for sr in node.static_routes | default([]) %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Node {{ node.node_id }} Static Route {{ sr.prefix }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${node}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.nodes.pod) }}/node-{{ node.node_id }}')]
    ${route}=   Set Variable   ${node}..l3extRsNodeL3OutAtt.children[?(@.ipRouteP.attributes.ip=='{{ sr.prefix }}')]
    String   ${route}..ipRouteP.attributes.ip   {{ sr.prefix }}
    String   ${route}..ipRouteP.attributes.descr   {{ sr.description | default() }}
    String   ${route}..ipRouteP.attributes.pref   {{ sr.preference | default(defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.preference) }}
    String   ${route}..ipRouteP.attributes.rtCtrl   "{% if sr.bfd | default(defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.bfd) | cisco.aac.aac_bool("enabled") == "enabled" %}bfd{% endif %}"

{% for nh in sr.next_hops | default([]) %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Node {{ node.node_id }} Static Route {{ sr.prefix }} Next Hop {{ nh.ip }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${node}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extRsNodeL3OutAtt.attributes.tDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.nodes.pod) }}/node-{{ node.node_id }}')]
    ${route}=   Set Variable   ${node}..l3extRsNodeL3OutAtt.children[?(@.ipRouteP.attributes.ip=='{{ sr.prefix }}')]
    ${nh}=   Set Variable   ${route}..ipRouteP.children[?(@.ipNexthopP.attributes.nhAddr=='{{ nh.ip }}')]
    String   ${nh}..ipNexthopP.attributes.nhAddr   {{ nh.ip }}
    String   ${nh}..ipNexthopP.attributes.pref   {{ nh.preference | default(defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.next_hops.preference) }}
    String   ${nh}..ipNexthopP.attributes.type   {{ nh.type | default(defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.next_hops.type) }}

{% endfor %}

{% endfor %}

{% for peer in np.bgp_peers | default([]) %}
{% set ctrl = [] %}
{% if peer.allow_self_as | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.allow_self_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-self-as")] %}{% endif %}
{% if peer.as_override | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.as_override) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("as-override")] %}{% endif %}
{% if peer.disable_peer_as_check | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.disable_peer_as_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("dis-peer-as-check")] %}{% endif %}
{% if peer.next_hop_self | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.next_hop_self) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("nh-sel")] %}{% endif %}
{% if peer.send_community | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.send_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("send-com")] %}{% endif %}
{% if peer.send_ext_community | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.send_ext_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("end-ext-com")] %}{% endif %}
{% set peer_ctrl = [] %}
{% if peer.bfd | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("bfd")] %}{% endif %}
{% if peer.disable_connected_check | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.disable_connected_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("dis-conn-check")] %}{% endif %}
{% set priv_as_ctrl = [] %}
{% if peer.remove_all_private_as | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.remove_all_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-all")] %}{% endif %}
{% if peer.remove_private_as | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.remove_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-exclusive")] %}{% endif %}
{% if peer.replace_private_as_with_local_as | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.replace_private_as_with_local_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("replace-as")] %}{% endif %}
{% set af = [] %}
{% if peer.multicast_address_family | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.multicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-mcast")] %}{% endif %}
{% if peer.unicast_address_family | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.unicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-ucast")] %}{% endif %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} BGP Peer {{ peer.ip }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${peer}=   Set Variable   ${np}..children[?(@.bgpPeerP.attributes.addr=='{{ peer.ip }}')]
    String   ${peer}..bgpPeerP.attributes.addr   {{ peer.ip }}
    String   ${peer}..bgpPeerP.attributes.descr   {{ peer.description | default() }}
    String   ${peer}..bgpPeerP.attributes.ctrl   {{ ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.allowedSelfAsCnt   {{ peer.allowed_self_as_count |default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.allowed_self_as_count) }}
    String   ${peer}..bgpPeerP.attributes.peerCtrl   {{ peer_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.ttl   {{ peer.ttl | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.ttl) }}
    String   ${peer}..bgpPeerP.attributes.weight   {{ peer.weight | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.weight) }}
    String   ${peer}..bgpPeerP.attributes.privateASctrl   {{ priv_as_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.addrTCtrl   {{ af | join(',') }}
    String   ${peer}..bgpPeerP.attributes.adminSt   {{ peer.admin_state | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   ${peer}..bgpAsP.attributes.asn   {{ peer.remote_as }}
{% if peer.local_as is defined %}
    String   ${peer}..bgpLocalAsnP.attributes.localAsn   {{ peer.local_as }}
    String   ${peer}..bgpLocalAsnP.attributes.asnPropagate   {{ peer.as_propagate | default(defaults.apic.tenants.l3outs.node_profiles.bgp_peers.as_propagate) }}
{% endif %}
{% if peer.peer_prefix_policy is defined %}
{% set peer_prefix_policy_name = peer.peer_prefix_policy ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}
    String   ${peer}..bgpRsPeerPfxPol.attributes.tnBgpPeerPfxPolName   {{ peer_prefix_policy_name }}
{% endif %}
{% if peer.export_route_control is defined %}
{% set export_route_control_name = peer.export_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${export_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='export')]
    String   ${export_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name }}/prof-{{ export_route_control_name }}
{% endif %}
{% if peer.import_route_control is defined %}
{% set import_route_control_name = peer.import_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${import_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='import')]
    String   ${import_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name}}/prof-{{ import_route_control_name }}
{% endif %}

{% endfor %}

{% for ip in np.interface_profiles | default([]) %}
{% set l3out_ip_name = ip.name ~ defaults.apic.tenants.l3outs.node_profiles.interface_profiles.name_suffix %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${ip}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extLIfP.attributes.name=='{{ l3out_ip_name }}')]
    String   ${ip}..l3extLIfP.attributes.name   {{ l3out_ip_name }}
    String   ${ip}..l3extLIfP.attributes.prio   {{ ip.qos_class | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.qos_class) }}
{% if ip.ospf is defined %}
    String   ${ip}..ospfIfP.attributes.name   {{ ip.ospf.ospf_interface_profile_name | default(l3out.name) }}
    String   ${ip}..ospfIfP.attributes.authKeyId   {{ ip.ospf.auth_key_id | default(defaults.apic.tenants.l3outs.ospf.auth_key_id) }}
    String   ${ip}..ospfIfP.attributes.authType   {{ ip.ospf.auth_type | default(defaults.apic.tenants.l3outs.ospf.auth_type) }}
{% if ip.ospf.policy is defined %}
{% set policy_name = ip.ospf.policy ~ defaults.apic.tenants.policies.ospf_interface_policies.name_suffix %}
    String   ${ip}..ospfRsIfPol.attributes.tnOspfIfPolName   {{ policy_name }}
{% endif %}
{% endif %}
{% if ip.bfd_policy is defined %}
{% set bfd_name = ip.bfd_policy ~ defaults.apic.tenants.policies.bfd_interface_policies.name_suffix %}
    String   ${ip}..bfdRsIfPol.attributes.tnBfdIfPolName   {{ bfd_name }}
{% endif %}
{% if ip.pim_policy is defined %}
{% set pim_name = ip.pim_policy ~ defaults.apic.tenants.policies.pim_policies.name_suffix %}
    String   ${ip}..pimRsIfPol.attributes.tDn   uni/tn-{{tenant.name}}/pimifpol-{{ pim_name }}
{% endif %}
{% if ip.igmp_interface_policy is defined %}
{% set igmp_name = ip.igmp_interface_policy ~ defaults.apic.tenants.policies.igmp_interface_policies.name_suffix %}
    String   ${ip}..igmpRsIfPol.attributes.tDn   uni/tn-{{tenant.name}}/igmpIfPol-{{ igmp_name }}
{% endif %}
{% if ip.custom_qos_policy is defined %}
{% set custom_qos_policy_name = ip.custom_qos_policy ~ defaults.apic.tenants.policies.custom_qos.name_suffix %}
    String   ${ip}..l3extRsLIfPCustQosPol.attributes.tnQosCustomPolName   {{ custom_qos_policy_name }}
{% endif %}

{% for int in ip.interfaces | default([]) %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }} Interface {{ loop.index }}
{% if int.port is defined or int.floating_svi | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.floating_svi) | cisco.aac.aac_bool("yes") == 'yes' %}
{% set type = 'ap' %}
{% set query = "nodes[?id==`" ~ int.node_id ~ "`].pod" %}
{% set pod = int.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% else %}
{% set policy_group_name = int.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ int.channel ~ "`].type" %}
{% set type = (apic.access_policies | community.general.json_query(query))[0] %}
{% if int.node_id is defined %}
    {% set node_ = int.node_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node_ = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
{% endif %}
{% set query = "nodes[?id==`" ~ node_ ~ "`].pod" %}
{% set pod = int.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}
{% if type == 'vpc' %}
{% if int.node2_id is defined %}
    {% set node2 = int.node2_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node2 = (apic.interface_policies | default() | community.general.json_query(query))[1] %}
{% endif %}
{% endif %}
{% endif %}
{% if int.floating_svi | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.floating_svi) | cisco.aac.aac_bool("yes") == 'no' %}
{% if type == 'ap' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) ~ "/paths-" ~ int.node_id ~ "/pathep-[eth" ~ int.module | default(defaults.apic.tenants.l3outs.nodes.interfaces.module) ~ "/" ~ int.port ~ "]" %}
{% elif type == 'pc' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) ~ "/paths-" ~ node_ ~ "/pathep-[" ~ policy_group_name ~ "]" %}
{% elif type == 'vpc' %}
{% set tDn = "topology/pod-" ~ pod | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) ~ "/protpaths-" ~ node_ ~ "-" ~ node2 ~ "/pathep-[" ~ policy_group_name ~ "]" %}
{% endif %}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${ip}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extLIfP.attributes.name=='{{ l3out_ip_name }}')]
    ${int}=   Set Variable   ${ip}..l3extLIfP.children[?(@.l3extRsPathL3OutAtt.attributes.tDn=='{{ tDn }}')]
    String   ${int}..l3extRsPathL3OutAtt.attributes.addr   {{ defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.ip if type == 'vpc' else int.ip }}
    String   ${int}..l3extRsPathL3OutAtt.attributes.descr   {{ int.description | default() }}
{% if int.vlan is defined %}
    String   ${int}..l3extRsPathL3OutAtt.attributes.ifInstT   {{ 'ext-svi' if int.svi | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.svi) | cisco.aac.aac_bool("yes") == 'yes' else 'sub-interface'}}
    String   ${int}..l3extRsPathL3OutAtt.attributes.encap   vlan-{{ int.vlan }}
{% else %}
    String   ${int}..l3extRsPathL3OutAtt.attributes.ifInstT   l3-port
{% endif %}
    String   ${int}..l3extRsPathL3OutAtt.attributes.mac   {{ int.mac | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mac) }}
    String   ${int}..l3extRsPathL3OutAtt.attributes.mtu   {{ int.mtu | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mtu) }}
    String   ${int}..l3extRsPathL3OutAtt.attributes.tDn   {{ tDn }}
{% if type != 'vpc' and int.ip_shared is defined %}
    String   ${int}..l3extIp.attributes.addr   {{ int.ip_shared }}
{% endif %}
{% if type == 'vpc' %}
    ${ip1}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.l3extMember.attributes.addr=='{{ int.ip_a }}')]
    String   ${ip1}..l3extMember.attributes.addr   {{ int.ip_a }}
    String   ${ip1}..l3extIp.attributes.addr   {{ int.ip_shared }}
    ${ip2}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.l3extMember.attributes.addr=='{{ int.ip_b }}')]
    String   ${ip2}..l3extMember.attributes.addr   {{ int.ip_b }}
    String   ${ip2}..l3extIp.attributes.addr   {{ int.ip_shared }}
{% endif %}
{% else %}
    ${int}=   Set Variable   $..l3extLIfP.children[?(@.l3extVirtualLIfP.attributes.nodeDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) }}/node-{{ int.node_id }}' & @.l3extVirtualLIfP.attributes.encap=='vlan-{{ int.vlan }}')]
    String   ${int}..l3extVirtualLIfP.attributes.addr   {{ int.ip }}
    String   ${int}..l3extVirtualLIfP.attributes.descr   {{ int.description | default() }}
    String   ${int}..l3extVirtualLIfP.attributes.ifInstT   ext-svi
    String   ${int}..l3extVirtualLIfP.attributes.encap   vlan-{{ int.vlan }}
    String   ${int}..l3extVirtualLIfP.attributes.mac   {{ int.mac | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mac) }}
    String   ${int}..l3extVirtualLIfP.attributes.mode   regular
    String   ${int}..l3extVirtualLIfP.attributes.mtu   {{ int.mtu | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mtu) }}
    String   ${int}..l3extVirtualLIfP.attributes.nodeDn   topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) }}/node-{{ int.node_id }}
{% endif %}

{% if int.floating_svi | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.floating_svi) | cisco.aac.aac_bool("yes") == 'yes' %}
{% for path in int.paths | default([]) %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }} Interface {{ loop.index }} Path {{ path.floating_ip }}
    ${int}=   Set Variable   $..l3extLIfP.children[?(@.l3extVirtualLIfP.attributes.nodeDn=='topology/pod-{{ pod | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) }}/node-{{ int.node_id }}' & @.l3extVirtualLIfP.attributes.encap=='vlan-{{ int.vlan }}')]
    ${path}=   Set Variable   ${int}..l3extVirtualLIfP.children[?(@.l3extRsDynPathAtt.attributes.floatingAddr=='{{ path.floating_ip }}')]
    String   ${path}..l3extRsDynPathAtt.attributes.floatingAddr   {{ path.floating_ip }}
    String   ${path}..l3extRsDynPathAtt.attributes.tDn   uni/phys-{{ path.physical_domain }}

{% endfor %}
{% endif %}

{% for peer in int.bgp_peers | default([]) %}
{% set ns.bgp = true %}
{% set ctrl = [] %}
{% if peer.allow_self_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.allow_self_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("allow-self-as")] %}{% endif %}
{% if peer.as_override | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.as_override) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("as-override")] %}{% endif %}
{% if peer.disable_peer_as_check | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.disable_peer_as_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("dis-peer-as-check")] %}{% endif %}
{% if peer.next_hop_self | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.next_hop_self) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("nh-sel")] %}{% endif %}
{% if peer.send_community | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.send_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("send-com")] %}{% endif %}
{% if peer.send_ext_community | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.send_ext_community) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("end-ext-com")] %}{% endif %}
{% set peer_ctrl = [] %}
{% if peer.bfd | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.bfd) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("bfd")] %}{% endif %}
{% if peer.disable_connected_check | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.disable_connected_check) | cisco.aac.aac_bool("yes") == "yes" %}{% set peer_ctrl = peer_ctrl + [("dis-conn-check")] %}{% endif %}
{% set priv_as_ctrl = [] %}
{% if peer.remove_all_private_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.remove_all_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-all")] %}{% endif %}
{% if peer.remove_private_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.remove_private_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("remove-exclusive")] %}{% endif %}
{% if peer.replace_private_as_with_local_as | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.replace_private_as_with_local_as) | cisco.aac.aac_bool("yes") == "yes" %}{% set priv_as_ctrl = priv_as_ctrl + [("replace-as")] %}{% endif %}
{% set af = [] %}
{% if peer.multicast_address_family | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.multicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-mcast")] %}{% endif %}
{% if peer.unicast_address_family | default(defaults.apic.tenants.l3outs.nodes.interfaces.bgp_peers.unicast_address_family) | cisco.aac.aac_bool("yes") == "yes" %}{% set af = af + [("af-ucast")] %}{% endif %}

Verify L3out {{ l3out_name }} Node Profile {{ l3out_np_name }} Interface Profile {{ l3out_ip_name }} Interface {{ loop.index }} BGP Peer {{ peer.ip }}
    ${np}=   Set Variable   $..l3extOut.children[?(@.l3extLNodeP.attributes.name=='{{ l3out_np_name }}')]
    ${ip}=   Set Variable   ${np}..l3extLNodeP.children[?(@.l3extLIfP.attributes.name=='{{ l3out_ip_name }}')]
    ${int}=   Set Variable   ${ip}..l3extLIfP.children[?(@.l3extRsPathL3OutAtt.attributes.tDn=='{{ tDn }}')]
    ${peer}=   Set Variable   ${int}..l3extRsPathL3OutAtt.children[?(@.bgpPeerP.attributes.addr=='{{ peer.ip }}')]
    String   ${peer}..bgpPeerP.attributes.addr   {{ peer.ip }}
    String   ${peer}..bgpPeerP.attributes.descr   {{ peer.description | default() }}
    String   ${peer}..bgpPeerP.attributes.ctrl   {{ ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.allowedSelfAsCnt   {{ peer.allowed_self_as_count |default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.allowed_self_as_count) }}
    String   ${peer}..bgpPeerP.attributes.peerCtrl   {{ peer_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.ttl   {{ peer.ttl | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.ttl) }}
    String   ${peer}..bgpPeerP.attributes.weight   {{ peer.weight | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.weight) }}
    String   ${peer}..bgpPeerP.attributes.privateASctrl   {{ priv_as_ctrl | join(',') }}
    String   ${peer}..bgpPeerP.attributes.addrTCtrl   {{ af | join(',') }}
    String   ${peer}..bgpPeerP.attributes.adminSt   {{ peer.admin_state | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   ${peer}..bgpAsP.attributes.asn   {{ peer.remote_as }}
{% if peer.local_as is defined %}
    String   ${peer}..bgpLocalAsnP.attributes.localAsn   {{ peer.local_as }}
    String   ${peer}..bgpLocalAsnP.attributes.asnPropagate   {{ peer.as_propagate | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.as_propagate) }}
{% endif %}
{% if peer.peer_prefix_policy is defined %}
{% set peer_prefix_policy_name = peer.peer_prefix_policy ~ defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix %}
    String   ${peer}..bgpRsPeerPfxPol.attributes.tnBgpPeerPfxPolName   {{ peer_prefix_policy_name }}
{% endif %}
{% if peer.export_route_control is defined %}
{% set export_route_control_name = peer.export_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${export_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='export')]
    String   ${export_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name }}/prof-{{ export_route_control_name }}
{% endif %}
{% if peer.import_route_control is defined %}
{% set import_route_control_name = peer.import_route_control ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix  %}
    ${import_rc}=   Set Variable   ${peer}..children[?(@.bgpRsPeerToProfile.attributes.direction=='import')]
    String   ${import_rc}..bgpRsPeerToProfile.attributes.tDn   uni/tn-{{ tenant.name}}/prof-{{ import_route_control_name }}
{% endif %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% if l3out.import_route_map is defined %}

Verify L3out {{ l3out_name }} Import Route Map
    ${route_map}=   Set Variable   $..l3extOut.children[?(@.rtctrlProfile.attributes.name=='default-import')]
    String   ${route_map}..rtctrlProfile.attributes.descr   {{ context.description | default() }}
    String   ${route_map}..rtctrlProfile.attributes.type   {{ l3out.import_route_map.type | default(defaults.apic.tenants.l3outs.import_route_map.type) }}

{% for context in l3out.import_route_map.contexts | default([]) %}
{% set context_name = context.name ~ defaults.apic.tenants.l3outs.import_route_map.contexts.name_suffix %}

Verify L3out {{ l3out_name }} Import Route Map Context {{ context_name }}
    ${route_map}=   Set Variable   $..l3extOut.children[?(@.rtctrlProfile.attributes.name=='default-import')]
    ${context}=   Set Variable   ${route_map}..rtctrlProfile.children[?(@.rtctrlCtxP.attributes.name=='{{ context_name }}')]
    String   ${context}..rtctrlCtxP.attributes.name   {{ context_name }}
    String   ${context}..rtctrlCtxP.attributes.descr   {{ context.description | default() }}
    String   ${context}..rtctrlCtxP.attributes.action   {{ context.action | default(defaults.apic.tenants.l3outs.import_route_map.contexts.action) }}
    String   ${context}..rtctrlCtxP.attributes.order   {{ context.order | default(defaults.apic.tenants.l3outs.import_route_map.contexts.order) }}
{% if context.set_rule is defined %}
{% set rule_name = context.set_rule ~ defaults.apic.tenants.policies.set_rules.name_suffix %}
    String   ${context}..rtctrlRsScopeToAttrP.attributes.tnRtctrlAttrPName   {{ rule_name }}
{% endif %}
{% if context.match_rule is defined %}
{% set rule_name = context.match_rule ~ defaults.apic.tenants.policies.match_rules.name_suffix %}
    String   ${context}..rtctrlRsCtxPToSubjP.attributes.tnRtctrlSubjPName   {{ rule_name }}
{% endif %}

{% endfor %}

{% endif %}

{% if l3out.export_route_map is defined %}

Verify L3out {{ l3out_name }} Export Route Map
    ${route_map}=   Set Variable   $..l3extOut.children[?(@.rtctrlProfile.attributes.name=='default-export')]
    String   ${route_map}..rtctrlProfile.attributes.descr   {{ context.description | default() }}
    String   ${route_map}..rtctrlProfile.attributes.type   {{ l3out.export_route_map.type | default(defaults.apic.tenants.l3outs.export_route_map.type) }}

{% for context in l3out.export_route_map.contexts | default([]) %}
{% set context_name = context.name ~ defaults.apic.tenants.l3outs.export_route_map.contexts.name_suffix %}

Verify L3out {{ l3out_name }} Export Route Map Context {{ context_name }}
    ${route_map}=   Set Variable   $..l3extOut.children[?(@.rtctrlProfile.attributes.name=='default-export')]
    ${context}=   Set Variable   ${route_map}..rtctrlProfile.children[?(@.rtctrlCtxP.attributes.name=='{{ context_name }}')]
    String   ${context}..rtctrlCtxP.attributes.name   {{ context_name }}
    String   ${context}..rtctrlCtxP.attributes.descr   {{ context.description | default() }}
    String   ${context}..rtctrlCtxP.attributes.action   {{ context.action | default(defaults.apic.tenants.l3outs.export_route_map.contexts.action) }}
    String   ${context}..rtctrlCtxP.attributes.order   {{ context.order | default(defaults.apic.tenants.l3outs.export_route_map.contexts.order) }}
{% if context.set_rule is defined %}
{% set rule_name = context.set_rule ~ defaults.apic.tenants.policies.set_rules.name_suffix %}
    String   ${context}..rtctrlRsScopeToAttrP.attributes.tnRtctrlAttrPName   {{ rule_name }}
{% endif %}
{% if context.match_rule is defined %}
{% set rule_name = context.match_rule ~ defaults.apic.tenants.policies.match_rules.name_suffix %}
    String   ${context}..rtctrlRsCtxPToSubjP.attributes.tnRtctrlSubjPName   {{ rule_name }}
{% endif %}

{% endfor %}

{% endif %}

{% if l3out.l3_multicast_ipv4 | default(defaults.apic.tenants.l3outs.l3_multicast_ipv4) | cisco.aac.aac_bool("yes") == 'yes' %}

Verify L3out {{ l3out_name }} Multicast IPv4
    String   $..pimExtP.attributes.enabledAf   ipv4-mcast
    String   $..pimExtP.attributes.name   pim
{% endif %}

{% if l3out.interleak_route_map is defined %}
{% set interleak_route_map_name = l3out.interleak_route_map ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix %}

Verify L3out {{ l3out_name }} Route Profile for Interleak
    String   $..l3extRsInterleakPol.attributes.tnRtctrlProfileName   {{ interleak_route_map_name }}

{% endif %}

{% if l3out.default_route_leak_policy is defined %}
{% set scope = [] %}
{% if l3out.default_route_leak_policy.context_scope | default(defaults.apic.tenants.l3outs.default_route_leak_policy.context_scope) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("ctx")] %}{% endif %}
{% if l3out.default_route_leak_policy.outside_scope | default(defaults.apic.tenants.l3outs.default_route_leak_policy.outside_scope) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("l3-out")] %}{% endif %}

Verify L3out {{ l3out_name }} Default Route Leak Policy
    String   $..l3extDefaultRouteLeakP.attributes.always   {{ default_route_leak_policy.always | default(defaults.apic.tenants.l3outs.default_route_leak_policy.always) | cisco.aac.aac_bool("yes") }}
    String   $..l3extDefaultRouteLeakP.attributes.criteria   {{ default_route_leak_policy.criteria | default(defaults.apic.tenants.l3outs.default_route_leak_policy.criteria) }}
    String   $..l3extDefaultRouteLeakP.attributes.scope   {{ scope | join(',') }}

{% endif %}

{% if l3out.dampening_ipv4_route_map is defined %}
{% set dampening_ipv4_route_map_name = l3out.dampening_ipv4_route_map ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix %}

Verify L3out {{ l3out_name }} Dampening Policy for IPv4
    ${dampen_pol_ipv4}=   Set Variable   $..l3extOut.children[?(@.l3extRsDampeningPol.attributes.af=='ipv4-ucast')]
    String   ${dampen_pol_ipv4}..attributes.tnRtctrlProfileName   {{ dampening_ipv4_route_map_name }}

{% endif %}

{% if l3out.dampening_ipv6_route_map is defined %}
{% set dampening_ipv6_route_map_name = l3out.dampening_ipv6_route_map ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix %}

Verify L3out {{ l3out_name }} Dampening Policy for IPv6
    ${dampen_pol_ipv6}=   Set Variable   $..l3extOut.children[?(@.l3extRsDampeningPol.attributes.af=='ipv6-ucast')]
    String   ${dampen_pol_ipv6}..attributes.tnRtctrlProfileName   {{ dampening_ipv6_route_map_name }}

{% endif %}

{% for rm in l3out.redistribution_route_maps | default([]) %}
{% set redistribution_route_map_name = rm.route_map ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix %}

Verify L3out {{ l3out_name }} Route Profile for Redistribution {{ redistribution_route_map_name }}
    ${route_map}=   Set Variable   $..l3extOut.children[?(@.l3extRsRedistributePol.attributes.tnRtctrlProfileName=='{{ redistribution_route_map_name }}')]
    String   ${route_map}..attributes.tnRtctrlProfileName   {{ redistribution_route_map_name }}
    String   ${route_map}..attributes.src   {{ rm.source | default(defaults.apic.tenants.l3outs.redistribution_route_maps.source) }}

{% endfor %}   

{% endfor %}
