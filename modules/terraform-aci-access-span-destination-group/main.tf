resource "aci_rest_managed" "spanDestGrp" {
  dn         = "uni/infra/destgrp-${var.name}"
  class_name = "spanDestGrp"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "spanDest" {
  dn         = "${aci_rest_managed.spanDestGrp.dn}/dest-${var.name}"
  class_name = "spanDest"
  content = {
    name  = var.name
    descr = ""
  }
}

resource "aci_rest_managed" "spanRsDestPathEp_port" {
  count      = var.node_id != 0 && var.channel == "" && var.sub_port == 0 && var.port != 0 && var.tenant == "" ? 1 : 0
  dn         = "${aci_rest_managed.spanDest.dn}/rsdestPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", var.pod_id, var.node_id, var.module, var.port)}]"
  class_name = "spanRsDestPathEp"
  content = {
    mtu = var.mtu
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s]", var.pod_id, var.node_id, var.module, var.port)
  }
}

resource "aci_rest_managed" "spanRsDestPathEp_subport" {
  count      = var.node_id != 0 && var.channel == "" && var.sub_port != 0 && var.port != 0 && var.tenant == "" ? 1 : 0
  dn         = "${aci_rest_managed.spanDest.dn}/rsdestPathEp-[${format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", var.pod_id, var.node_id, var.module, var.port, var.sub_port)}]"
  class_name = "spanRsDestPathEp"
  content = {
    mtu = var.mtu
    tDn = format("topology/pod-%s/paths-%s/pathep-[eth%s/%s/%s]", var.pod_id, var.node_id, var.module, var.port, var.sub_port)
  }
}

resource "aci_rest_managed" "spanRsDestPathEp_channel" {
  count      = var.node_id != 0 && var.channel != "" && var.sub_port == 0 && var.port == 0 && var.tenant == "" ? 1 : 0
  dn         = "${aci_rest_managed.spanDest.dn}/rsdestPathEp-[${format("topology/pod-%s/paths-%s/pathep-[%s]", var.pod_id, var.node_id, var.channel)}]"
  class_name = "spanRsDestPathEp"
  content = {
    mtu = var.mtu
    tDn = format("topology/pod-%s/paths-%s/pathep-[%s]", var.pod_id, var.node_id, var.channel)
  }
}

resource "aci_rest_managed" "spanRsDestEpg" {
  count      = var.tenant != "" && var.application_profile != "" && var.endpoint_group != "" && var.ip != "" && var.source_prefix != "" && var.channel == "" && var.node_id == 0 ? 1 : 0
  dn         = "${aci_rest_managed.spanDest.dn}/rsdestEpg"
  class_name = "spanRsDestEpg"
  content = {
    ip          = var.ip
    srcIpPrefix = var.source_prefix
    dscp        = var.dscp
    flowId      = var.flow_id
    mtu         = var.mtu
    ttl         = var.ttl
    ver         = "ver${var.span_version}"
    verEnforced = var.enforce_version == true ? "yes" : "no"
    tDn         = "uni/tn-${var.tenant}/ap-${var.application_profile}/epg-${var.endpoint_group}"
  }
}
