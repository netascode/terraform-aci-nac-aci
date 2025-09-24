resource "aci_rest_managed" "l3extOut" {
  dn          = "uni/tn-${var.tenant}/out-${var.name}"
  class_name  = "l3extOut"
  annotation  = var.annotation
  escape_html = false
  content = var.sr_mpls == true ? {
    name          = var.name
    descr         = var.description
    nameAlias     = var.alias
    targetDscp    = var.target_dscp
    enforceRtctrl = join(",", concat(var.export_route_control_enforcement == true ? ["export"] : [], var.import_route_control_enforcement == true ? ["import"] : []))
    mplsEnabled   = "yes"
    } : {
    name          = var.name
    descr         = var.description
    nameAlias     = var.alias
    targetDscp    = var.target_dscp
    enforceRtctrl = join(",", concat(var.export_route_control_enforcement == true ? ["export"] : [], var.import_route_control_enforcement == true ? ["import"] : []))
  }
}

resource "aci_rest_managed" "ospfExtP" {
  count      = var.ospf == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/ospfExtP"
  class_name = "ospfExtP"
  content = {
    areaCost = var.ospf_area_cost
    areaCtrl = join(",", concat(var.ospf_area_control_redistribute == true ? ["redistribute"] : [], var.ospf_area_control_summary == true ? ["summary"] : [], var.ospf_area_control_suppress_fa == true ? ["suppress-fa"] : []))
    areaId   = try(tonumber(var.ospf_area), false) != false ? format("%s.%s.%s.%s", floor(var.ospf_area % pow(2, 32) / pow(2, 24)), floor(var.ospf_area % pow(2, 24) / pow(2, 16)), floor(var.ospf_area % pow(2, 16) / pow(2, 8)), var.ospf_area % pow(2, 8)) : var.ospf_area
    areaType = var.ospf_area_type
  }
}

resource "aci_rest_managed" "eigrpExtP" {
  count      = var.eigrp == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/eigrpExtP"
  class_name = "eigrpExtP"
  content = {
    asn = var.eigrp_asn
  }
}

resource "aci_rest_managed" "bgpExtP" {
  count      = (var.tenant == "infra" && var.multipod) || var.bgp == true || var.sr_mpls ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/bgpExtP"
  class_name = "bgpExtP"
}

resource "aci_rest_managed" "l3extRsL3DomAtt" {
  count      = var.sr_mpls == true && var.tenant != "infra" ? 0 : 1
  dn         = "${aci_rest_managed.l3extOut.dn}/rsl3DomAtt"
  class_name = "l3extRsL3DomAtt"
  content = {
    tDn = "uni/l3dom-${var.routed_domain}"
  }
}

resource "aci_rest_managed" "l3extRsEctx" {
  dn         = "${aci_rest_managed.l3extOut.dn}/rsectx"
  class_name = "l3extRsEctx"
  annotation = var.annotation
  content = {
    tnFvCtxName = var.vrf
  }
}

resource "aci_rest_managed" "rtctrlProfile_import" {
  count      = length(var.import_route_map_contexts) > 0 ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/prof-${var.import_route_map_name}"
  class_name = "rtctrlProfile"
  content = {
    name  = var.import_route_map_name
    descr = var.import_route_map_description
    type  = var.import_route_map_type
  }
}

resource "aci_rest_managed" "rtctrlCtxP_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context }
  dn         = "${aci_rest_managed.rtctrlProfile_import[0].dn}/ctx-${each.value.name}"
  class_name = "rtctrlCtxP"
  content = {
    name   = each.value.name
    descr  = each.value.description
    action = each.value.action
    order  = each.value.order
  }
}

resource "aci_rest_managed" "rtctrlScope_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlCtxP_import[each.value.name].dn}/scp"
  class_name = "rtctrlScope"
}

resource "aci_rest_managed" "rtctrlRsScopeToAttrP_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlScope_import[each.value.name].dn}/rsScopeToAttrP"
  class_name = "rtctrlRsScopeToAttrP"
  content = {
    tnRtctrlAttrPName = each.value.set_rule
  }
}

locals {
  import_match_rules = flatten([
    for context in try(var.import_route_map_contexts, []) : [
      for rule in try(context.match_rules, []) : {
        id         = "${context.name}-${rule}"
        context    = context.name
        match_rule = rule
      }
    ]
  ])
}

resource "aci_rest_managed" "rtctrlRsCtxPToSubjP_import" {
  for_each   = { for match_rules in local.import_match_rules : match_rules.id => match_rules }
  dn         = "${aci_rest_managed.rtctrlCtxP_import[each.value.context].dn}/rsctxPToSubjP-${each.value.match_rule}"
  class_name = "rtctrlRsCtxPToSubjP"
  content = {
    tnRtctrlSubjPName = each.value.match_rule
  }
}

resource "aci_rest_managed" "rtctrlProfile" {
  for_each   = { for route_map in var.route_maps : route_map.name => route_map }
  dn         = "${aci_rest_managed.l3extOut.dn}/prof-${each.value.name}"
  class_name = "rtctrlProfile"
  content = {
    name  = each.value.name
    descr = each.value.description
    type  = each.value.type
  }
}

locals {
  route_map_contexts = flatten([
    for route_map in var.route_maps : [
      for context in route_map.contexts : {
        route_map_name = route_map.name
        name           = context.name
        description    = context.description
        action         = context.action
        order          = context.order
        set_rule       = context.set_rule
        match_rules    = context.match_rules
      }
    ]
  ])
}

resource "aci_rest_managed" "rtctrlCtxP" {
  for_each   = { for context in local.route_map_contexts : "${context.route_map_name}-${context.name}" => context }
  dn         = "${aci_rest_managed.rtctrlProfile[each.value.route_map_name].dn}/ctx-${each.value.name}"
  class_name = "rtctrlCtxP"
  content = {
    name   = each.value.name
    descr  = each.value.description
    action = each.value.action
    order  = each.value.order
  }
}
resource "aci_rest_managed" "rtctrlScope" {
  for_each   = { for context in local.route_map_contexts : "${context.route_map_name}-${context.name}" => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlCtxP["${each.value.route_map_name}-${each.value.name}"].dn}/scp"
  class_name = "rtctrlScope"
}

resource "aci_rest_managed" "rtctrlRsScopeToAttrP" {
  for_each   = { for context in local.route_map_contexts : "${context.route_map_name}-${context.name}" => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlScope["${each.value.route_map_name}-${each.value.name}"].dn}/rsScopeToAttrP"
  class_name = "rtctrlRsScopeToAttrP"
  content = {
    tnRtctrlAttrPName = each.value.set_rule
  }
}

locals {
  route_maps_match_rules = flatten([
    for route_map in var.route_maps : [
      for context in route_map.contexts : [
        for rule in context.match_rules : {
          id             = "${route_map.name}-${context.name}-${rule}"
          route_map_name = route_map.name
          context        = context.name
          match_rule     = rule
        }
      ]
    ]
  ])
}

resource "aci_rest_managed" "rtctrlRsCtxPToSubjP" {
  for_each   = { for match_rules in local.route_maps_match_rules : match_rules.id => match_rules }
  dn         = "${aci_rest_managed.rtctrlCtxP["${each.value.route_map_name}-${each.value.context}"].dn}/rsctxPToSubjP-${each.value.match_rule}"
  class_name = "rtctrlRsCtxPToSubjP"
  content = {
    tnRtctrlSubjPName = each.value.match_rule
  }
}

resource "aci_rest_managed" "rtctrlProfile_export" {
  count      = length(var.export_route_map_contexts) > 0 ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/prof-${var.export_route_map_name}"
  class_name = "rtctrlProfile"
  content = {
    name  = var.export_route_map_name
    descr = var.export_route_map_description
    type  = var.export_route_map_type
  }
}

resource "aci_rest_managed" "rtctrlCtxP_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context }
  dn         = "${aci_rest_managed.rtctrlProfile_export[0].dn}/ctx-${each.value.name}"
  class_name = "rtctrlCtxP"
  content = {
    name   = each.value.name
    descr  = each.value.description
    action = each.value.action
    order  = each.value.order
  }
}

resource "aci_rest_managed" "rtctrlScope_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlCtxP_export[each.value.name].dn}/scp"
  class_name = "rtctrlScope"
}

resource "aci_rest_managed" "rtctrlRsScopeToAttrP_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlScope_export[each.value.name].dn}/rsScopeToAttrP"
  class_name = "rtctrlRsScopeToAttrP"
  content = {
    tnRtctrlAttrPName = each.value.set_rule
  }
}

locals {
  export_match_rules = flatten([
    for context in try(var.export_route_map_contexts, []) : [
      for rule in try(context.match_rules, []) : {
        id         = "${context.name}-${rule}"
        context    = context.name
        match_rule = rule
      }
    ]
  ])
}

resource "aci_rest_managed" "rtctrlRsCtxPToSubjP_export" {
  for_each   = { for match_rules in local.export_match_rules : match_rules.id => match_rules }
  dn         = "${aci_rest_managed.rtctrlCtxP_export[each.value.context].dn}/rsctxPToSubjP-${each.value.match_rule}"
  class_name = "rtctrlRsCtxPToSubjP"
  content = {
    tnRtctrlSubjPName = each.value.match_rule
  }
}

resource "aci_rest_managed" "pimExtP" {
  count      = var.l3_multicast_ipv4 == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/pimextp"
  class_name = "pimExtP"
  content = {
    enabledAf = "ipv4-mcast"
    name      = "pim"
  }
}

resource "aci_rest_managed" "l3extRsInterleakPol" {
  count      = var.interleak_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/rsinterleakPol"
  class_name = "l3extRsInterleakPol"
  content = {
    tnRtctrlProfileName = var.interleak_route_map
  }
}

resource "aci_rest_managed" "l3extDefaultRouteLeakP" {
  count      = var.default_route_leak_policy == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/defrtleak"
  class_name = "l3extDefaultRouteLeakP"
  content = {
    always   = var.default_route_leak_policy_always == true ? "yes" : "no"
    criteria = var.default_route_leak_policy_criteria
    scope    = join(",", concat(var.default_route_leak_policy_context_scope == true ? ["ctx"] : [], var.default_route_leak_policy_outside_scope == true ? ["l3-out"] : []))
  }
}

resource "aci_rest_managed" "l3extRsDampeningPol_ipv4" {
  count      = var.dampening_ipv4_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/rsdampeningPol-[${var.dampening_ipv4_route_map}]-ipv4-ucast"
  class_name = "l3extRsDampeningPol"
  content = {
    af                  = "ipv4-ucast"
    tnRtctrlProfileName = var.dampening_ipv4_route_map
  }
}

resource "aci_rest_managed" "l3extRsDampeningPol_ipv6" {
  count      = var.dampening_ipv6_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/rsdampeningPol-[${var.dampening_ipv6_route_map}]-ipv6-ucast"
  class_name = "l3extRsDampeningPol"
  content = {
    af                  = "ipv6-ucast"
    tnRtctrlProfileName = var.dampening_ipv6_route_map
  }
}

resource "aci_rest_managed" "l3extRsRedistributePol" {
  for_each   = { for rm in var.redistribution_route_maps : "${rm.route_map}/${rm.source}" => rm }
  dn         = "${aci_rest_managed.l3extOut.dn}/rsredistributePol-[${each.value.route_map}]-${each.value.source}"
  class_name = "l3extRsRedistributePol"
  content = {
    src                 = each.value.source
    tnRtctrlProfileName = each.value.route_map
  }
}

resource "aci_rest_managed" "mplsExtP" {
  count      = var.tenant == "infra" && var.sr_mpls == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/mplsextp"
  class_name = "mplsExtP"
}


resource "aci_rest_managed" "mplsRsLabelPol" {
  count      = var.tenant == "infra" && var.sr_mpls == true ? 1 : 0
  dn         = "${aci_rest_managed.mplsExtP[0].dn}/rsLabelPol"
  class_name = "mplsRsLabelPol"
  content = {
    tDn = "uni/tn-infra/mplslabelpol-default"
  }
}

resource "aci_rest_managed" "l3extProvLbl" {
  count      = var.tenant == "infra" && var.sr_mpls == true ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/provlbl-${var.name}"
  class_name = "l3extProvLbl"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "l3extConsLbl" {
  for_each   = { for infra_l3out in var.sr_mpls_infra_l3outs : infra_l3out.name => infra_l3out }
  dn         = "${aci_rest_managed.l3extOut.dn}/conslbl-${each.value.name}"
  class_name = "l3extConsLbl"
  content = {
    name = each.value.name
  }
}

resource "aci_rest_managed" "l3extRsLblToProfile_import" {
  for_each   = { for infra_l3out in var.sr_mpls_infra_l3outs : infra_l3out.name => infra_l3out if infra_l3out.inbound_route_map != "" }
  dn         = "${aci_rest_managed.l3extConsLbl[each.value.name].dn}/rslblToProfile-[uni/tn-${var.tenant}/prof-${each.value.inbound_route_map}]-import"
  class_name = "l3extRsLblToProfile"
  content = {
    direction = "import"
    tDn       = "uni/tn-${var.tenant}/prof-${each.value.inbound_route_map}"
  }
}

resource "aci_rest_managed" "l3extRsLblToProfile_export" {
  for_each   = { for infra_l3out in var.sr_mpls_infra_l3outs : infra_l3out.name => infra_l3out if infra_l3out.outbound_route_map != "" }
  dn         = "${aci_rest_managed.l3extConsLbl[each.value.name].dn}/rslblToProfile-[uni/tn-${var.tenant}/prof-${each.value.outbound_route_map}]-export"
  class_name = "l3extRsLblToProfile"
  content = {
    direction = "export"
    tDn       = "uni/tn-${var.tenant}/prof-${each.value.outbound_route_map}"
  }
}

locals {
  infra_l3out_external_endpoint_groups = flatten([
    for infra_l3out in var.sr_mpls_infra_l3outs : [
      for eepg in try(infra_l3out.external_endpoint_groups, []) : {
        name    = infra_l3out.name
        ext_epg = eepg
      }
    ]
  ])
}

resource "aci_rest_managed" "l3extRsLblToInstP" {
  for_each   = { for eepg in local.infra_l3out_external_endpoint_groups : "${eepg.name}/${eepg.ext_epg}" => eepg }
  dn         = "${aci_rest_managed.l3extConsLbl[each.value.name].dn}/rslblToInstP-[uni/tn-${var.tenant}/out-${var.name}/instP-${each.value.ext_epg}]"
  class_name = "l3extRsLblToInstP"
  content = {
    tDn = "uni/tn-${var.tenant}/out-${var.name}/instP-${each.value.ext_epg}"
  }
}

resource "aci_rest_managed" "l3extInstP_sr_mpls" {
  count      = var.sr_mpls == true && var.tenant == "infra" ? 1 : 0
  dn         = "${aci_rest_managed.l3extOut.dn}/instP-${var.name}_mplsInstP"
  class_name = "l3extInstP"
  content = {
    name = "${var.name}_mplsInstP"
  }
}
