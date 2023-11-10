resource "aci_rest_managed" "infraSpineAccNodePGrp" {
  dn         = "uni/infra/funcprof/spaccnodepgrp-${var.name}"
  class_name = "infraSpineAccNodePGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraRsSpinePGrpToLldpIfPol" {
  dn         = "${aci_rest_managed.infraSpineAccNodePGrp.dn}/rsspinePGrpToLldpIfPol"
  class_name = "infraRsSpinePGrpToLldpIfPol"
  content = {
    tnLldpIfPolName = var.lldp_policy
  }
}
