resource "aci_rest_managed" "fabricSpNodePGrp" {
  dn         = "uni/fabric/funcprof/spnodepgrp-${var.name}"
  class_name = "fabricSpNodePGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "fabricRsPsuInstPol" {
  dn         = "${aci_rest_managed.fabricSpNodePGrp.dn}/rspsuInstPol"
  class_name = "fabricRsPsuInstPol"
  content = {
    tnPsuInstPolName = var.psu_policy
  }
}

resource "aci_rest_managed" "fabricRsNodeCtrl" {
  dn         = "${aci_rest_managed.fabricSpNodePGrp.dn}/rsnodeCtrl"
  class_name = "fabricRsNodeCtrl"
  content = {
    tnFabricNodeControlName = var.node_control_policy
  }
}
