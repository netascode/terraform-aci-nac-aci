resource "aci_rest_managed" "spanDestGrp" {
  dn         = "uni/fabric/destgrp-${var.name}"
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

resource "aci_rest_managed" "spanRsDestEpg" {
  count      = var.tenant != "" && var.application_profile != "" && var.endpoint_group != "" ? 1 : 0
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
