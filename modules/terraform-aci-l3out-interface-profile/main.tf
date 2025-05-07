locals {
  interfaces = flatten([
    for int in var.interfaces : {
      key = int.type == "vpc" ? "topology/pod-${int.pod_id}/protpaths-${int.node_id}-${int.node2_id}/pathep-[${int.channel}]" : (int.type == "pc" ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[${int.channel}]" : (int.sub_port != null ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}/${int.sub_port}]" : "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}]"))
      value = {
        ip                       = int.type != "vpc" ? int.ip : "0.0.0.0"
        svi                      = int.svi == true ? "yes" : "no"
        description              = int.description
        type                     = int.type
        vlan                     = int.vlan
        autostate                = int.autostate ? "enabled" : "disabled"
        mac                      = int.mac
        mode                     = int.mode
        mtu                      = int.mtu
        node_id                  = int.node_id
        node2_id                 = int.node2_id
        module                   = int.module
        pod_id                   = int.pod_id
        port                     = int.port
        channel                  = int.channel
        ip_a                     = int.ip_a
        ip_b                     = int.ip_b
        ip_shared                = int.ip_shared
        ip_shared_dhcp_relay     = int.ip_shared_dhcp_relay
        lladdr                   = int.lladdr
        tDn                      = int.type == "vpc" ? "topology/pod-${int.pod_id}/protpaths-${int.node_id}-${int.node2_id}/pathep-[${int.channel}]" : (int.type == "pc" ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[${int.channel}]" : (int.sub_port != null ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}/${int.sub_port}]" : "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}]"))
        multipod_direct          = int.multipod_direct
        scope                    = int.scope
        micro_bfd_destination_ip = int.micro_bfd_destination_ip
        micro_bfd_start_timer    = int.micro_bfd_start_timer
      }
    } if int.floating_svi == false
  ])
  bgp_peers = flatten([
    for int in var.interfaces : [
      for peer in coalesce(int.bgp_peers, []) : {
        key = "${int.type == "vpc" ? "topology/pod-${int.pod_id}/protpaths-${int.node_id}-${int.node2_id}/pathep-[${int.channel}]" : (int.type == "pc" ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[${int.channel}]" : (int.sub_port != null ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}/${int.sub_port}]" : "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}]"))}/${peer.ip}"
        value = {
          interface                        = int.type == "vpc" ? "topology/pod-${int.pod_id}/protpaths-${int.node_id}-${int.node2_id}/pathep-[${int.channel}]" : (int.type == "pc" ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[${int.channel}]" : (int.sub_port != null ? "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}/${int.sub_port}]" : "topology/pod-${int.pod_id}/paths-${int.node_id}/pathep-[eth${int.module}/${int.port}]"))
          ip                               = peer.ip
          remote_as                        = peer.remote_as
          description                      = peer.description
          allow_self_as                    = peer.allow_self_as
          as_override                      = peer.as_override
          disable_peer_as_check            = peer.disable_peer_as_check
          next_hop_self                    = peer.next_hop_self
          send_community                   = peer.send_community
          send_ext_community               = peer.send_ext_community
          password                         = sensitive(peer.password)
          allowed_self_as_count            = peer.allowed_self_as_count
          bfd                              = peer.bfd
          disable_connected_check          = peer.disable_connected_check
          ttl                              = peer.ttl
          weight                           = peer.weight
          remove_all_private_as            = peer.remove_all_private_as
          remove_private_as                = peer.remove_private_as
          replace_private_as_with_local_as = peer.replace_private_as_with_local_as
          unicast_address_family           = peer.unicast_address_family
          multicast_address_family         = peer.multicast_address_family
          admin_state                      = peer.admin_state
          local_as                         = peer.local_as
          as_propagate                     = peer.as_propagate
          peer_prefix_policy               = peer.peer_prefix_policy
          export_route_control             = peer.export_route_control
          import_route_control             = peer.import_route_control
        }
      }
    ] if int.floating_svi == false
  ])
  floating_interfaces = flatten([
    for int in var.interfaces : {
      key = "${int.node_id}/${int.vlan}"
      value = {
        floating_key = "${int.node_id}/${int.vlan}"
        ip           = int.ip
        autostate    = int.autostate ? "enabled" : "disabled"
        description  = int.description
        vlan         = int.vlan
        mac          = int.mac
        mode         = int.mode
        mtu          = int.mtu
        node_id      = int.node_id
        pod_id       = int.pod_id
        scope        = int.scope
        ip_shared    = int.ip_shared
        lladdr       = int.lladdr
      }
    } if int.floating_svi == true
  ])
  floating_bgp_peers = flatten([
    for int in var.interfaces : [
      for peer in coalesce(int.bgp_peers, []) : {
        key = "${int.node_id}/${int.vlan}/${peer.ip}"
        value = {
          node                             = "${int.node_id}/${int.vlan}"
          ip                               = peer.ip
          remote_as                        = peer.remote_as
          description                      = peer.description
          allow_self_as                    = peer.allow_self_as
          as_override                      = peer.as_override
          disable_peer_as_check            = peer.disable_peer_as_check
          next_hop_self                    = peer.next_hop_self
          send_community                   = peer.send_community
          send_ext_community               = peer.send_ext_community
          password                         = sensitive(peer.password)
          allowed_self_as_count            = peer.allowed_self_as_count
          bfd                              = peer.bfd
          disable_connected_check          = peer.disable_connected_check
          ttl                              = peer.ttl
          weight                           = peer.weight
          remove_all_private_as            = peer.remove_all_private_as
          remove_private_as                = peer.remove_private_as
          replace_private_as_with_local_as = peer.replace_private_as_with_local_as
          unicast_address_family           = peer.unicast_address_family
          multicast_address_family         = peer.multicast_address_family
          admin_state                      = peer.admin_state
          local_as                         = peer.local_as
          as_propagate                     = peer.as_propagate
          peer_prefix_policy               = peer.peer_prefix_policy
          export_route_control             = peer.export_route_control
          import_route_control             = peer.import_route_control
        }
      }
    ] if int.floating_svi == true
  ])
  floating_paths = flatten([
    for int in var.interfaces : [
      for path in coalesce(int.paths, []) : {
        key = "${int.node_id}/${int.vlan}/${coalesce(path.physical_domain, path.vmware_vmm_domain)}/${path.floating_ip}"
        value = {
          node        = "${int.node_id}/${int.vlan}"
          floating_ip = path.floating_ip
          domain      = path.physical_domain != null ? "phys-${path.physical_domain}" : (path.vmware_vmm_domain != null ? "vmmp-VMware/dom-${path.vmware_vmm_domain}" : "")
          elag        = path.elag
          vlan        = path.vlan
        }
      }
    ] if int.floating_svi == true
  ])
}

resource "aci_rest_managed" "l3extLIfP" {
  dn         = "uni/tn-${var.tenant}/out-${var.l3out}/lnodep-${var.node_profile}/lifp-${var.name}"
  class_name = "l3extLIfP"
  content = {
    name  = var.name
    descr = var.description
    prio  = var.qos_class
  }
}

resource "aci_rest_managed" "ospfIfP" {
  count       = var.ospf_authentication_key != "" || var.ospf_interface_policy != "" ? 1 : 0
  dn          = "${aci_rest_managed.l3extLIfP.dn}/ospfIfP"
  class_name  = "ospfIfP"
  escape_html = false
  content = {
    name      = var.ospf_interface_profile_name
    authKeyId = var.ospf_authentication_key_id
    authKey   = var.ospf_authentication_key
    authType  = var.ospf_authentication_type
  }

  lifecycle {
    ignore_changes = [content["authKey"]]
  }
}

resource "aci_rest_managed" "ospfRsIfPol" {
  count      = var.ospf_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.ospfIfP[0].dn}/rsIfPol"
  class_name = "ospfRsIfPol"
  content = {
    tnOspfIfPolName = var.ospf_interface_policy
  }
  depends_on = [
    aci_rest_managed.l3extMember_A, aci_rest_managed.l3extMember_B
  ]
}

resource "aci_rest_managed" "eigrpIfP" {
  count      = var.eigrp_interface_profile_name != "" && (var.eigrp_interface_policy != "" || var.eigrp_keychain_policy != "") ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/eigrpIfP"
  class_name = "eigrpIfP"
  content = {
    name = var.eigrp_interface_profile_name
  }

}

resource "aci_rest_managed" "eigrpRsIfPol" {
  count      = var.eigrp_interface_profile_name != "" && var.eigrp_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.eigrpIfP[0].dn}/rsIfPol"
  class_name = "eigrpRsIfPol"
  content = {
    tnEigrpIfPolName = var.eigrp_interface_policy
  }
}

resource "aci_rest_managed" "eigrpAuthIfP" {
  count      = var.eigrp_interface_profile_name != "" && var.eigrp_keychain_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.eigrpIfP[0].dn}/eigrpAuthIfP"
  class_name = "eigrpAuthIfP"
  content    = {}
}

resource "aci_rest_managed" "eigrpRsKeyChainPol" {
  count      = var.eigrp_interface_profile_name != "" && var.eigrp_keychain_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.eigrpAuthIfP[0].dn}/keychainp-${var.eigrp_keychain_policy}"
  class_name = "eigrpRsKeyChainPol"
  content = {
    tnFvKeyChainPolName = var.eigrp_keychain_policy
  }
}

resource "aci_rest_managed" "bfdIfP" {
  count      = var.bfd_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/bfdIfP"
  class_name = "bfdIfP"
  content = {
    "type" = "none"
  }
}

resource "aci_rest_managed" "bfdRsIfPol" {
  count      = var.bfd_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.bfdIfP[0].dn}/rsIfPol"
  class_name = "bfdRsIfPol"
  content = {
    tnBfdIfPolName = var.bfd_policy
  }
}

resource "aci_rest_managed" "pimIfP" {
  count      = var.pim_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/pimifp"
  class_name = "pimIfP"
}

resource "aci_rest_managed" "pimRsIfPol" {
  count      = var.pim_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimIfP[0].dn}/rsIfPol"
  class_name = "pimRsIfPol"
  content = {
    tDn = "uni/tn-${var.tenant}/pimifpol-${var.pim_policy}"
  }
}

resource "aci_rest_managed" "igmpIfP" {
  count      = var.igmp_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/igmpIfP"
  class_name = "igmpIfP"
}

resource "aci_rest_managed" "igmpRsIfPol" {
  count      = var.igmp_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.igmpIfP[0].dn}/rsIfPol"
  class_name = "igmpRsIfPol"
  content = {
    tDn = "uni/tn-${var.tenant}/igmpIfPol-${var.igmp_interface_policy}"
  }
}

resource "aci_rest_managed" "l3extRsNdIfPol" {
  count      = var.nd_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/rsNdIfPol"
  class_name = "l3extRsNdIfPol"
  content = {
    tnNdIfPolName = var.nd_interface_policy
  }
}

resource "aci_rest_managed" "l3extRsLIfPCustQosPol" {
  count      = var.custom_qos_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/rslIfPCustQosPol"
  class_name = "l3extRsLIfPCustQosPol"
  content = {
    tnQosCustomPolName = var.custom_qos_policy
  }
}

resource "aci_rest_managed" "l3extRsPathL3OutAtt" {
  for_each   = { for item in local.interfaces : item.key => item.value }
  dn         = "${aci_rest_managed.l3extLIfP.dn}/rspathL3OutAtt-[${each.value.tDn}]"
  class_name = "l3extRsPathL3OutAtt"
  content = {
    addr             = each.value.ip
    descr            = each.value.description
    ifInstT          = each.value.vlan != null ? (each.value.svi == "yes" ? "ext-svi" : "sub-interface") : "l3-port"
    autostate        = each.value.autostate
    encap            = each.value.vlan != null ? "vlan-${each.value.vlan}" : null
    ipv6Dad          = "enabled"
    llAddr           = each.value.lladdr
    mac              = each.value.mac
    mode             = each.value.mode
    mtu              = each.value.mtu
    tDn              = each.value.tDn
    isMultiPodDirect = each.value.multipod_direct ? "yes" : null
    encapScope       = each.value.svi == "yes" ? each.value.scope == "vrf" ? "ctx" : "local" : null
  }
}

resource "aci_rest_managed" "l3extIp" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type != "vpc" && item.value.ip_shared != null }
  dn         = "${aci_rest_managed.l3extRsPathL3OutAtt[each.key].dn}/addr-[${each.value.ip_shared}]"
  class_name = "l3extIp"
  content = {
    addr = each.value.ip_shared
  }
}

resource "aci_rest_managed" "dhcpRelayGwExtIp" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type != "vpc" && item.value.ip_shared != null && item.value.ip_shared_dhcp_relay == true }
  dn         = "${aci_rest_managed.l3extIp[each.key].dn}/relayGwExtIp"
  class_name = "dhcpRelayGwExtIp"
  content = {
  }
}

resource "aci_rest_managed" "l3extMember_A" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type == "vpc" }
  dn         = "${aci_rest_managed.l3extRsPathL3OutAtt[each.key].dn}/mem-A"
  class_name = "l3extMember"
  content = {
    addr = each.value.ip_a
    side = "A"
  }
}

resource "aci_rest_managed" "l3extIp_A" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type == "vpc" && item.value.ip_shared != null }
  dn         = "${aci_rest_managed.l3extMember_A[each.key].dn}/addr-[${each.value.ip_shared}]"
  class_name = "l3extIp"
  content = {
    addr = each.value.ip_shared
  }
}

resource "aci_rest_managed" "dhcpRelayGwExtIp_A" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type == "vpc" && item.value.ip_shared != null && item.value.ip_shared_dhcp_relay == true }
  dn         = "${aci_rest_managed.l3extIp_A[each.key].dn}/relayGwExtIp"
  class_name = "dhcpRelayGwExtIp"
  content = {
  }
}

resource "aci_rest_managed" "l3extMember_B" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type == "vpc" }
  dn         = "${aci_rest_managed.l3extRsPathL3OutAtt[each.key].dn}/mem-B"
  class_name = "l3extMember"
  content = {
    addr = each.value.ip_b
    side = "B"
  }
}

resource "aci_rest_managed" "l3extIp_B" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type == "vpc" && item.value.ip_shared != null }
  dn         = "${aci_rest_managed.l3extMember_B[each.key].dn}/addr-[${each.value.ip_shared}]"
  class_name = "l3extIp"
  content = {
    addr = each.value.ip_shared
  }
}

resource "aci_rest_managed" "dhcpRelayGwExtIp_B" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.type == "vpc" && item.value.ip_shared != null && item.value.ip_shared_dhcp_relay == true }
  dn         = "${aci_rest_managed.l3extIp_B[each.key].dn}/relayGwExtIp"
  class_name = "dhcpRelayGwExtIp"
  content = {
  }
}

resource "aci_rest_managed" "bfdMicroBfdP" {
  for_each   = { for item in local.interfaces : item.key => item.value if item.value.micro_bfd_destination_ip != "" && item.value.micro_bfd_destination_ip != null }
  dn         = "${aci_rest_managed.l3extRsPathL3OutAtt[each.key].dn}/microBfdP"
  class_name = "bfdMicroBfdP"
  content = {
    adminState = "yes"
    dst        = each.value.micro_bfd_destination_ip
    stTm       = each.value.micro_bfd_start_timer
  }
}

resource "aci_rest_managed" "l3extVirtualLIfP" {
  for_each   = { for item in local.floating_interfaces : item.key => item.value }
  dn         = "${aci_rest_managed.l3extLIfP.dn}/vlifp-[topology/pod-${each.value.pod_id}/node-${each.value.node_id}]-[vlan-${each.value.vlan}]"
  class_name = "l3extVirtualLIfP"
  content = {
    addr       = each.value.ip
    autostate  = each.value.autostate
    descr      = each.value.description
    ifInstT    = "ext-svi"
    encap      = "vlan-${each.value.vlan}"
    ipv6Dad    = "enabled"
    llAddr     = each.value.lladdr
    mac        = each.value.mac
    mode       = each.value.mode
    mtu        = each.value.mtu
    nodeDn     = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
    encapScope = each.value.scope == "vrf" ? "ctx" : "local"
  }
}

resource "aci_rest_managed" "l3extRsDynPathAtt" {
  for_each   = { for item in local.floating_paths : item.key => item.value }
  dn         = "${aci_rest_managed.l3extVirtualLIfP[each.value.node].dn}/rsdynPathAtt-[uni/${each.value.domain}]"
  class_name = "l3extRsDynPathAtt"
  content = {
    floatingAddr = each.value.floating_ip
    tDn          = "uni/${each.value.domain}"
    encap        = each.value.vlan != null && each.value.vlan != "" ? "vlan-${each.value.vlan}" : null
  }
}

resource "aci_rest_managed" "l3extIp_float" {
  for_each   = { for item in local.floating_interfaces : item.key => item.value if item.value.ip_shared != null }
  dn         = "${aci_rest_managed.l3extVirtualLIfP[each.value.floating_key].dn}/addr-[${each.value.ip_shared}]"
  class_name = "l3extIp"
  content = {
    addr = each.value.ip_shared
  }
}

resource "aci_rest_managed" "l3extVirtualLIfPLagPolAtt" {
  for_each   = { for item in local.floating_paths : item.key => item.value if item.value.elag != null }
  dn         = "${aci_rest_managed.l3extRsDynPathAtt[each.key].dn}/vlifplagpolatt"
  class_name = "l3extVirtualLIfPLagPolAtt"
}

resource "aci_rest_managed" "l3extRsVSwitchEnhancedLagPol" {
  for_each   = { for item in local.floating_paths : item.key => item.value if item.value.elag != null }
  dn         = "${aci_rest_managed.l3extVirtualLIfPLagPolAtt[each.key].dn}/rsvSwitchEnhancedLagPol-[uni/${each.value.domain}/vswitchpolcont/enlacplagp-${each.value.elag}]"
  class_name = "l3extRsVSwitchEnhancedLagPol"
  content = {
    tDn = "uni/${each.value.domain}/vswitchpolcont/enlacplagp-${each.value.elag}"

  }
}

resource "aci_rest_managed" "bgpPeerP" {
  for_each    = { for item in local.bgp_peers : item.key => item.value }
  dn          = "${aci_rest_managed.l3extRsPathL3OutAtt[each.value.interface].dn}/peerP-[${each.value.ip}]"
  class_name  = "bgpPeerP"
  escape_html = false
  content = {
    addr             = each.value.ip
    descr            = each.value.description
    ctrl             = (var.remote_leaf || var.multipod) && var.tenant == "infra" ? "allow-self-as" : (join(",", concat(each.value.allow_self_as == true ? ["allow-self-as"] : [], each.value.as_override == true ? ["as-override"] : [], each.value.disable_peer_as_check == true ? ["dis-peer-as-check"] : [], each.value.next_hop_self == true ? ["nh-self"] : [], each.value.send_community == true ? ["send-com"] : [], each.value.send_ext_community == true ? ["send-ext-com"] : [], var.transport_data_plane == "mpls" ? ["segment-routing-disable"] : [])))
    password         = sensitive(each.value.password)
    allowedSelfAsCnt = each.value.allowed_self_as_count
    peerCtrl         = join(",", concat(each.value.bfd == true ? ["bfd"] : [], each.value.disable_connected_check == true ? ["dis-conn-check"] : []))
    ttl              = each.value.ttl
    weight           = each.value.weight
    privateASctrl    = join(",", concat(each.value.remove_all_private_as == true ? ["remove-all"] : [], each.value.remove_private_as == true ? ["remove-exclusive"] : [], each.value.replace_private_as_with_local_as == true ? ["replace-as"] : []))
    addrTCtrl        = (var.remote_leaf || var.multipod) && var.tenant == "infra" ? "af-ucast" : (join(",", concat(each.value.multicast_address_family == true && var.sr_mpls == false ? ["af-mcast"] : [], var.sr_mpls == true ? ["af-label-ucast"] : [], each.value.unicast_address_family == true ? ["af-ucast"] : [])))
    adminSt          = each.value.admin_state == true ? "enabled" : "disabled"
    connectivityType = (var.remote_leaf || var.multipod) && var.tenant == "infra" ? "multipod,multisite" : null
  }

  lifecycle {
    ignore_changes = [content["password"]]
  }
}

resource "aci_rest_managed" "bgpAsP" {
  for_each   = { for item in local.bgp_peers : item.key => item.value }
  dn         = "${aci_rest_managed.bgpPeerP[each.key].dn}/as"
  class_name = "bgpAsP"
  content = {
    asn = each.value.remote_as
  }
}

resource "aci_rest_managed" "bgpLocalAsnP" {
  for_each   = { for item in local.bgp_peers : item.key => item.value if item.value.local_as != null }
  dn         = "${aci_rest_managed.bgpPeerP[each.key].dn}/localasn"
  class_name = "bgpLocalAsnP"
  content = {
    localAsn     = each.value.local_as
    asnPropagate = each.value.as_propagate
  }
}

resource "aci_rest_managed" "bgpRsPeerPfxPol" {
  for_each   = { for item in local.bgp_peers : item.key => item.value if item.value.peer_prefix_policy != null }
  dn         = "${aci_rest_managed.bgpPeerP[each.key].dn}/rspeerPfxPol"
  class_name = "bgpRsPeerPfxPol"
  content = {
    tnBgpPeerPfxPolName = each.value.peer_prefix_policy
  }
}

resource "aci_rest_managed" "bgpRsPeerToProfile_export" {
  for_each   = { for item in local.bgp_peers : item.key => item.value if item.value.export_route_control != null }
  dn         = "${aci_rest_managed.bgpPeerP[each.key].dn}/rspeerToProfile-[uni/tn-${var.tenant}/prof-${each.value.export_route_control}]-export"
  class_name = "bgpRsPeerToProfile"
  content = {
    tDn       = "uni/tn-${var.tenant}/prof-${each.value.export_route_control}"
    direction = "export"
  }
}

resource "aci_rest_managed" "bgpRsPeerToProfile_import" {
  for_each   = { for item in local.bgp_peers : item.key => item.value if item.value.import_route_control != null }
  dn         = "${aci_rest_managed.bgpPeerP[each.key].dn}/rspeerToProfile-[uni/tn-${var.tenant}/prof-${each.value.import_route_control}]-import"
  class_name = "bgpRsPeerToProfile"
  content = {
    tDn       = "uni/tn-${var.tenant}/prof-${each.value.import_route_control}"
    direction = "import"
  }
}

resource "aci_rest_managed" "bgpPeerP_floating" {
  for_each    = { for item in local.floating_bgp_peers : item.key => item.value }
  dn          = "${aci_rest_managed.l3extVirtualLIfP[each.value.node].dn}/peerP-[${each.value.ip}]"
  class_name  = "bgpPeerP"
  escape_html = false
  content = {
    addr             = each.value.ip
    descr            = each.value.description
    ctrl             = join(",", concat(each.value.allow_self_as == true ? ["allow-self-as"] : [], each.value.as_override == true ? ["as-override"] : [], each.value.disable_peer_as_check == true ? ["dis-peer-as-check"] : [], each.value.next_hop_self == true ? ["nh-self"] : [], each.value.send_community == true ? ["send-com"] : [], each.value.send_ext_community == true ? ["send-ext-com"] : []))
    password         = sensitive(each.value.password)
    allowedSelfAsCnt = each.value.allowed_self_as_count
    peerCtrl         = join(",", concat(each.value.bfd == true ? ["bfd"] : [], each.value.disable_connected_check == true ? ["dis-conn-check"] : []))
    ttl              = each.value.ttl
    weight           = each.value.weight
    privateASctrl    = join(",", concat(each.value.remove_all_private_as == true ? ["remove-all"] : [], each.value.remove_private_as == true ? ["remove-exclusive"] : [], each.value.replace_private_as_with_local_as == true ? ["replace-as"] : []))
    addrTCtrl        = join(",", concat(each.value.multicast_address_family == true ? ["af-mcast"] : [], each.value.unicast_address_family == true ? ["af-ucast"] : []))
    adminSt          = each.value.admin_state == true ? "enabled" : "disabled"
  }

  lifecycle {
    ignore_changes = [content["password"]]
  }
}

resource "aci_rest_managed" "bgpAsP_floating" {
  for_each   = { for item in local.floating_bgp_peers : item.key => item.value }
  dn         = "${aci_rest_managed.bgpPeerP_floating[each.key].dn}/as"
  class_name = "bgpAsP"
  content = {
    asn = each.value.remote_as
  }
}

resource "aci_rest_managed" "bgpLocalAsnP_floating" {
  for_each   = { for item in local.floating_bgp_peers : item.key => item.value if item.value.local_as != null }
  dn         = "${aci_rest_managed.bgpPeerP_floating[each.key].dn}/localasn"
  class_name = "bgpLocalAsnP"
  content = {
    localAsn     = each.value.local_as
    asnPropagate = each.value.as_propagate
  }
}

resource "aci_rest_managed" "bgpRsPeerPfxPol_floating" {
  for_each   = { for item in local.floating_bgp_peers : item.key => item.value if item.value.peer_prefix_policy != null }
  dn         = "${aci_rest_managed.bgpPeerP_floating[each.key].dn}/rspeerPfxPol"
  class_name = "bgpRsPeerPfxPol"
  content = {
    tnBgpPeerPfxPolName = each.value.peer_prefix_policy
  }
}

resource "aci_rest_managed" "bgpRsPeerToProfile_export_floating" {
  for_each   = { for item in local.floating_bgp_peers : item.key => item.value if item.value.export_route_control != null }
  dn         = "${aci_rest_managed.bgpPeerP_floating[each.key].dn}/rspeerToProfile-[uni/tn-${var.tenant}/prof-${each.value.export_route_control}]-export"
  class_name = "bgpRsPeerToProfile"
  content = {
    tDn       = "uni/tn-${var.tenant}/prof-${each.value.export_route_control}"
    direction = "export"
  }
}

resource "aci_rest_managed" "bgpRsPeerToProfile_import_floating" {
  for_each   = { for item in local.floating_bgp_peers : item.key => item.value if item.value.import_route_control != null }
  dn         = "${aci_rest_managed.bgpPeerP_floating[each.key].dn}/rspeerToProfile-[uni/tn-${var.tenant}/prof-${each.value.import_route_control}]-import"
  class_name = "bgpRsPeerToProfile"
  content = {
    tDn       = "uni/tn-${var.tenant}/prof-${each.value.import_route_control}"
    direction = "import"
  }
}

resource "aci_rest_managed" "mplsIfP" {
  count      = var.tenant == "infra" && var.sr_mpls == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extLIfP.dn}/mplsIfP"
  class_name = "mplsIfP"
}

resource "aci_rest_managed" "mplsRsIfPol" {
  count      = var.tenant == "infra" && var.sr_mpls == true ? 1 : 0
  dn         = "${aci_rest_managed.mplsIfP[0].dn}/rsIfPol"
  class_name = "mplsRsIfPol"
  content = {
    tnMplsIfPolName = "default"
  }
}

resource "aci_rest_managed" "dhcpLbl" {
  for_each   = { for dhcp_label in var.dhcp_labels : dhcp_label.dhcp_relay_policy => dhcp_label }
  dn         = "${aci_rest_managed.l3extLIfP.dn}/dhcplbl-${each.value.dhcp_relay_policy}"
  class_name = "dhcpLbl"
  content = {
    name  = each.value.dhcp_relay_policy
    owner = each.value.scope
  }
}

resource "aci_rest_managed" "dhcpRsDhcpOptionPol" {
  for_each   = { for dhcp_label in var.dhcp_labels : dhcp_label.dhcp_relay_policy => dhcp_label if dhcp_label.dhcp_option_policy != null }
  dn         = "${aci_rest_managed.dhcpLbl[each.value.dhcp_relay_policy].dn}/rsdhcpOptionPol"
  class_name = "dhcpRsDhcpOptionPol"
  content = {
    tnDhcpOptionPolName = each.value.dhcp_option_policy
  }
}
