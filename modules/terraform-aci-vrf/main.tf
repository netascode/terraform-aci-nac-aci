locals {
  # Destinations for leaked_internal_subnets (leakInternalSubnet)
  internal_subnet_destinations = flatten([
    for prefix in var.leaked_internal_subnets : [
      for dest in coalesce(prefix.destinations, []) : {
        key = "${prefix.prefix}/${dest.tenant}-${dest.vrf}"
        value = {
          prefix      = prefix.prefix
          tenant      = dest.tenant
          vrf         = dest.vrf
          public      = dest.public
          description = dest.description
        }
      }
    ]
  ])
  # Destinations for leaked_internal_prefixes (leakInternalPrefix)
  internal_prefix_destinations = flatten([
    for prefix in var.leaked_internal_prefixes : [
      for dest in coalesce(prefix.destinations, []) : {
        key = "${prefix.prefix}/${dest.tenant}-${dest.vrf}"
        value = {
          prefix      = prefix.prefix
          tenant      = dest.tenant
          vrf         = dest.vrf
          public      = dest.public
          description = dest.description
        }
      }
    ]
  ])
  external_destinations = flatten([
    for prefix in var.leaked_external_prefixes : [
      for dest in coalesce(prefix.destinations, []) : {
        key = "${prefix.prefix}/${dest.tenant}-${dest.vrf}"
        value = {
          prefix      = prefix.prefix
          tenant      = dest.tenant
          vrf         = dest.vrf
          description = dest.description
        }
      }
    ]
  ])
  route_summarization_subnets = flatten([
    for pol in var.route_summarization_policies : [
      for subnet in pol.subnets : {
        key = "${pol.name}/${subnet.prefix}"
        value = {
          policy = pol.name
          prefix = subnet.prefix
          tDn    = subnet.bgp_route_summarization_policy != null ? "uni/tn-${var.tenant}/bgprtsum-${subnet.bgp_route_summarization_policy}" : "uni/tn-common/bgprtsum-default"
        }
      }
    ]

  ])
}

resource "aci_rest_managed" "fvCtx" {
  dn         = "uni/tn-${var.tenant}/ctx-${var.name}"
  class_name = "fvCtx"
  annotation = var.annotation
  content = {
    "name"                = var.name
    "nameAlias"           = var.alias
    "descr"               = var.description
    "ipDataPlaneLearning" = var.data_plane_learning == true ? "enabled" : "disabled"
    "pcEnfDir"            = var.enforcement_direction
    "pcEnfPref"           = var.enforcement_preference
  }
}

resource "aci_rest_managed" "snmpCtxP" {
  dn         = "${aci_rest_managed.fvCtx.dn}/snmpctx"
  class_name = "snmpCtxP"
  content = {
    "name" = var.snmp_context_name
  }
}

resource "aci_rest_managed" "snmpCommunityP" {
  for_each   = { for comm_profile in var.snmp_context_community_profiles : comm_profile.name => comm_profile }
  dn         = "${aci_rest_managed.snmpCtxP.dn}/community-${each.value.name}"
  class_name = "snmpCommunityP"
  content = {
    "name"  = each.value.name
    "descr" = each.value.description
  }
}

resource "aci_rest_managed" "vzAny" {
  dn         = "${aci_rest_managed.fvCtx.dn}/any"
  class_name = "vzAny"
  content = {
    "descr"      = ""
    "prefGrMemb" = var.preferred_group == true ? "enabled" : "disabled"
  }
}

resource "aci_rest_managed" "vzRsAnyToCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest_managed.vzAny.dn}/rsanyToCons-${each.value}"
  class_name = "vzRsAnyToCons"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest_managed" "vzRsAnyToProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest_managed.vzAny.dn}/rsanyToProv-${each.value}"
  class_name = "vzRsAnyToProv"
  content = {
    "tnVzBrCPName" = each.value
  }
}

resource "aci_rest_managed" "vzRsAnyToConsIf" {
  for_each   = toset(var.contract_imported_consumers)
  dn         = "${aci_rest_managed.vzAny.dn}/rsanyToConsIf-${each.value}"
  class_name = "vzRsAnyToConsIf"
  content = {
    "tnVzCPIfName" = each.value
  }
}

resource "aci_rest_managed" "fvRsCtxToExtRouteTagPol" {
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToExtRouteTagPol"
  class_name = "fvRsCtxToExtRouteTagPol"
  content = {
    tnL3extRouteTagPolName = var.transit_route_tag_policy
  }
}

resource "aci_rest_managed" "fvRsOspfCtxPol" {
  dn         = "${aci_rest_managed.fvCtx.dn}/rsospfCtxPol"
  class_name = "fvRsOspfCtxPol"
  content = {
    tnOspfCtxPolName = var.ospf_timer_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToOspfCtxPol_ipv4" {
  count      = var.ospf_ipv4_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToOspfCtxPol-[${var.ospf_ipv4_address_family_context_policy}]-ipv4-ucast"
  class_name = "fvRsCtxToOspfCtxPol"
  content = {
    af               = "ipv4-ucast"
    tnOspfCtxPolName = var.ospf_ipv4_address_family_context_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToOspfCtxPol_ipv6" {
  count      = var.ospf_ipv6_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToOspfCtxPol-[${var.ospf_ipv6_address_family_context_policy}]-ipv6-ucast"
  class_name = "fvRsCtxToOspfCtxPol"
  content = {
    af               = "ipv6-ucast"
    tnOspfCtxPolName = var.ospf_ipv6_address_family_context_policy
  }
}

resource "aci_rest_managed" "fvRsBgpCtxPol" {
  dn         = "${aci_rest_managed.fvCtx.dn}/rsbgpCtxPol"
  class_name = "fvRsBgpCtxPol"
  content = {
    tnBgpCtxPolName = var.bgp_timer_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv4" {
  count      = var.bgp_ipv4_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToBgpCtxAfPol-[${var.bgp_ipv4_address_family_context_policy}]-ipv4-ucast"
  class_name = "fvRsCtxToBgpCtxAfPol"
  content = {
    af                = "ipv4-ucast"
    tnBgpCtxAfPolName = var.bgp_ipv4_address_family_context_policy
  }
}

resource "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv6" {
  count      = var.bgp_ipv6_address_family_context_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToBgpCtxAfPol-[${var.bgp_ipv6_address_family_context_policy}]-ipv6-ucast"
  class_name = "fvRsCtxToBgpCtxAfPol"
  content = {
    af                = "ipv6-ucast"
    tnBgpCtxAfPolName = var.bgp_ipv6_address_family_context_policy
  }
}

resource "aci_rest_managed" "bgpRtTargetP_ipv4" {
  count      = length(var.bgp_ipv4_import_route_target) > 0 || length(var.bgp_ipv4_export_route_target) > 0 ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rtp-ipv4-ucast"
  class_name = "bgpRtTargetP"
  content = {
    af = "ipv4-ucast"
  }
}

resource "aci_rest_managed" "bgpRtTarget_ipv4_import" {
  for_each   = toset(var.bgp_ipv4_import_route_target)
  dn         = "${aci_rest_managed.bgpRtTargetP_ipv4[0].dn}/rt-[${each.value}]-import"
  class_name = "bgpRtTarget"
  content = {
    rt   = each.value
    type = "import"
  }
}

resource "aci_rest_managed" "bgpRtTarget_ipv4_export" {
  for_each   = toset(var.bgp_ipv4_export_route_target)
  dn         = "${aci_rest_managed.bgpRtTargetP_ipv4[0].dn}/rt-[${each.value}]-export"
  class_name = "bgpRtTarget"
  content = {
    rt   = each.value
    type = "export"
  }
}

resource "aci_rest_managed" "bgpRtTargetP_ipv6" {
  count      = length(var.bgp_ipv6_import_route_target) > 0 || length(var.bgp_ipv6_export_route_target) > 0 ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rtp-ipv6-ucast"
  class_name = "bgpRtTargetP"
  content = {
    af = "ipv6-ucast"
  }
}

resource "aci_rest_managed" "bgpRtTarget_ipv6_import" {
  for_each   = toset(var.bgp_ipv6_import_route_target)
  dn         = "${aci_rest_managed.bgpRtTargetP_ipv6[0].dn}/rt-[${each.value}]-import"
  class_name = "bgpRtTarget"
  content = {
    rt   = each.value
    type = "import"
  }
}

resource "aci_rest_managed" "bgpRtTarget_ipv6_export" {
  for_each   = toset(var.bgp_ipv6_export_route_target)
  dn         = "${aci_rest_managed.bgpRtTargetP_ipv6[0].dn}/rt-[${each.value}]-export"
  class_name = "bgpRtTarget"
  content = {
    rt   = each.value
    type = "export"
  }
}

resource "aci_rest_managed" "dnsLbl" {
  for_each   = toset(var.dns_labels)
  dn         = "${aci_rest_managed.fvCtx.dn}/dnslbl-${each.value}"
  class_name = "dnsLbl"
  content = {
    name = each.value
  }
}

resource "aci_rest_managed" "pimCtxP" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/pimctxp"
  class_name = "pimCtxP"
  content = {
    mtu  = var.pim_mtu
    ctrl = join(",", concat(var.pim_fast_convergence == true ? ["fast-conv"] : [], var.pim_strict_rfc == true ? ["strict-rfc-compliant"] : []))
  }
}

resource "aci_rest_managed" "pimResPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/res"
  class_name = "pimResPol"
  content = {
    max  = var.pim_max_multicast_entries
    rsvd = var.pim_reserved_multicast_entries
  }

  dynamic "child" {
    for_each = var.pim_resource_policy_multicast_route_map != "" ? [0] : []
    content {
      rn         = "rsfilterToRtMapPol"
      class_name = "rtdmcRsFilterToRtMapPol"
      content = {
        tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_resource_policy_multicast_route_map}"
      }
    }
  }
}

resource "aci_rest_managed" "pimStaticRPPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/staticrp"
  class_name = "pimStaticRPPol"
}

resource "aci_rest_managed" "pimStaticRPEntryPol_static_rp" {
  for_each   = { for rp in var.pim_static_rps : rp.ip => rp if var.pim_enabled == true }
  dn         = "${aci_rest_managed.pimStaticRPPol[0].dn}/staticrpent-[${each.value.ip}]"
  class_name = "pimStaticRPEntryPol"
  content = {
    rpIp = each.value.ip
  }
}

resource "aci_rest_managed" "pimRPGrpRangePol_static_rp" {
  for_each   = { for rp in var.pim_static_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimStaticRPEntryPol_static_rp[each.value.ip].dn}/rpgrprange"
  class_name = "pimRPGrpRangePol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_static_rp" {
  for_each   = { for rp in var.pim_static_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimRPGrpRangePol_static_rp[each.value.ip].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${each.value.multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimFabricRPPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/fabricrp"
  class_name = "pimFabricRPPol"
}

resource "aci_rest_managed" "pimStaticRPEntryPol_fabric_rp" {
  for_each   = { for rp in var.pim_fabric_rps : rp.ip => rp if var.pim_enabled == true }
  dn         = "${aci_rest_managed.pimFabricRPPol[0].dn}/staticrpent-[${each.value.ip}]"
  class_name = "pimStaticRPEntryPol"
  content = {
    rpIp = each.value.ip
  }
}

resource "aci_rest_managed" "pimRPGrpRangePol_fabric_rp" {
  for_each   = { for rp in var.pim_fabric_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimStaticRPEntryPol_fabric_rp[each.value.ip].dn}/rpgrprange"
  class_name = "pimRPGrpRangePol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_fabric_rp" {
  for_each   = { for rp in var.pim_fabric_rps : rp.ip => rp if var.pim_enabled == true && rp.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimRPGrpRangePol_fabric_rp[each.value.ip].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${each.value.multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimBSRPPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/bsrp"
  class_name = "pimBSRPPol"
  content = {
    ctrl = join(",", concat(var.pim_bsr_forward_updates == true ? ["forward"] : [], var.pim_bsr_listen_updates == true ? ["listen"] : []))
  }
}

resource "aci_rest_managed" "pimBSRFilterPol" {
  count      = var.pim_enabled == true && var.pim_bsr_filter_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBSRPPol[0].dn}/bsfilter"
  class_name = "pimBSRFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_bsr" {
  count      = var.pim_enabled == true && var.pim_bsr_filter_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimBSRFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_bsr_filter_multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimAutoRPPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/autorp"
  class_name = "pimAutoRPPol"
  content = {
    ctrl = join(",", concat(var.pim_auto_rp_forward_updates == true ? ["forward"] : [], var.pim_auto_rp_listen_updates == true ? ["listen"] : []))
  }
}

resource "aci_rest_managed" "pimMAFilterPol" {
  count      = var.pim_enabled == true && var.pim_auto_rp_filter_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimAutoRPPol[0].dn}/mafilter"
  class_name = "pimMAFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_auto_rp" {
  count      = var.pim_enabled == true && var.pim_auto_rp_filter_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimMAFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_auto_rp_filter_multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimASMPatPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/asmpat"
  class_name = "pimASMPatPol"
  content = {
    ctrl = ""
  }
}

resource "aci_rest_managed" "pimSharedRangePol" {
  count      = var.pim_enabled == true && var.pim_asm_shared_range_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimASMPatPol[0].dn}/sharedrange"
  class_name = "pimSharedRangePol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_asm_shared" {
  count      = var.pim_enabled == true && var.pim_asm_shared_range_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimSharedRangePol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_asm_shared_range_multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimSGRangeExpPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimASMPatPol[0].dn}/sgrangeexp"
  class_name = "pimSGRangeExpPol"
  content = {
    sgExpItvl = var.pim_asm_sg_expiry
  }
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_asm_sg_expiry" {
  count      = var.pim_enabled == true && var.pim_asm_sg_expiry_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimSGRangeExpPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_asm_sg_expiry_multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimRegTrPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimASMPatPol[0].dn}/regtr"
  class_name = "pimRegTrPol"
  content = {
    maxRate = var.pim_asm_traffic_registry_max_rate
    srcIp   = var.pim_asm_traffic_registry_source_ip
  }
}

resource "aci_rest_managed" "pimSSMPatPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/ssmpat"
  class_name = "pimSSMPatPol"
}

resource "aci_rest_managed" "pimSSMRangePol" {
  count      = var.pim_enabled == true && var.pim_ssm_group_range_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimSSMPatPol[0].dn}/ssmrange"
  class_name = "pimSSMRangePol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_ssm_range" {
  count      = var.pim_enabled == true && var.pim_ssm_group_range_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimSSMRangePol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.pim_ssm_group_range_multicast_route_map}"
  }
}

resource "aci_rest_managed" "pimInterVRFPol" {
  count      = var.pim_enabled == true ? 1 : 0
  dn         = "${aci_rest_managed.pimCtxP[0].dn}/intervrf"
  class_name = "pimInterVRFPol"
}

resource "aci_rest_managed" "pimInterVRFEntryPol" {
  for_each   = { for vrf_pol in var.pim_inter_vrf_policies : vrf_pol.vrf => vrf_pol if var.pim_enabled == true }
  dn         = "${aci_rest_managed.pimInterVRFPol[0].dn}/intervrfent-[uni/tn-${each.value.tenant}/ctx-${each.value.vrf}]"
  class_name = "pimInterVRFEntryPol"
  content = {
    srcVrfDn = "uni/tn-${each.value.tenant}/ctx-${each.value.vrf}"
  }
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_pim_inter_vrf" {
  for_each   = { for vrf_pol in var.pim_inter_vrf_policies : vrf_pol.vrf => vrf_pol if var.pim_enabled == true && vrf_pol.multicast_route_map != "" }
  dn         = "${aci_rest_managed.pimInterVRFEntryPol[each.value.vrf].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${each.value.multicast_route_map}"
  }
}

resource "aci_rest_managed" "igmpCtxP" {
  count      = var.pim_enabled == true && length(var.pim_igmp_ssm_translate_policies) != 0 ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/igmpctxp"
  class_name = "igmpCtxP"
}

resource "aci_rest_managed" "igmpSSMXlateP" {
  for_each   = { for pol in var.pim_igmp_ssm_translate_policies : "${pol.group_prefix}-${pol.source_address}" => pol if var.pim_enabled == true }
  dn         = "${aci_rest_managed.igmpCtxP[0].dn}/ssmxlate-[${each.value.group_prefix}]-[${each.value.source_address}]"
  class_name = "igmpSSMXlateP"
  content = {
    descr   = "${each.value.group_prefix}-${each.value.source_address}"
    grpPfx  = each.value.group_prefix
    srcAddr = each.value.source_address
  }
}

resource "aci_rest_managed" "leakRoutes" {
  count      = length(var.leaked_internal_subnets) > 0 || length(var.leaked_internal_prefixes) > 0 || length(var.leaked_external_prefixes) > 0 ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/leakroutes"
  class_name = "leakRoutes"
}

# leakInternalSubnet - EPG/BD Subnets (leaked_internal_subnets)
resource "aci_rest_managed" "leakInternalSubnet" {
  for_each   = { for prefix in var.leaked_internal_subnets : prefix.prefix => prefix }
  dn         = "${aci_rest_managed.leakRoutes[0].dn}/leakintsubnet-[${each.value.prefix}]"
  class_name = "leakInternalSubnet"
  content = {
    ip    = each.value.prefix
    scope = each.value.public == true ? "public" : "private"
  }
}

resource "aci_rest_managed" "leakTo_internal_subnet" {
  for_each   = { for dest in local.internal_subnet_destinations : dest.key => dest.value }
  dn         = "${aci_rest_managed.leakInternalSubnet[each.value.prefix].dn}/to-[${each.value.tenant}]-[${each.value.vrf}]"
  class_name = "leakTo"
  content = {
    tenantName = each.value.tenant
    ctxName    = each.value.vrf
    descr      = each.value.description
    scope      = each.value.public == null ? "inherit" : (each.value.public == true ? "public" : "private")
  }
}

# leakInternalPrefix - Internal Prefixes (leaked_internal_prefixes)
# Prefix-level scope requires APIC 6.1+
resource "aci_rest_managed" "leakInternalPrefix" {
  for_each   = { for prefix in var.leaked_internal_prefixes : prefix.prefix => prefix }
  dn         = "${aci_rest_managed.leakRoutes[0].dn}/leakintprefix-[${each.value.prefix}]"
  class_name = "leakInternalPrefix"
  content = {
    ip    = each.value.prefix
    scope = each.value.public == true ? "public" : "private"
    ge    = each.value.from_prefix_length != null ? each.value.from_prefix_length : "unspecified"
    le    = each.value.to_prefix_length != null ? each.value.to_prefix_length : "unspecified"
  }
}

resource "aci_rest_managed" "leakTo_internal_prefix" {
  for_each   = { for dest in local.internal_prefix_destinations : dest.key => dest.value }
  dn         = "${aci_rest_managed.leakInternalPrefix[each.value.prefix].dn}/to-[${each.value.tenant}]-[${each.value.vrf}]"
  class_name = "leakTo"
  content = {
    tenantName = each.value.tenant
    ctxName    = each.value.vrf
    descr      = each.value.description
    scope      = each.value.public == null ? "inherit" : (each.value.public == true ? "public" : "private")
  }
}

resource "aci_rest_managed" "leakExternalPrefix" {
  for_each   = { for prefix in var.leaked_external_prefixes : prefix.prefix => prefix }
  dn         = "${aci_rest_managed.leakRoutes[0].dn}/leakextsubnet-[${each.value.prefix}]"
  class_name = "leakExternalPrefix"
  content = {
    ip = each.value.prefix
    le = each.value.to_prefix_length
    ge = each.value.from_prefix_length
  }
}

resource "aci_rest_managed" "leakTo_external" {
  for_each   = { for dest in local.external_destinations : dest.key => dest.value }
  dn         = "${aci_rest_managed.leakExternalPrefix[each.value.prefix].dn}/to-[${each.value.tenant}]-[${each.value.vrf}]"
  class_name = "leakTo"
  content = {
    tenantName = each.value.tenant
    ctxName    = each.value.vrf
    descr      = each.value.description
  }
}

resource "aci_rest_managed" "fvCtxRtSummPol" {
  for_each   = { for pol in var.route_summarization_policies : pol.name => pol }
  dn         = "${aci_rest_managed.fvCtx.dn}/ctxrtsummpol-${each.value.name}"
  class_name = "fvCtxRtSummPol"
  content = {
    name = each.value.name
  }

  dynamic "child" {
    for_each = { for node in each.value.nodes : node.id => node }
    content {
      rn         = "rsnodeRtSummAtt-[topology/pod-${child.value.pod}/node-${child.value.id}]"
      class_name = "fvRsNodeRtSummAtt"
      content = {
        tDn = "topology/pod-${child.value.pod}/node-${child.value.id}"
      }
    }
  }
}

resource "aci_rest_managed" "fvRtSummSubnet" {
  for_each   = { for subnet in local.route_summarization_subnets : subnet.key => subnet.value }
  dn         = "${aci_rest_managed.fvCtxRtSummPol[each.value.policy].dn}/rtsummsubnet-[${each.value.prefix}]"
  class_name = "fvRtSummSubnet"
  content = {
    prefix = each.value.prefix
  }

  child {
    rn         = "rsSubnetToRtSummPol"
    class_name = "fvRsSubnetToRtSummPol"
    content = {
      tDn = each.value.tDn
    }
  }
}

resource "aci_rest_managed" "fvRsCtxToEpRet" {
  count      = var.endpoint_retention_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvCtx.dn}/rsctxToEpRet"
  class_name = "fvRsCtxToEpRet"
  content = {
    tnFvEpRetPolName = var.endpoint_retention_policy
  }
}
