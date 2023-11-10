resource "aci_rest_managed" "infraAccNodePGrp" {
  dn         = "uni/infra/funcprof/accnodepgrp-${var.name}"
  class_name = "infraAccNodePGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraRsTopoctrlFwdScaleProfPol" {
  dn         = "${aci_rest_managed.infraAccNodePGrp.dn}/rstopoctrlFwdScaleProfPol"
  class_name = "infraRsTopoctrlFwdScaleProfPol"
  content = {
    tnTopoctrlFwdScaleProfilePolName = var.forwarding_scale_policy
  }
}
