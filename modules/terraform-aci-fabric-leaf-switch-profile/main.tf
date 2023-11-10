locals {
  leaf_interface_profiles = [for v in var.interface_profiles : "uni/fabric/leportp-${v}"]
  node_blocks = flatten([
    for selector in var.selectors : [
      for node_block in selector.node_blocks : {
        key = "${selector.name}/${node_block.name}"
        value = {
          selector = selector.name
          name     = node_block.name
          from     = node_block.from
          to       = node_block.to != null ? node_block.to : node_block.from
        }
      }
    ]
  ])
}

resource "aci_rest_managed" "fabricLeafP" {
  dn         = "uni/fabric/leprof-${var.name}"
  class_name = "fabricLeafP"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricLeafS" {
  for_each   = { for selector in var.selectors : selector.name => selector }
  dn         = "${aci_rest_managed.fabricLeafP.dn}/leaves-${each.value.name}-typ-range"
  class_name = "fabricLeafS"
  content = {
    name = each.value.name
    type = "range"
  }
}

resource "aci_rest_managed" "fabricRsLeNodePGrp" {
  for_each   = { for selector in var.selectors : selector.name => selector if selector.policy_group != null }
  dn         = "${aci_rest_managed.fabricLeafS[each.value.name].dn}/rsleNodePGrp"
  class_name = "fabricRsLeNodePGrp"
  content = {
    tDn = "uni/fabric/funcprof/lenodepgrp-${each.value.policy_group}"
  }
}

resource "aci_rest_managed" "fabricNodeBlk" {
  for_each   = { for item in local.node_blocks : item.key => item.value }
  dn         = "${aci_rest_managed.fabricLeafS[each.value.selector].dn}/nodeblk-${each.value.name}"
  class_name = "fabricNodeBlk"
  content = {
    name  = each.value.name
    from_ = each.value.from
    to_   = each.value.to
  }
}

resource "aci_rest_managed" "fabricRsLePortP" {
  for_each   = toset(local.leaf_interface_profiles)
  dn         = "${aci_rest_managed.fabricLeafP.dn}/rslePortP-[${each.value}]"
  class_name = "fabricRsLePortP"
  content = {
    tDn = each.value
  }
}
