resource "aci_rest_managed" "spanVDestGrp" {
  dn         = "uni/infra/vdestgrp-${var.name}"
  class_name = "spanVDestGrp"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "spanVDest" {
  for_each   = { for destination in var.destinations : destination.name => destination }
  dn         = "${aci_rest_managed.spanVDestGrp.dn}/vdest-${each.value.name}"
  class_name = "spanVDest"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
}

resource "aci_rest_managed" "spanRsDestToVPort" {
  for_each   = { for destination in var.destinations : destination.name => destination if destination.tenant != null && destination.application_profile != null && destination.endpoint_group != null && destination.endpoint != null }
  dn         = "${aci_rest_managed.spanVDest[each.value.name].dn}/rsdestToVPort-[${format("uni/tn-%s/ap-%s/epg-%s/cep-%s", each.value.tenant, each.value.application_profile, each.value.endpoint_group, each.value.endpoint)}]"
  class_name = "spanRsDestToVPort"
  content = {
    tDn = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}/cep-${each.value.endpoint}"
  }
}

resource "aci_rest_managed" "spanVEpgSummary" {
  for_each   = { for destination in var.destinations : destination.name => destination if destination.ip != null }
  dn         = "${aci_rest_managed.spanVDest[each.value.name].dn}/vepgsummary"
  class_name = "spanVEpgSummary"
  content = {
    dstIp       = each.value.ip
    dscp        = each.value.dscp
    flowId      = each.value.flow_id
    mtu         = each.value.mtu
    srcIpPrefix = "0.0.0.0"
    ttl         = each.value.ttl
  }
}
