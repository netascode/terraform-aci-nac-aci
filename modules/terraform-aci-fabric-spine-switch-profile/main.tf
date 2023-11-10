locals {
  spine_interface_profiles = [for v in var.interface_profiles : "uni/fabric/spportp-${v}"]
  node_blocks = flatten([
    for selector in var.selectors : [
      for node_block in selector.node_blocks : {
        key = "${selector.name}/${node_block.name}"
        value = {
          selector_rn = "spines-${selector.name}-typ-range"
          name        = node_block.name
          from        = node_block.from
          to          = node_block.to != null ? node_block.to : node_block.from
        }
      }
    ]
  ])
}

resource "aci_rest_managed" "fabricSpineP" {
  dn         = "uni/fabric/spprof-${var.name}"
  class_name = "fabricSpineP"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricSpineS" {
  for_each   = { for selector in var.selectors : selector.name => selector }
  dn         = "${aci_rest_managed.fabricSpineP.dn}/spines-${each.value.name}-typ-range"
  class_name = "fabricSpineS"
  content = {
    name = each.value.name
    type = "range"
  }
}

resource "aci_rest_managed" "fabricRsSpNodePGrp" {
  for_each   = { for selector in var.selectors : selector.name => selector if selector.policy_group != null }
  dn         = "${aci_rest_managed.fabricSpineS[each.value.name].dn}/rsspNodePGrp"
  class_name = "fabricRsSpNodePGrp"
  content = {
    tDn = "uni/fabric/funcprof/spnodepgrp-${each.value.policy_group}"
  }
}

resource "aci_rest_managed" "fabricNodeBlk" {
  for_each   = { for item in local.node_blocks : item.key => item.value }
  dn         = "${aci_rest_managed.fabricSpineP.dn}/${each.value.selector_rn}/nodeblk-${each.value.name}"
  class_name = "fabricNodeBlk"
  content = {
    name  = each.value.name
    from_ = each.value.from
    to_   = each.value.to
  }
  depends_on = [
    aci_rest_managed.fabricSpineS
  ]
}

resource "aci_rest_managed" "fabricRsSpPortP" {
  for_each   = toset(local.spine_interface_profiles)
  dn         = "${aci_rest_managed.fabricSpineP.dn}/rsspPortP-[${each.value}]"
  class_name = "fabricRsSpPortP"
  content = {
    tDn = each.value
  }
}
