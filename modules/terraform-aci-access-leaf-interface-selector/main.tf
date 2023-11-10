resource "aci_rest_managed" "infraHPortS" {
  dn         = "uni/infra/accportprof-${var.interface_profile}/hports-${var.name}-typ-range"
  class_name = "infraHPortS"
  content = {
    name = var.name
    type = "range"
  }
}

resource "aci_rest_managed" "infraRsAccBaseGrp" {
  count      = var.policy_group != "" || var.fex_id != 0 ? 1 : 0
  dn         = "${aci_rest_managed.infraHPortS.dn}/rsaccBaseGrp"
  class_name = "infraRsAccBaseGrp"
  content = {
    fexId = var.fex_id != 0 ? var.fex_id : null
    tDn   = var.fex_id != 0 ? "uni/infra/fexprof-${var.fex_interface_profile}/fexbundle-${var.fex_interface_profile}" : (var.policy_group_type == "access" ? "uni/infra/funcprof/accportgrp-${var.policy_group}" : var.policy_group_type == "breakout" ? "uni/infra/funcprof/brkoutportgrp-${var.policy_group}" : "uni/infra/funcprof/accbundle-${var.policy_group}")
  }
}

resource "aci_rest_managed" "infraPortBlk" {
  for_each   = { for block in var.port_blocks : block.name => block }
  dn         = "${aci_rest_managed.infraHPortS.dn}/portblk-${each.value.name}"
  class_name = "infraPortBlk"
  content = {
    name     = each.value.name
    descr    = each.value.description
    fromCard = each.value.from_module
    fromPort = each.value.from_port
    toCard   = each.value.to_module != null ? each.value.to_module : each.value.from_module
    toPort   = each.value.to_port != null ? each.value.to_port : each.value.from_port
  }
}

resource "aci_rest_managed" "infraSubPortBlk" {
  for_each   = { for block in var.sub_port_blocks : block.name => block }
  dn         = "${aci_rest_managed.infraHPortS.dn}/subportblk-${each.value.name}"
  class_name = "infraSubPortBlk"
  content = {
    name        = each.value.name
    descr       = each.value.description
    fromCard    = each.value.from_module
    fromPort    = each.value.from_port
    toCard      = each.value.to_module != null ? each.value.to_module : each.value.from_module
    toPort      = each.value.to_port != null ? each.value.to_port : each.value.from_port
    fromSubPort = each.value.from_sub_port
    toSubPort   = each.value.to_sub_port != null ? each.value.to_sub_port : each.value.from_sub_port
  }
}
