resource "aci_rest_managed" "infraSpAccPortGrp" {
  dn         = "uni/infra/funcprof/spaccportgrp-${var.name}"
  class_name = "infraSpAccPortGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraRsHIfPol" {
  dn         = "${aci_rest_managed.infraSpAccPortGrp.dn}/rshIfPol"
  class_name = "infraRsHIfPol"
  content = {
    tnFabricHIfPolName = var.link_level_policy
  }
}

resource "aci_rest_managed" "infraRsCdpIfPol" {
  dn         = "${aci_rest_managed.infraSpAccPortGrp.dn}/rscdpIfPol"
  class_name = "infraRsCdpIfPol"
  content = {
    tnCdpIfPolName = var.cdp_policy
  }
}

resource "aci_rest_managed" "infraRsAttEntP" {
  count      = var.aaep != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraSpAccPortGrp.dn}/rsattEntP"
  class_name = "infraRsAttEntP"
  content = {
    tDn = "uni/infra/attentp-${var.aaep}"
  }
}
