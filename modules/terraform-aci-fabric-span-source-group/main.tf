locals {
  sources_fabric_paths = flatten([
    for source in var.sources : [
      for path in source.fabric_paths : {
        source  = source.name
        pod_id  = path.pod_id
        node_id = path.node_id
        module  = path.module
        port    = path.port
      }
    ]
  ])
}

resource "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/fabric/srcgrp-${var.name}"
  class_name = "spanSrcGrp"
  content = {
    name    = var.name
    descr   = var.description
    adminSt = var.admin_state ? "enabled" : "disabled"
  }
}

resource "aci_rest_managed" "spanSpanLbl" {
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/spanlbl-${var.destination_name}"
  class_name = "spanSpanLbl"
  content = {
    descr = var.destination_description
    name  = var.destination_name
    tag   = "yellow-green"
  }
}

resource "aci_rest_managed" "spanSrc" {
  for_each   = { for source in var.sources : source.name => source }
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/src-${each.value.name}"
  class_name = "spanSrc"
  content = {
    name       = each.value.name
    descr      = each.value.description
    dir        = each.value.direction
    spanOnDrop = each.value.span_drop == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_port" {
  for_each   = { for sp in local.sources_fabric_paths : "${sp.source}-${sp.node_id}-${sp.port}" => sp }
  dn         = "${aci_rest_managed.spanSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "spanRsSrcToCtx" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.vrf != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToCtx"
  class_name = "spanRsSrcToCtx"
  content = {
    tDn = "uni/tn-${each.value.tenant}/ctx-${each.value.vrf}"
  }
}

resource "aci_rest_managed" "spanRsSrcToBD" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.bridge_domain != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToBD"
  class_name = "spanRsSrcToBD"
  content = {
    tDn = "uni/tn-${each.value.tenant}/BD-${each.value.bridge_domain}"
  }
}

