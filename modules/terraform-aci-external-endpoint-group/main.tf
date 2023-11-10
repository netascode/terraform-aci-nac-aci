resource "aci_rest_managed" "l3extInstP" {
  dn         = "uni/tn-${var.tenant}/out-${var.l3out}/instP-${var.name}"
  class_name = "l3extInstP"
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

resource "aci_rest_managed" "l3extSubnet" {
  for_each   = { for subnet in var.subnets : subnet.prefix => subnet }
  dn         = "${aci_rest_managed.l3extInstP.dn}/extsubnet-[${each.value.prefix}]"
  class_name = "l3extSubnet"
  content = {
    ip        = each.value.prefix
    name      = each.value.name
    scope     = join(",", concat(each.value.export_route_control == true ? ["export-rtctrl"] : [], each.value.import_route_control == true ? ["import-rtctrl"] : [], each.value.import_security == true ? ["import-security"] : [], each.value.shared_route_control == true ? ["shared-rtctrl"] : [], each.value.shared_security == true ? ["shared-security"] : []))
    aggregate = join(",", concat(each.value.aggregate_export_route_control == true ? ["export-rtctrl"] : [], each.value.aggregate_import_route_control == true ? ["import-rtctrl"] : [], each.value.aggregate_shared_route_control == true ? ["shared-rtctrl"] : []))
  }
}

resource "aci_rest_managed" "l3extRsSubnetToRtSumm" {
  for_each   = { for subnet in var.subnets : subnet.prefix => subnet if subnet.bgp_route_summarization == true }
  dn         = "${aci_rest_managed.l3extSubnet[each.value.prefix].dn}/rsSubnetToRtSumm"
  class_name = "l3extRsSubnetToRtSumm"
  content = {
    tDn = "uni/tn-common/bgprtsum-default"
  }
}

resource "aci_rest_managed" "l3extRsLblToInstP" {
  count      = var.sr_mpls_infra_l3out != "" ? 1 : 0
  dn         = "uni/tn-${var.tenant}/out-${var.l3out}/conslbl-${var.sr_mpls_infra_l3out}/rslblToInstP-[uni/tn-${var.tenant}/out-${var.l3out}/instP-${var.name}]"
  class_name = "l3extRsLblToInstP"
  content = {
    tDn = "uni/tn-${var.tenant}/out-${var.l3out}/instP-${var.name}"
  }
}
