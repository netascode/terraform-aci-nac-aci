resource "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/tn-${var.tenant}/srcgrp-${var.name}"
  class_name = "spanSrcGrp"
  content = {
    name    = var.name
    descr   = var.description
    adminSt = var.admin_state == true ? "enabled" : "disabled"
  }
}

resource "aci_rest_managed" "spanSpanLbl" {
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/spanlbl-${var.destination}"
  class_name = "spanSpanLbl"
  content = {
    name = var.destination
  }
}

resource "aci_rest_managed" "spanSrc" {
  for_each   = { for source in var.sources : source.name => source }
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/src-${each.value.name}"
  class_name = "spanSrc"
  content = {
    name  = each.value.name
    descr = each.value.description
    dir   = each.value.direction
  }
}

resource "aci_rest_managed" "spanRsSrcToEpg" {
  for_each   = { for source in var.sources : source.name => source if source.application_profile != null && source.endpoint_group != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToEpg"
  class_name = "spanRsSrcToEpg"
  content = {
    tDn = "uni/tn-${var.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}"
  }
}
