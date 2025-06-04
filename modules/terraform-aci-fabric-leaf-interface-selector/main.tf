resource "aci_rest_managed" "fabricLFPortS" {
  dn         = "uni/fabric/leportp-${var.interface_profile}/lefabports-${var.name}-typ-range"
  class_name = "fabricLFPortS"
  content = {
    name  = var.name
    descr = var.description
    type  = "range"
  }
}

resource "aci_rest_managed" "fabricRsLePortPGrp" {
  count      = var.policy_group != "" ? 1 : 0
  dn         = "${aci_rest_managed.fabricLFPortS.dn}/rslePortPGrp"
  class_name = "fabricRsLePortPGrp"
  content = {
    tDn = "uni/fabric/funcprof/leportgrp-${var.policy_group}"
  }
}

resource "aci_rest_managed" "fabricPortBlk" {
  for_each   = { for block in var.port_blocks : block.name => block }
  dn         = "${aci_rest_managed.fabricLFPortS.dn}/portblk-${each.value.name}"
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
  dn         = "${aci_rest_managed.fabricLFPortS.dn}/subportblk-${each.value.name}"
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
