locals {
  pod_blocks = flatten([
    for selector in var.selectors : [
      for pod_block in selector.pod_blocks : {
        key = "${selector.name}/${pod_block.name}"
        value = {
          selector_name = selector.name
          name          = pod_block.name
          from          = pod_block.from
          to            = pod_block.to != null ? pod_block.to : pod_block.from
        }
      }
    ]
  ])
}

resource "aci_rest_managed" "fabricPodP" {
  dn         = "uni/fabric/podprof-${var.name}"
  class_name = "fabricPodP"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricPodS" {
  for_each   = { for selector in var.selectors : selector.name => selector }
  dn         = "${aci_rest_managed.fabricPodP.dn}/pods-${each.value.name}-typ-${each.value.type == "all" ? "ALL" : each.value.type}"
  class_name = "fabricPodS"
  content = {
    name = each.value.name
    type = each.value.type == "all" ? "ALL" : each.value.type
  }
}

resource "aci_rest_managed" "fabricRsPodPGrp" {
  for_each   = { for selector in var.selectors : selector.name => selector if selector.policy_group != null }
  dn         = "${aci_rest_managed.fabricPodS[each.value.name].dn}/rspodPGrp"
  class_name = "fabricRsPodPGrp"
  content = {
    tDn = "uni/fabric/funcprof/podpgrp-${each.value.policy_group}"
  }
}

resource "aci_rest_managed" "fabricPodBlk" {
  for_each   = { for item in local.pod_blocks : item.key => item.value }
  dn         = "${aci_rest_managed.fabricPodS[each.value.selector_name].dn}/podblk-${each.value.name}"
  class_name = "fabricPodBlk"
  content = {
    name  = each.value.name
    from_ = each.value.from
    to_   = each.value.to
  }
}
