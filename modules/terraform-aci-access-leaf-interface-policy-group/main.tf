resource "aci_rest_managed" "infraAccGrp" {
  dn         = var.type == "access" ? "uni/infra/funcprof/accportgrp-${var.name}" : var.type == "breakout" ? "uni/infra/funcprof/brkoutportgrp-${var.name}" : "uni/infra/funcprof/accbundle-${var.name}"
  class_name = var.type == "access" ? "infraAccPortGrp" : var.type == "breakout" ? "infraBrkoutPortGrp" : "infraAccBndlGrp"
  content = {
    name      = var.name
    descr     = var.description
    lagT      = var.type == "vpc" ? "node" : var.type == "pc" ? "link" : null
    brkoutMap = var.type == "breakout" ? var.map : null
  }
}

resource "aci_rest_managed" "infraRsHIfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rshIfPol"
  class_name = "infraRsHIfPol"
  content = {
    tnFabricHIfPolName = var.link_level_policy
  }
}

resource "aci_rest_managed" "infraRsCdpIfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rscdpIfPol"
  class_name = "infraRsCdpIfPol"
  content = {
    tnCdpIfPolName = var.cdp_policy
  }
}

resource "aci_rest_managed" "infraRsLldpIfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rslldpIfPol"
  class_name = "infraRsLldpIfPol"
  content = {
    tnLldpIfPolName = var.lldp_policy
  }
}

resource "aci_rest_managed" "infraRsStpIfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsstpIfPol"
  class_name = "infraRsStpIfPol"
  content = {
    tnStpIfPolName = var.spanning_tree_policy
  }
}

resource "aci_rest_managed" "infraRsMcpIfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsmcpIfPol"
  class_name = "infraRsMcpIfPol"
  content = {
    tnMcpIfPolName = var.mcp_policy
  }
}

resource "aci_rest_managed" "infraRsL2IfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsl2IfPol"
  class_name = "infraRsL2IfPol"
  content = {
    tnL2IfPolName = var.l2_policy
  }
}

resource "aci_rest_managed" "infraRsStormctrlIfPol" {
  count      = var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsstormctrlIfPol"
  class_name = "infraRsStormctrlIfPol"
  content = {
    tnStormctrlIfPolName = var.storm_control_policy
  }
}

resource "aci_rest_managed" "infraRsLacpPol" {
  count      = (var.type == "vpc" || var.type == "pc") ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rslacpPol"
  class_name = "infraRsLacpPol"
  content = {
    tnLacpLagPolName = var.port_channel_policy
  }
}

resource "aci_rest_managed" "infraAccBndlSubgrp" {
  count      = (var.type == "vpc" || var.type == "pc") && var.port_channel_member_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/accsubbndl-${var.name}"
  class_name = "infraAccBndlSubgrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraRsLacpInterfacePol" {
  count      = (var.type == "vpc" || var.type == "pc") && var.port_channel_member_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccBndlSubgrp[0].dn}/rslacpInterfacePol"
  class_name = "infraRsLacpInterfacePol"
  content = {
    tnLacpIfPolName = var.port_channel_member_policy
  }
}

resource "aci_rest_managed" "infraRsAttEntP" {
  count      = var.aaep != "" && var.type != "breakout" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsattEntP"
  class_name = "infraRsAttEntP"
  content = {
    tDn = "uni/infra/attentp-${var.aaep}"
  }
}
