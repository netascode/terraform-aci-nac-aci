locals {
  ip_pools_list = flatten([
    for subnet in var.subnets : [
      for pool in lookup(subnet, "ip_pools", []) : {
        id                = "${subnet.ip}-${pool.name}"
        subnet_ip         = subnet.ip
        name              = pool.name
        start_ip          = pool.start_ip
        end_ip            = pool.end_ip
        dns_search_suffix = pool.dns_search_suffix
        dns_server        = pool.dns_server
        dns_suffix        = pool.dns_suffix
        wins_server       = pool.wins_server
      }
    ]
  ])
}

resource "aci_rest_managed" "fvAEPg" {
  dn         = "uni/tn-${var.tenant}/ap-${var.application_profile}/epg-${var.name}"
  class_name = "fvAEPg"
  content = {
    name           = var.name
    nameAlias      = var.alias
    descr          = var.description
    isAttrBasedEPg = "yes"
    floodOnEncap   = var.flood_in_encap == true ? "enabled" : "disabled"
    pcEnfPref      = var.intra_epg_isolation == true ? "enforced" : "unenforced"
    prefGrMemb     = var.preferred_group == true ? "include" : "exclude"
    prio           = var.qos_class
  }
}

resource "aci_rest_managed" "fvRsBd" {
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsbd"
  class_name = "fvRsBd"
  content = {
    tnFvBDName = var.bridge_domain
  }
}

resource "aci_rest_managed" "fvRsCustQosPol" {
  count      = var.custom_qos_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvAEPg.dn}/rscustQosPol"
  class_name = "fvRsCustQosPol"
  content = {
    tnQosCustomPolName = var.custom_qos_policy
  }
}

resource "aci_rest_managed" "fvCrtrn" {
  dn         = "${aci_rest_managed.fvAEPg.dn}/crtrn"
  class_name = "fvCrtrn"
  content = {
    match = var.match_type
  }
}

resource "aci_rest_managed" "fvIpAttr" {
  for_each = { for ip_statement in var.ip_statements : ip_statement.name => ip_statement }

  dn         = "${aci_rest_managed.fvAEPg.dn}/crtrn/ipattr-${each.value.name}"
  class_name = "fvIpAttr"
  content = {
    name        = each.value.name
    usefvSubnet = each.value.use_epg_subnet ? "yes" : "no"
    ip          = each.value.use_epg_subnet ? "0.0.0.0" : each.value.ip
  }

  depends_on = [
    aci_rest_managed.fvCrtrn
  ]
}

resource "aci_rest_managed" "fvMacAttr" {
  for_each = { for mac_statement in var.mac_statements : mac_statement.name => mac_statement }

  dn         = "${aci_rest_managed.fvAEPg.dn}/crtrn/macattr-${each.value.name}"
  class_name = "fvMacAttr"
  content = {
    name = each.value.name
    mac  = each.value.mac
  }

  depends_on = [
    aci_rest_managed.fvCrtrn
  ]
}

resource "aci_rest_managed" "fvSubnet" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet }
  dn         = "${aci_rest_managed.fvAEPg.dn}/subnet-[${each.value.ip}]"
  class_name = "fvSubnet"
  content = {
    ip    = each.value.ip
    descr = each.value.description != null ? each.value.description : ""
    ctrl  = join(",", concat(each.value.nd_ra_prefix == true ? ["nd"] : [], each.value.no_default_gateway == true ? ["no-default-gateway"] : [], each.value.igmp_querier == true ? ["querier"] : []))
    scope = join(",", concat(each.value.public == true ? ["public"] : ["private"], each.value.shared == true ? ["shared"] : []))
  }
}

resource "aci_rest_managed" "fvRsNdPfxPol" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet if subnet.nd_ra_prefix_policy != "" }
  dn         = "${aci_rest_managed.fvSubnet[each.key].dn}/rsNdPfxPol"
  class_name = "fvRsNdPfxPol"
  content = {
    tnNdPfxPolName = each.value.nd_ra_prefix_policy
  }
}

resource "aci_rest_managed" "fvCepNetCfgPol" {
  for_each   = { for pool in local.ip_pools_list : pool.id => pool }
  dn         = "${aci_rest_managed.fvSubnet[each.value.subnet_ip].dn}/cepNetCfgPol-${each.value.name}"
  class_name = "fvCepNetCfgPol"
  content = {
    name            = each.value.name
    startIp         = each.value.start_ip
    endIp           = each.value.end_ip
    dnsSearchSuffix = each.value.dns_search_suffix
    dnsServers      = each.value.dns_server
    dnsSuffix       = each.value.dns_suffix
    winsServers     = each.value.wins_server
  }
}

resource "aci_rest_managed" "fvEpReachability" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet if subnet.next_hop_ip != "" }
  dn         = "${aci_rest_managed.fvSubnet[each.value.ip].dn}/epReach"
  class_name = "fvEpReachability"
}

resource "aci_rest_managed" "ipNexthopEpP" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet if subnet.next_hop_ip != "" }
  dn         = "${aci_rest_managed.fvEpReachability[each.value.ip].dn}/nh-[${each.value.next_hop_ip}]"
  class_name = "ipNexthopEpP"
  content = {
    nhAddr = each.value.next_hop_ip
  }
}

resource "aci_rest_managed" "fvEpAnycast" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet if subnet.anycast_mac != "" }
  dn         = "${aci_rest_managed.fvSubnet[each.value.ip].dn}/epAnycast-${each.value.anycast_mac}"
  class_name = "fvEpAnycast"
  content = {
    mac = each.value.anycast_mac
  }
}

resource "aci_rest_managed" "fvEpNlb" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet if subnet.nlb_mode != "" }
  dn         = "${aci_rest_managed.fvSubnet[each.value.ip].dn}/epnlb"
  class_name = "fvEpNlb"
  content = {
    group = each.value.nlb_group
    mac   = each.value.nlb_mac
    mode  = each.value.nlb_mode == "mode-mcast-static" ? "mode-mcast--static" : each.value.nlb_mode
  }
}

resource "aci_rest_managed" "tagInst" {
  for_each   = toset(var.tags)
  dn         = "${aci_rest_managed.fvAEPg.dn}/tag-${each.value}"
  class_name = "tagInst"
  content = {
    name = each.value
  }
}

resource "aci_rest_managed" "fvRsTrustCtrl" {
  count      = var.trust_control_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvAEPg.dn}/rstrustCtrl"
  class_name = "fvRsTrustCtrl"
  content = {
    tnFhsTrustCtrlPolName = var.trust_control_policy
  }
}

resource "aci_rest_managed" "fvRsCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest_managed.fvAEPg.dn}/rscons-${each.value}"
  class_name = "fvRsCons"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsprov-${each.value}"
  class_name = "fvRsProv"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsConsIf" {
  for_each   = toset(var.contract_imported_consumers)
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsconsIf-${each.value}"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName = each.value
  }
}

resource "aci_rest_managed" "fvRsIntraEpg" {
  for_each   = toset(var.contract_intra_epgs)
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsintraEpg-${each.value}"
  class_name = "fvRsIntraEpg"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsSecInherited" {
  for_each   = { for master in var.contract_masters : master.endpoint_group => master }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rssecInherited-[uni/tn-${var.tenant}/ap-${try(each.value.application_profile, var.application_profile)}/epg-${each.value.endpoint_group}]"
  class_name = "fvRsSecInherited"
  content = {
    tDn = "uni/tn-${var.tenant}/ap-${try(each.value.application_profile, var.application_profile)}/epg-${each.value.endpoint_group}"
  }
}

resource "aci_rest_managed" "fvRsDomAtt" {
  for_each   = toset(var.physical_domains)
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsdomAtt-[uni/phys-${each.value}]"
  class_name = "fvRsDomAtt"
  content = {
    tDn = "uni/phys-${each.value}"
  }
}

resource "aci_rest_managed" "fvRsNodeAtt" {
  for_each   = { for sp in var.static_leafs : sp.node_id => sp }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsnodeAtt-[${format("topology/pod-%s/node-%s", each.value.pod_id, each.value.node_id)}]"
  class_name = "fvRsNodeAtt"
  content = {
    tDn         = format("topology/pod-%s/node-%s", each.value.pod_id, each.value.node_id)
    instrImedcy = "immediate"
  }
}

resource "aci_rest_managed" "fvRsDomAtt_vmm" {
  for_each   = { for vmm_vwm in var.vmware_vmm_domains : vmm_vwm.name => vmm_vwm }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsdomAtt-[uni/vmmp-VMware/dom-${each.value.name}]"
  class_name = "fvRsDomAtt"
  content = {
    tDn           = "uni/vmmp-VMware/dom-${each.value.name}"
    instrImedcy   = each.value.deployment_immediacy
    netflowPref   = each.value.netflow == true ? "enabled" : "disabled"
    switchingMode = "native"
  }
}

resource "aci_rest_managed" "fvUplinkOrderCont" {
  for_each   = { for vmm_vwm in var.vmware_vmm_domains : vmm_vwm.name => vmm_vwm if vmm_vwm.active_uplinks_order != "" || vmm_vwm.standby_uplinks != "" }
  dn         = "${aci_rest_managed.fvRsDomAtt_vmm[each.key].dn}/uplinkorder"
  class_name = "fvUplinkOrderCont"

  content = {
    active  = each.value.active_uplinks_order
    standby = each.value.standby_uplinks
  }
}

resource "aci_rest_managed" "fvAEPgLagPolAtt" {
  for_each   = { for vmm_vwm in var.vmware_vmm_domains : vmm_vwm.name => vmm_vwm if vmm_vwm.elag != "" }
  dn         = "${aci_rest_managed.fvRsDomAtt_vmm[each.key].dn}/epglagpolatt"
  class_name = "fvAEPgLagPolAtt"
}

resource "aci_rest_managed" "fvRsVmmVSwitchEnhancedLagPol" {
  for_each   = { for vmm_vwm in var.vmware_vmm_domains : vmm_vwm.name => vmm_vwm if vmm_vwm.elag != "" }
  dn         = "${aci_rest_managed.fvAEPgLagPolAtt[each.key].dn}/rsvmmVSwitchEnhancedLagPol"
  class_name = "fvRsVmmVSwitchEnhancedLagPol"
  content = {
    tDn = "uni/vmmp-VMware/dom-${each.value.name}/vswitchpolcont/enlacplagp-${each.value.elag}"
  }
}

resource "aci_rest_managed" "vnsAddrInst" {
  for_each   = { for pool in var.l4l7_address_pools : pool.name => pool }
  dn         = "${aci_rest_managed.fvAEPg.dn}/CtrlrAddrInst-${each.key}"
  class_name = "vnsAddrInst"
  content = {
    name = each.value.name
    addr = each.value.gateway_address
  }
}

resource "aci_rest_managed" "fvnsUcastAddrBlk" {
  for_each   = { for pool in var.l4l7_address_pools : pool.name => pool if pool.from != "" && pool.to != "" }
  dn         = "${aci_rest_managed.vnsAddrInst[each.key].dn}/fromaddr-[${each.value.from}]-toaddr-[${each.value.to}]"
  class_name = "fvnsUcastAddrBlk"
  content = {
    from = each.value.from
    to   = each.value.to
  }
}

