resource "aci_rest_managed" "fabricSpPortPGrp" {
  dn         = "uni/fabric/funcprof/spportgrp-${var.name}"
  class_name = "fabricSpPortPGrp"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "fabricRsFIfPol" {
  count      = var.link_level_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fabricSpPortPGrp.dn}/rsfIfPol"
  class_name = "fabricRsFIfPol"
  content = {
    tnFabricFIfPolName = var.link_level_policy
  }
}

resource "aci_rest_managed" "fabricRsMacsecFabIfPol" {
  count      = var.macsec_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fabricSpPortPGrp.dn}/rsmacsecFabIfPol"
  class_name = "fabricRsMacsecFabIfPol"
  content = {
    tnMacsecFabIfPolName = var.macsec_policy
  }
}
