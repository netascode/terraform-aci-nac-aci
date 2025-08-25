locals {
  subnet_route_control_profiles = flatten([
    for subnet in var.subnets : [
      for rcp in try(subnet.route_control_profiles, []) : {
        id        = "${subnet.prefix}-${rcp.name}-${rcp.direction}"
        prefix    = subnet.prefix
        name      = rcp.name
        direction = rcp.direction
      }
    ]
  ])
}

resource "aci_rest_managed" "l3extInstP" {
  dn         = "uni/tn-${var.tenant}/out-${var.l3out}/instP-${var.name}"
  class_name = "l3extInstP"
  annotation = var.annotation
  content = {
    name       = var.name
    nameAlias  = var.alias
    descr      = var.description
    prefGrMemb = var.preferred_group == true ? "include" : "exclude"
    prio       = var.qos_class
    targetDscp = var.target_dscp
  }
}

resource "aci_rest_managed" "fvRsCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest_managed.l3extInstP.dn}/rscons-${each.value}"
  class_name = "fvRsCons"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest_managed.l3extInstP.dn}/rsprov-${each.value}"
  class_name = "fvRsProv"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsConsIf" {
  for_each   = toset(var.contract_imported_consumers)
  dn         = "${aci_rest_managed.l3extInstP.dn}/rsconsIf-${each.value}"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName = each.value
  }
}

resource "aci_rest_managed" "l3extRsInstPToProfile" {
  for_each   = { for rcp in var.route_control_profiles : rcp.name => rcp }
  dn         = "${aci_rest_managed.l3extInstP.dn}/rsinstPToProfile-[${each.value.name}]-${each.value.direction}"
  class_name = "l3extRsInstPToProfile"
  content = {
    tnRtctrlProfileName = each.value.name
    direction           = each.value.direction
  }
}

resource "aci_rest_managed" "l3extSubnet" {
  for_each   = { for subnet in var.subnets : subnet.prefix => subnet }
  dn         = "${aci_rest_managed.l3extInstP.dn}/extsubnet-[${each.value.prefix}]"
  class_name = "l3extSubnet"
  annotation = each.value.annotation
  content = {
    ip        = each.value.prefix
    name      = each.value.name
    descr     = each.value.description
    scope     = join(",", concat(each.value.export_route_control == true ? ["export-rtctrl"] : [], each.value.import_route_control == true ? ["import-rtctrl"] : [], each.value.import_security == true ? ["import-security"] : [], each.value.shared_route_control == true ? ["shared-rtctrl"] : [], each.value.shared_security == true ? ["shared-security"] : []))
    aggregate = join(",", concat(each.value.aggregate_export_route_control == true ? ["export-rtctrl"] : [], each.value.aggregate_import_route_control == true ? ["import-rtctrl"] : [], each.value.aggregate_shared_route_control == true ? ["shared-rtctrl"] : []))
  }
}

resource "aci_rest_managed" "l3extRsSubnetToProfile" {
  for_each   = { for rcp in local.subnet_route_control_profiles : rcp.id => rcp }
  dn         = "${aci_rest_managed.l3extSubnet[each.value.prefix].dn}/rssubnetToProfile-[${each.value.name}]-${each.value.direction}"
  class_name = "l3extRsSubnetToProfile"
  content = {
    tnRtctrlProfileName = each.value.name
    direction           = each.value.direction
  }
}

resource "aci_rest_managed" "l3extRsSubnetToRtSumm" {
  for_each   = { for subnet in var.subnets : subnet.prefix => subnet if subnet.bgp_route_summarization || subnet.ospf_route_summarization || subnet.eigrp_route_summarization }
  dn         = "${aci_rest_managed.l3extSubnet[each.value.prefix].dn}/rsSubnetToRtSumm"
  class_name = "l3extRsSubnetToRtSumm"
  content = {
    tDn = each.value.bgp_route_summarization ? (each.value.bgp_route_summarization_policy != "" ? "uni/tn-${var.tenant}/bgprtsum-${each.value.bgp_route_summarization_policy}" : "uni/tn-common/bgprtsum-default") : (each.value.ospf_route_summarization ? "uni/tn-common/ospfrtsumm-default" : (each.value.eigrp_route_summarization ? "uni/tn-${var.tenant}/eigrprtsumm-eigrp_pol" : null))
  }
}