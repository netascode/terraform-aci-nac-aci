resource "aci_rest_managed" "infraAccNodePGrp" {
  dn         = "uni/infra/funcprof/accnodepgrp-${var.name}"
  class_name = "infraAccNodePGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraRsTopoctrlFwdScaleProfPol" {
  count      = var.forwarding_scale_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccNodePGrp.dn}/rstopoctrlFwdScaleProfPol"
  class_name = "infraRsTopoctrlFwdScaleProfPol"
  content = {
    tnTopoctrlFwdScaleProfilePolName = var.forwarding_scale_policy
  }
}

resource "aci_rest_managed" "infraRsBfdIpv4InstPol" {
  count      = var.bfd_ipv4_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccNodePGrp.dn}/rsbfdIpv4InstPol"
  class_name = "infraRsBfdIpv4InstPol"
  content = {
    tnBfdIpv4InstPolName = var.bfd_ipv4_policy
  }
}

resource "aci_rest_managed" "infraRsBfdIpv6InstPol" {
  count      = var.bfd_ipv6_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccNodePGrp.dn}/rsbfdIpv6InstPol"
  class_name = "infraRsBfdIpv6InstPol"
  content = {
    tnBfdIpv6InstPolName = var.bfd_ipv6_policy
  }
}
