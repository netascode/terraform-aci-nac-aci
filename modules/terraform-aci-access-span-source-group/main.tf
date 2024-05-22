locals {
  sources_access_paths = flatten([
    for source in var.sources : [
      for path in source.access_paths : {
        source   = source.name
        pod_id   = path.pod_id
        node_id  = path.node_id
        node2_id = path.node2_id
        module   = path.module
        port     = path.port
        channel  = path.channel
        fex_id   = path.fex_id
        fex2_id  = path.fex2_id
        sub_port = path.sub_port
        type     = path.type
      }
    ]
  ])
}

resource "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/infra/srcgrp-${var.name}"
  class_name = "spanSrcGrp"
  content = {
    adminSt = var.admin_state == true ? "enabled" : "disabled"
    descr   = var.description
    name    = var.name
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

resource "aci_rest_managed" "spanRsSrcToEpg" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.application_profile != null && source.endpoint_group != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToEpg"
  class_name = "spanRsSrcToEpg"
  content = {
    tDn = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}"
  }
}

resource "aci_rest_managed" "spanRsSrcToL3extOut" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.l3out != null && source.vlan != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToL3extOut"
  class_name = "spanRsSrcToL3extOut"
  content = {
    addr  = "0.0.0.0"
    encap = "vlan-${each.value.vlan}"
    tDn   = "uni/tn-${each.value.tenant}/out-${each.value.l3out}"
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_port" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.port}" => sp if sp.channel == null && sp.fex_id == null && sp.sub_port == null }
  dn         = "${aci_rest_managed.spanSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_subport" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.port}" => sp if sp.channel == null && sp.fex_id == null && sp.sub_port != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_channel" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.channel}" => sp if sp.channel != null && sp.fex_id == null }
  dn         = "${aci_rest_managed.spanSrc[each.value.source].dn}/rssrcToPathEp-[${format(each.value.node2_id != null && each.value.type != "component" ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format(each.value.node2_id != null && each.value.type != "component" ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_fex_port" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.fex_id}-${sp.port}" => sp if sp.channel == null && sp.fex_id != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_fex_channel" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.fex_id}-${sp.channel}" => sp if sp.channel != null && sp.fex_id != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.source].dn}/rssrcToPathEp-[${format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)
  }
}

resource "aci_rest_managed" "spanRsSrcGrpToFilterGrp" {
  count      = var.filter_group != "" ? 1 : 0
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/rssrcGrpToFilterGrp"
  class_name = "spanRsSrcGrpToFilterGrp"
  content = {
    tDn = "uni/infra/filtergrp-${var.filter_group}"
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
