resource "aci_rest_managed" "fabricLePortPGrp" {
  dn         = "uni/fabric/funcprof/leportgrp-${var.name}"
  class_name = "fabricLePortPGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricRsFIfPol" {
  dn         = "${aci_rest_managed.fabricLePortPGrp.dn}/rsfIfPol"
  class_name = "fabricRsFIfPol"
  content = {
    tnFabricFIfPolName = var.link_level_policy
  }
}

