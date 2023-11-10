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
      }
    ]
  ])
}

resource "aci_rest_managed" "spanVSrcGrp" {
  dn         = "uni/infra/vsrcgrp-${var.name}"
  class_name = "spanVSrcGrp"
  content = {
    name    = var.name
    descr   = var.description
    adminSt = var.admin_state == true ? "start" : "stop"
  }
}

resource "aci_rest_managed" "spanSpanLbl" {
  dn         = "${aci_rest_managed.spanVSrcGrp.dn}/spanlbl-${var.destination_name}"
  class_name = "spanSpanLbl"
  content = {
    descr = var.destination_description
    name  = var.destination_name
    tag   = "yellow-green"
  }
}

resource "aci_rest_managed" "spanVSrc" {
  for_each   = { for source in var.sources : source.name => source }
  dn         = "${aci_rest_managed.spanVSrcGrp.dn}/vsrc-${each.value.name}"
  class_name = "spanVSrc"
  content = {
    name  = each.value.name
    descr = each.value.description
    dir   = each.value.direction
  }
}

resource "aci_rest_managed" "spanRsSrcToEpg" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.application_profile != null && source.endpoint_group != null && source.endpoint == null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.name].dn}/rssrcToEpg"
  class_name = "spanRsSrcToEpg"
  content = {
    tDn = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}"
  }
}

resource "aci_rest_managed" "spanRsSrcToVPort" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.application_profile != null && source.endpoint_group != null && source.endpoint != null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.name].dn}/rssrcToVPort-[uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}/cep-${each.value.endpoint}]"
  class_name = "spanRsSrcToVPort"
  content = {
  tDn = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}/cep-${each.value.endpoint}" }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_port" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.port}" => sp if sp.channel == null && sp.fex_id == null && sp.sub_port == null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_subport" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.port}" => sp if sp.channel == null && sp.fex_id == null && sp.sub_port != null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port, each.value.sub_port)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_channel" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.channel}" => sp if sp.channel != null && sp.fex_id == null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.source].dn}/rssrcToPathEp-[${format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_fex_port" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.fex_id}-${sp.port}" => sp if sp.channel == null && sp.fex_id != null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.source].dn}/rssrcToPathEp-[${format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format("topology/pod-%s/paths-%s/extpaths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.fex_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "spanRsSrcToPathEp_fex_channel" {
  for_each   = { for sp in local.sources_access_paths : "${sp.source}-${sp.node_id}-${sp.fex_id}-${sp.channel}" => sp if sp.channel != null && sp.fex_id != null }
  dn         = "${aci_rest_managed.spanVSrc[each.value.source].dn}/rssrcToPathEp-[${format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)}]"
  class_name = "spanRsSrcToPathEp"
  content = {
    tDn = format(each.value.node2_id != null && each.value.fex2_id != null ? "topology/pod-%s/protpaths-%s-%s/extprotpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/extpaths-%[4]s/pathep-[%[6]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.fex_id, each.value.fex2_id, each.value.channel)
  }
}


