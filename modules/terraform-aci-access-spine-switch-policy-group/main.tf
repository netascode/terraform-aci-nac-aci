resource "aci_rest_managed" "infraSpineAccNodePGrp" {
  dn         = "uni/infra/funcprof/spaccnodepgrp-${var.name}"
  class_name = "infraSpineAccNodePGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraRsSpinePGrpToLldpIfPol" {
  count      = var.lldp_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraSpineAccNodePGrp.dn}/rsspinePGrpToLldpIfPol"
  class_name = "infraRsSpinePGrpToLldpIfPol"
  content = {
    tnLldpIfPolName = var.lldp_policy
  }
}

resource "aci_rest_managed" "infraRsBfdIpv4InstPol" {
  count      = var.bfd_ipv4_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraSpineAccNodePGrp.dn}/rsspineBfdIpv4InstPol"
  class_name = "infraRsSpineBfdIpv4InstPol"
  content = {
    tnBfdIpv4InstPolName = var.bfd_ipv4_policy
  }
}

resource "aci_rest_managed" "infraRsBfdIpv6InstPol" {
  count      = var.bfd_ipv6_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraSpineAccNodePGrp.dn}/rsspineBfdIpv6InstPol"
  class_name = "infraRsSpineBfdIpv6InstPol"
  content = {
    tnBfdIpv6InstPolName = var.bfd_ipv6_policy
  }
}
