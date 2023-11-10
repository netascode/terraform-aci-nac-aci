resource "aci_rest_managed" "spanDestGrp" {
  dn         = "uni/tn-${var.tenant}/destgrp-${var.name}"
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
    name = var.name
  }
}

resource "aci_rest_managed" "spanRsDestEpg" {
  dn         = "${aci_rest_managed.spanDest.dn}/rsdestEpg"
  class_name = "spanRsDestEpg"
  content = {
    dscp        = var.dscp
    flowId      = var.flow_id
    ip          = var.ip
    mtu         = var.mtu
    srcIpPrefix = var.source_prefix
    ttl         = var.ttl
    ver         = "ver${var.span_version}"
    verEnforced = var.enforce_version == true ? "yes" : "no"
    tDn         = "uni/tn-${coalesce(var.destination_tenant, var.tenant)}/ap-${var.destination_application_profile}/epg-${var.destination_endpoint_group}"
  }
}
