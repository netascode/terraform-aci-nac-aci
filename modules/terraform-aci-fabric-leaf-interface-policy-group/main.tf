resource "aci_rest_managed" "fabricLePortPGrp" {
  dn         = "uni/fabric/funcprof/leportgrp-${var.name}"
  class_name = "fabricLePortPGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricRsFIfPol" {
  dn         = "${aci_rest_managed.fabricLePortPGrp.dn}/rsfIfPolol"
  class_name = "fabricRsFIfPol"
  content = {
    tnPsuInstPolName = var.link_level_policy
  }
}

resource "aci_rest_managed" "fabricRsMonIfFabricPol" {
  dn         = "${aci_rest_managed.fabricLePortPGrp.dn}/rsmonIfFabricPol"
  class_name = "fabricRsMonIfFabricPol"
  content = {
    tnFabricNodeControlName = var.monitoring_policy
  }
}
