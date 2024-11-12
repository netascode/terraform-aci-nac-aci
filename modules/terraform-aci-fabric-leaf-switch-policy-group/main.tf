resource "aci_rest_managed" "fabricLeNodePGrp" {
  dn         = "uni/fabric/funcprof/lenodepgrp-${var.name}"
  class_name = "fabricLeNodePGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricRsPsuInstPol" {
  dn         = "${aci_rest_managed.fabricLeNodePGrp.dn}/rspsuInstPol"
  class_name = "fabricRsPsuInstPol"
  content = {
    tnPsuInstPolName = var.psu_policy
  }
}

resource "aci_rest_managed" "fabricRsNodeCtrl" {
  dn         = "${aci_rest_managed.fabricLeNodePGrp.dn}/rsnodeCtrl"
  class_name = "fabricRsNodeCtrl"
  content = {
    tnFabricNodeControlName = var.node_control_policy
  }
}

resource "aci_rest_managed" "fabricRsMonInstFabricPol" {
  count      = var.monitoring_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fabricLeNodePGrp.dn}/rsmonInstFabricPol"
  class_name = "fabricRsMonInstFabricPol"
  content = {
    tnMonFabricPolName = var.monitoring_policy
  }
}
