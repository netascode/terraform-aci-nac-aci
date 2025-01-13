locals {
  additional_ip_list = flatten([
    for st_ep in var.static_endpoints : [
      for ip in lookup(st_ep, "additional_ips", []) : {
        id   = st_ep.name != "" ? "${st_ep.name}-${ip}" : "${st_ep.mac}-${ip}"
        name = st_ep.name
        mac  = st_ep.mac
        ip   = ip
      }
    ]
  ])
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
  annotation = var.annotation
  content = {
    name         = var.name
    nameAlias    = var.alias
    descr        = var.description
    floodOnEncap = var.flood_in_encap == true ? "enabled" : "disabled"
    pcEnfPref    = var.intra_epg_isolation == true ? "enforced" : "unenforced"
    fwdCtrl      = var.proxy_arp ? "proxy-arp" : ""
    prefGrMemb   = var.preferred_group == true ? "include" : "exclude"
    prio         = var.qos_class
  }

  dynamic "child" {
    for_each = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.module}-${sp.port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.port}-vl-${sp.vlan}") => sp if sp.channel == null && sp.fex_id == null && sp.sub_port == null && var.bulk_static_ports }
    content {
      rn         = "rspathAtt-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", child.value.pod_id, child.value.node_id, child.value.module, child.value.port)}]"
      class_name = "fvRsPathAtt"
      content = {
        tDn          = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", child.value.pod_id, child.value.node_id, child.value.module, child.value.port)
        descr        = child.value.description
        encap        = "vlan-${child.value.vlan}"
        primaryEncap = child.value.primary_vlan != null ? "vlan-${child.value.primary_vlan}" : "unknown"
        mode         = child.value.mode
        instrImedcy  = child.value.deployment_immediacy
      }
    }
  }

  dynamic "child" {
    for_each = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.module}-${sp.port}-${sp.sub_port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.port}-${sp.sub_port}-vl-${sp.vlan}") => sp if sp.channel == null && sp.fex_id == null && sp.sub_port != null && var.bulk_static_ports }
    content {
      rn         = "rspathAtt-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", child.value.pod_id, child.value.node_id, child.value.module, child.value.port, child.value.sub_port)}]"
      class_name = "fvRsPathAtt"
      content = {
        tDn          = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", child.value.pod_id, child.value.node_id, child.value.module, child.value.port, child.value.sub_port)
        descr        = child.value.description
        encap        = "vlan-${child.value.vlan}"
        primaryEncap = child.value.primary_vlan != null ? "vlan-${child.value.primary_vlan}" : "unknown"
        mode         = child.value.mode
        instrImedcy  = child.value.deployment_immediacy
      }
    }
  }

  dynamic "child" {
    for_each = { for sp in var.static_ports : "${sp.node_id}-${sp.channel}-vl-${sp.vlan}" => sp if sp.channel != null && sp.fex_id == null && var.bulk_static_ports }
    content {
      rn         = "rspathAtt-[${format(child.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", child.value.pod_id, child.value.node_id, child.value.node2_id, child.value.channel)}]"
      class_name = "fvRsPathAtt"
      content = {
        tDn          = format(child.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", child.value.pod_id, child.value.node_id, child.value.node2_id, child.value.channel)
        descr        = child.value.description
        encap        = "vlan-${child.value.vlan}"
        primaryEncap = child.value.primary_vlan != null ? "vlan-${child.value.primary_vlan}" : "unknown"
        mode         = child.value.mode
        instrImedcy  = child.value.deployment_immediacy
      }
    }
  }

  dynamic "child" {
    for_each = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.fex_id}-${sp.module}-${sp.port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.fex_id}-${sp.port}-vl-${sp.vlan}") => sp if sp.channel == null && sp.fex_id != null && var.bulk_static_ports }
    content {
      rn         = "rspathAtt-[${format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", child.value.pod_id, child.value.node_id, child.value.fex_id, child.value.module, child.value.port)}]"
      class_name = "fvRsPathAtt"
      content = {
        tDn          = format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", child.value.pod_id, child.value.node_id, child.value.fex_id, child.value.module, child.value.port)
        descr        = child.value.description
        encap        = "vlan-${child.value.vlan}"
        primaryEncap = child.value.primary_vlan != null ? "vlan-${child.value.primary_vlan}" : "unknown"
        mode         = child.value.mode
        instrImedcy  = child.value.deployment_immediacy
      }
    }
  }

  dynamic "child" {
    for_each = { for sp in var.static_ports : "${sp.node_id}-${sp.fex_id}-${sp.channel}-vl-${sp.vlan}" => sp if sp.channel != null && sp.fex_id != null && var.bulk_static_ports }
    content {
      rn         = "rspathAtt-[${format(child.value.node2_id != null && child.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", child.value.pod_id, child.value.node_id, child.value.node2_id, child.value.fex_id, child.value.fex2_id, child.value.channel)}]"
      class_name = "fvRsPathAtt"
      content = {
        tDn          = format(child.value.node2_id != null && child.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", child.value.pod_id, child.value.node_id, child.value.node2_id, child.value.fex_id, child.value.fex2_id, child.value.channel)
        descr        = child.value.description
        encap        = "vlan-${child.value.vlan}"
        primaryEncap = child.value.primary_vlan != null ? "vlan-${child.value.primary_vlan}" : "unknown"
        mode         = child.value.mode
        instrImedcy  = child.value.deployment_immediacy
      }
    }
  }
}

resource "aci_rest_managed" "fvRsBd" {
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsbd"
  class_name = "fvRsBd"
  annotation = var.annotation
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

resource "aci_rest_managed" "fvSubnet" {
  for_each   = { for subnet in var.subnets : subnet.ip => subnet }
  dn         = "${aci_rest_managed.fvAEPg.dn}/subnet-[${each.value.ip}]"
  class_name = "fvSubnet"
  content = {
    ip           = each.value.ip
    descr        = each.value.description != null ? each.value.description : ""
    ctrl         = join(",", concat(each.value.nd_ra_prefix == true ? ["nd"] : [], each.value.no_default_gateway == true ? ["no-default-gateway"] : [], each.value.igmp_querier == true ? ["querier"] : []))
    scope        = join(",", concat(each.value.public == true ? ["public"] : ["private"], each.value.shared == true ? ["shared"] : []))
    ipDPLearning = each.value.ip_dataplane_learning != null ? (each.value.ip_dataplane_learning == true ? "enabled" : "disabled") : null
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
  for_each   = { for sp in var.static_leafs : "${sp.node_id}-vl-${sp.vlan}" => sp }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsnodeAtt-[${format("topology/pod-%s/node-%s", each.value.pod_id, each.value.node_id)}]"
  class_name = "fvRsNodeAtt"
  content = {
    tDn         = format("topology/pod-%s/node-%s", each.value.pod_id, each.value.node_id)
    encap       = "vlan-${each.value.vlan}"
    mode        = each.value.mode
    instrImedcy = each.value.deployment_immediacy
  }
}

resource "aci_rest_managed" "fvRsPathAtt_port" {
  for_each   = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.module}-${sp.port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.port}-vl-${sp.vlan}") => sp if sp.channel == null && sp.fex_id == null && sp.sub_port == null && !var.bulk_static_ports }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)}]"
  class_name = "fvRsPathAtt"
  content = {
    tDn          = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)
    descr        = each.value.description
    encap        = "vlan-${each.value.vlan}"
    primaryEncap = each.value.primary_vlan != null ? "vlan-${each.value.primary_vlan}" : "unknown"
    mode         = each.value.mode
    instrImedcy  = each.value.deployment_immediacy
  }
}

resource "aci_rest_managed" "ptpEpgCfg_port" {
  for_each   = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.module}-${sp.port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.port}-vl-${sp.vlan}") => sp if sp.ptp_profile != null && sp.channel == null && sp.fex_id == null && sp.sub_port == null }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)}]/ptpEpgCfg"
  class_name = "ptpEpgCfg"
  content = {
    srcIp   = each.value.ptp_source_ip
    ptpMode = each.value.ptp_mode
  }
  child {
    class_name = "ptpRsProfile"
    rn         = "rsprofile"
    content = {
      "tDn" = "uni/infra/ptpprofile-${each.value.ptp_profile}"
    }
  }

  depends_on = [aci_rest_managed.fvRsPathAtt_port]
}

resource "aci_rest_managed" "fvRsPathAtt_subport" {
  for_each   = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.module}-${sp.port}-${sp.sub_port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.port}-${sp.sub_port}-vl-${sp.vlan}") => sp if sp.channel == null && sp.fex_id == null && sp.sub_port != null && !var.bulk_static_ports }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)}]"
  class_name = "fvRsPathAtt"
  content = {
    tDn          = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)
    descr        = each.value.description
    encap        = "vlan-${each.value.vlan}"
    primaryEncap = each.value.primary_vlan != null ? "vlan-${each.value.primary_vlan}" : "unknown"
    mode         = each.value.mode
    instrImedcy  = each.value.deployment_immediacy
  }
}

resource "aci_rest_managed" "ptpEpgCfg_subport" {
  for_each   = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.module}-${sp.port}-${sp.sub_port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.port}-${sp.sub_port}-vl-${sp.vlan}") => sp if sp.ptp_profile != null && sp.channel == null && sp.fex_id == null && sp.sub_port != null }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)}]/ptpEpgCfg"
  class_name = "ptpEpgCfg"
  content = {
    srcIp   = each.value.ptp_source_ip
    ptpMode = each.value.ptp_mode
  }
  child {
    class_name = "ptpRsProfile"
    rn         = "rsprofile"
    content = {
      "tDn" = "uni/infra/ptpprofile-${each.value.ptp_profile}"
    }
  }

  depends_on = [aci_rest_managed.fvRsPathAtt_subport]
}

resource "aci_rest_managed" "fvRsPathAtt_channel" {
  for_each   = { for sp in var.static_ports : "${sp.node_id}-${sp.channel}-vl-${sp.vlan}" => sp if sp.channel != null && sp.fex_id == null && !var.bulk_static_ports }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)}]"
  class_name = "fvRsPathAtt"
  content = {
    tDn          = format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)
    descr        = each.value.description
    encap        = "vlan-${each.value.vlan}"
    primaryEncap = each.value.primary_vlan != null ? "vlan-${each.value.primary_vlan}" : "unknown"
    mode         = each.value.mode
    instrImedcy  = each.value.deployment_immediacy
  }
}

resource "aci_rest_managed" "ptpEpgCfg_channel" {
  for_each   = { for sp in var.static_ports : "${sp.node_id}-${sp.channel}-vl-${sp.vlan}" => sp if sp.ptp_profile != null && sp.channel != null && sp.fex_id == null }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)}]/ptpEpgCfg"
  class_name = "ptpEpgCfg"
  content = {
    srcIp   = each.value.ptp_source_ip
    ptpMode = each.value.ptp_mode
  }
  child {
    class_name = "ptpRsProfile"
    rn         = "rsprofile"
    content = {
      "tDn" = "uni/infra/ptpprofile-${each.value.ptp_profile}"
    }
  }

  depends_on = [aci_rest_managed.fvRsPathAtt_channel]
}

resource "aci_rest_managed" "fvRsPathAtt_fex_port" {
  for_each   = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.fex_id}-${sp.module}-${sp.port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.fex_id}-${sp.port}-vl-${sp.vlan}") => sp if sp.channel == null && sp.fex_id != null && !var.bulk_static_ports }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)}]"
  class_name = "fvRsPathAtt"
  content = {
    tDn          = format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)
    descr        = each.value.description
    encap        = "vlan-${each.value.vlan}"
    primaryEncap = each.value.primary_vlan != null ? "vlan-${each.value.primary_vlan}" : "unknown"
    mode         = each.value.mode
    instrImedcy  = each.value.deployment_immediacy
  }
}

resource "aci_rest_managed" "ptpEpgCfg_fex_port" {
  for_each   = { for sp in var.static_ports : (sp.module != 1 ? "${sp.node_id}-${sp.fex_id}-${sp.module}-${sp.port}-vl-${sp.vlan}" : "${sp.node_id}-${sp.fex_id}-${sp.port}-vl-${sp.vlan}") => sp if sp.ptp_profile != null && sp.channel == null && sp.fex_id != null }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)}]/ptpEpgCfg"
  class_name = "ptpEpgCfg"
  content = {
    srcIp   = each.value.ptp_source_ip
    ptpMode = each.value.ptp_mode
  }
  child {
    class_name = "ptpRsProfile"
    rn         = "rsprofile"
    content = {
      "tDn" = "uni/infra/ptpprofile-${each.value.ptp_profile}"
    }
  }

  depends_on = [aci_rest_managed.fvRsPathAtt_fex_port]
}

resource "aci_rest_managed" "fvRsPathAtt_fex_channel" {
  for_each   = { for sp in var.static_ports : "${sp.node_id}-${sp.fex_id}-${sp.channel}-vl-${sp.vlan}" => sp if sp.channel != null && sp.fex_id != null && !var.bulk_static_ports }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)}]"
  class_name = "fvRsPathAtt"
  content = {
    tDn          = format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)
    descr        = each.value.description
    encap        = "vlan-${each.value.vlan}"
    primaryEncap = each.value.primary_vlan != null ? "vlan-${each.value.primary_vlan}" : "unknown"
    mode         = each.value.mode
    instrImedcy  = each.value.deployment_immediacy
  }
}

resource "aci_rest_managed" "ptpEpgCfg_fex_channel" {
  for_each   = { for sp in var.static_ports : "${sp.node_id}-${sp.fex_id}-${sp.channel}-vl-${sp.vlan}" => sp if sp.ptp_profile != null && sp.channel != null && sp.fex_id != null }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rspathAtt-[${format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)}]/ptpEpgCfg"
  class_name = "ptpEpgCfg"
  content = {
    srcIp   = each.value.ptp_source_ip
    ptpMode = each.value.ptp_mode
  }
  child {
    class_name = "ptpRsProfile"
    rn         = "rsprofile"
    content = {
      "tDn" = "uni/infra/ptpprofile-${each.value.ptp_profile}"
    }
  }

  depends_on = [aci_rest_managed.fvRsPathAtt_fex_channel]
}

resource "aci_rest_managed" "fvStCEp" {
  for_each   = { for sp_ep in var.static_endpoints : (sp_ep.name != "" ? sp_ep.name : sp_ep.mac) => sp_ep }
  dn         = "${aci_rest_managed.fvAEPg.dn}/stcep-${each.value.mac}-type-${each.value.type}"
  class_name = "fvStCEp"
  content = {
    encap     = each.value.type != "vep" ? "vlan-${each.value.vlan}" : "unknown"
    id        = "0"
    ip        = each.value.ip
    mac       = each.value.mac
    name      = each.value.name
    nameAlias = each.value.alias
    type      = each.value.type
  }
}

resource "aci_rest_managed" "fvStIp" {
  for_each   = { for ip in local.additional_ip_list : ip.id => ip }
  dn         = "${aci_rest_managed.fvStCEp[(each.value.name != "" ? each.value.name : each.value.mac)].dn}/ip-[${each.value.ip}]"
  class_name = "fvStIp"
  content = {
    addr = each.value.ip
  }
}

resource "aci_rest_managed" "fvRsStCEpToPathEp_port" {
  for_each   = { for sp_ep in var.static_endpoints : (sp_ep.name != "" ? sp_ep.name : sp_ep.mac) => sp_ep if sp_ep.port != null }
  dn         = "${aci_rest_managed.fvStCEp[(each.value.name != "" ? each.value.name : each.value.mac)].dn}/rsstCEpToPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)}]"
  class_name = "fvRsStCEpToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "fvRsStCEpToPathEp_channel" {
  for_each   = { for sp_ep in var.static_endpoints : (sp_ep.name != "" ? sp_ep.name : sp_ep.mac) => sp_ep if sp_ep.channel != null }
  dn         = "${aci_rest_managed.fvStCEp[(each.value.name != "" ? each.value.name : each.value.mac)].dn}/rsstCEpToPathEp-[${format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)}]"
  class_name = "fvRsStCEpToPathEp"
  content = {
    tDn = format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)
  }
}

resource "aci_rest_managed" "fvRsDomAtt_vmm" {
  for_each   = { for vmm_vwm in var.vmware_vmm_domains : vmm_vwm.name => vmm_vwm }
  dn         = "${aci_rest_managed.fvAEPg.dn}/rsdomAtt-[uni/vmmp-VMware/dom-${each.value.name}]"
  class_name = "fvRsDomAtt"
  content = {
    tDn           = "uni/vmmp-VMware/dom-${each.value.name}"
    classPref     = each.value.u_segmentation == true ? "useg" : "encap"
    delimiter     = each.value.delimiter
    encap         = each.value.primary_vlan != null ? (each.value.secondary_vlan != null ? "vlan-${each.value.secondary_vlan}" : "unknown") : (each.value.vlan != null ? "vlan-${each.value.vlan}" : "unknown")
    encapMode     = "auto"
    primaryEncap  = each.value.primary_vlan != null ? "vlan-${each.value.primary_vlan}" : "unknown"
    netflowPref   = each.value.netflow == true ? "enabled" : "disabled"
    instrImedcy   = each.value.deployment_immediacy
    resImedcy     = each.value.resolution_immediacy
    switchingMode = "native"
    customEpgName = each.value.custom_epg_name
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

resource "aci_rest_managed" "vmmSecP" {
  for_each   = { for vmm_vwm in var.vmware_vmm_domains : vmm_vwm.name => vmm_vwm }
  dn         = "${aci_rest_managed.fvRsDomAtt_vmm[each.key].dn}/sec"
  class_name = "vmmSecP"
  content = {
    allowPromiscuous = each.value.allow_promiscuous == true ? "accept" : "reject"
    forgedTransmits  = each.value.forged_transmits == true ? "accept" : "reject"
    macChanges       = each.value.mac_changes == true ? "accept" : "reject"
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

resource "aci_rest_managed" "fvVip" {
  for_each   = { for vip in var.l4l7_virtual_ips : vip.ip => vip }
  dn         = "${aci_rest_managed.fvAEPg.dn}/vip-[${each.key}]"
  class_name = "fvVip"
  content = {
    addr  = each.value.ip
    descr = each.value.description
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

