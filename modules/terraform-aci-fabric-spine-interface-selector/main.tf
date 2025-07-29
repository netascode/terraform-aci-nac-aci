resource "aci_rest_managed" "fabricSFPortS" {
  dn         = "uni/fabric/spportp-${var.interface_profile}/spfabports-${var.name}-typ-range"
  class_name = "fabricSFPortS"
  content = {
    name  = var.name
    descr = var.description
    type  = "range"
  }
}

resource "aci_rest_managed" "fabricRsSpPortPGrp" {
  count      = var.policy_group != "" ? 1 : 0
  dn         = "${aci_rest_managed.fabricSFPortS.dn}/rsspPortPGrp"
  class_name = "fabricRsSpPortPGrp"
  content = {
    tDn = "uni/fabric/funcprof/spportgrp-${var.policy_group}"
  }
}

resource "aci_rest_managed" "fabricPortBlk" {
  for_each   = { for block in var.port_blocks : block.name => block }
  dn         = "${aci_rest_managed.fabricSFPortS.dn}/portblk-${each.value.name}"
  class_name = "fabricPortBlk"
  content = {
    name     = each.value.name
    descr    = each.value.description
    fromCard = each.value.from_module
    fromPort = each.value.from_port
    toCard   = each.value.to_module != null ? each.value.to_module : each.value.from_module
    toPort   = each.value.to_port != null ? each.value.to_port : each.value.from_port
  }
}

resource "aci_rest_managed" "fabricSubPortBlk" {
  for_each   = { for block in var.sub_port_blocks : block.name => block }
  dn         = "${aci_rest_managed.fabricSFPortS.dn}/subportblk-${each.value.name}"
  class_name = "fabricSubPortBlk"
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
