locals {
  tags_list = flatten([
    for subnet in var.subnets : [
      for tag in subnet.tags : {
        ip    = subnet.ip
        key   = tag.key
        value = tag.value
      }
    ]
  ])
}

resource "aci_rest_managed" "fvBD" {
  dn         = "uni/tn-${var.tenant}/BD-${var.name}"
  class_name = "fvBD"
  annotation = var.annotation
  content = {
    name                  = var.name
    nameAlias             = var.alias
    descr                 = var.description
    arpFlood              = var.arp_flooding == true ? "yes" : "no"
    hostBasedRouting      = var.advertise_host_routes == true ? "yes" : "no"
    ipLearning            = var.ip_dataplane_learning == true ? "yes" : "no"
    limitIpLearnToSubnets = var.limit_ip_learn_to_subnets == true ? "yes" : "no"
    mac                   = var.mac
    epMoveDetectMode      = var.ep_move_detection == true ? "garp" : ""
    vmac                  = var.virtual_mac
    mcastAllow            = var.l3_multicast == true ? "yes" : "no"
    multiDstPktAct        = var.multi_destination_flooding
    type                  = "regular"
    unicastRoute          = var.unicast_routing == true ? "yes" : "no"
    unkMacUcastAct        = var.unknown_unicast
    unkMcastAct           = var.unknown_ipv4_multicast
    v6unkMcastAct         = var.unknown_ipv6_multicast
    epClear               = var.clear_remote_mac_entries == true ? "yes" : "no"
    mcastARPDrop          = var.multicast_arp_drop != null ? (var.multicast_arp_drop == true ? "yes" : "no") : null
  }
}

resource "aci_rest_managed" "fvRsCtx" {
  dn         = "${aci_rest_managed.fvBD.dn}/rsctx"
  class_name = "fvRsCtx"
  content = {
    tnFvCtxName = var.vrf
  }
}

resource "aci_rest_managed" "fvSubnet" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet }
  dn         = "${aci_rest_managed.fvBD.dn}/subnet-[${each.value.ip}]"
  class_name = "fvSubnet"
  content = {
    ip           = each.value.ip
    descr        = each.value.description
    preferred    = each.value.primary_ip == true ? "yes" : "no"
    ctrl         = join(",", concat(each.value.nd_ra_prefix == true ? ["nd"] : [], each.value.no_default_gateway == true ? ["no-default-gateway"] : [], each.value.igmp_querier == true ? ["querier"] : []))
    scope        = join(",", concat(each.value.public == true ? ["public"] : ["private"], each.value.shared == true ? ["shared"] : []))
    virtual      = each.value.virtual == true ? "yes" : "no"
    ipDPLearning = each.value.ip_dataplane_learning != null ? (each.value.ip_dataplane_learning == true ? "enabled" : "disabled") : null
  }

  depends_on = [
    aci_rest_managed.fvRsCtx,
  ]
}

resource "aci_rest_managed" "fvRsNdPfxPol" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet if subnet.nd_ra_prefix_policy != "" }
  dn         = "${aci_rest_managed.fvSubnet[each.key].dn}/rsNdPfxPol"
  class_name = "fvRsNdPfxPol"
  content = {
    tnNdPfxPolName = each.value.nd_ra_prefix_policy
  }
}

resource "aci_rest_managed" "tagTag" {
  for_each   = { for item in local.tags_list : "${item.ip}.${item.key}" => item }
  dn         = "${aci_rest_managed.fvSubnet[each.value.ip].dn}/tagKey-${each.value.key}"
  class_name = "tagTag"
  content = {
    key   = each.value.key
    value = each.value.value
  }
}

resource "aci_rest_managed" "fvRsBDToOut" {
  for_each   = toset(var.l3outs)
  dn         = "${aci_rest_managed.fvBD.dn}/rsBDToOut-${each.value}"
  class_name = "fvRsBDToOut"
  content = {
    tnL3extOutName = each.value
  }

  depends_on = [
    aci_rest_managed.fvRsCtx,
  ]
}

resource "aci_rest_managed" "dhcpLbl" {
  for_each   = { for dhcp_label in var.dhcp_labels : dhcp_label.dhcp_relay_policy => dhcp_label }
  dn         = "${aci_rest_managed.fvBD.dn}/dhcplbl-${each.value.dhcp_relay_policy}"
  class_name = "dhcpLbl"
  content = {
    owner = each.value.scope,
    name  = each.value.dhcp_relay_policy
  }

  depends_on = [
    aci_rest_managed.fvRsCtx,
  ]
}

resource "aci_rest_managed" "dhcpRsDhcpOptionPol" {
  for_each   = { for dhcp_label in var.dhcp_labels : dhcp_label.dhcp_relay_policy => dhcp_label if dhcp_label.dhcp_option_policy != null }
  dn         = "${aci_rest_managed.dhcpLbl[each.value.dhcp_relay_policy].dn}/rsdhcpOptionPol"
  class_name = "dhcpRsDhcpOptionPol"
  content = {
    tnDhcpOptionPolName = each.value.dhcp_option_policy
  }
}

resource "aci_rest_managed" "igmpIfP" {
  count      = var.igmp_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvBD.dn}/igmpIfP"
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

resource "aci_rest_managed" "fvRsIgmpsn" {
  count      = var.igmp_snooping_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvBD.dn}/rsigmpsn"
  class_name = "fvRsIgmpsn"
  content = {
    tnIgmpSnoopPolName = var.igmp_snooping_policy
  }
}

resource "aci_rest_managed" "pimBDP" {
  count      = var.pim_source_filter != "" || var.pim_destination_filter != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvBD.dn}/pimbdp"
  class_name = "pimBDP"
}

resource "aci_rest_managed" "pimBDFilterPol" {
  count      = var.pim_source_filter != "" || var.pim_destination_filter != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBDP[0].dn}/pimbdfilterp"
  class_name = "pimBDFilterPol"
}

resource "aci_rest_managed" "pimBDSrcFilterPol" {
  count      = var.pim_source_filter != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBDFilterPol[0].dn}/pimbdsrcfilterp"
  class_name = "pimBDSrcFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_source" {
  count      = var.pim_source_filter != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBDSrcFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_source_filter}"
  }
}

resource "aci_rest_managed" "pimBDDestFilterPol" {
  count      = var.pim_destination_filter != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBDFilterPol[0].dn}/pimbddestfilterp"
  class_name = "pimBDDestFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_destination" {
  count      = var.pim_destination_filter != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBDDestFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_destination_filter}"
  }
}

resource "aci_rest_managed" "fvRsBDToNdP" {
  count      = var.nd_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvBD.dn}/rsBDToNdP"
  class_name = "fvRsBDToNdP"
  content = {
    tnNdIfPolName = var.nd_interface_policy
  }
}

resource "aci_rest_managed" "fvRsBdToEpRet" {
  count      = var.endpoint_retention_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvBD.dn}/rsbdToEpRet"
  class_name = "fvRsBdToEpRet"
  content = {
    tnFvEpRetPolName = var.endpoint_retention_policy
  }
}

resource "aci_rest_managed" "fvAccP" {
  count      = var.legacy_mode_vlan != null ? 1 : 0
  dn         = "${aci_rest_managed.fvBD.dn}/accp"
  class_name = "fvAccP"
  content = {
    encap = "vlan-${var.legacy_mode_vlan}"
  }
}

resource "aci_rest_managed" "fvRsBDToNetflowMonitorPol" {
  for_each   = { for policy in var.netflow_monitor_policies : "${policy.name}-${policy.ip_filter_type}" => policy }
  dn         = "${aci_rest_managed.fvBD.dn}/rsBDToNetflowMonitorPol-[${each.value.name}]-${each.value.ip_filter_type}"
  class_name = "fvRsBDToNetflowMonitorPol"
  content = {
    tnNetflowMonitorPolName = each.value.name
    fltType                 = each.value.ip_filter_type
  }
}
