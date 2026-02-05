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
  count      = var.type != "breakout" && var.link_level_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rshIfPol"
  class_name = "infraRsHIfPol"
  content = {
    tnFabricHIfPolName = var.link_level_policy
  }
}

resource "aci_rest_managed" "infraRsCdpIfPol" {
  count      = var.type != "breakout" && var.cdp_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rscdpIfPol"
  class_name = "infraRsCdpIfPol"
  content = {
    tnCdpIfPolName = var.cdp_policy
  }
}

resource "aci_rest_managed" "infraRsLldpIfPol" {
  count      = var.type != "breakout" && var.lldp_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rslldpIfPol"
  class_name = "infraRsLldpIfPol"
  content = {
    tnLldpIfPolName = var.lldp_policy
  }
}

resource "aci_rest_managed" "infraRsQosEgressDppIfPol" {
  count      = var.type != "breakout" && var.egress_data_plane_policing_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsQosEgressDppIfPol"
  class_name = "infraRsQosEgressDppIfPol"
  content = {
    tnQosDppPolName = var.egress_data_plane_policing_policy
  }
}

resource "aci_rest_managed" "infraRsQosIngressDppIfPol" {
  count      = var.type != "breakout" && var.ingress_data_plane_policing_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsQosIngressDppIfPol"
  class_name = "infraRsQosIngressDppIfPol"
  content = {
    tnQosDppPolName = var.ingress_data_plane_policing_policy
  }
}

resource "aci_rest_managed" "infraRsMacsecIfPol" {
  count      = var.macsec_interface_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsmacsecIfPol"
  class_name = "infraRsMacsecIfPol"
  content = {
    tnMacsecIfPolName = var.macsec_interface_policy
  }
}

resource "aci_rest_managed" "infraRsStpIfPol" {
  count      = var.type != "breakout" && var.spanning_tree_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsstpIfPol"
  class_name = "infraRsStpIfPol"
  content = {
    tnStpIfPolName = var.spanning_tree_policy
  }
}

resource "aci_rest_managed" "infraRsMcpIfPol" {
  count      = var.type != "breakout" && var.mcp_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsmcpIfPol"
  class_name = "infraRsMcpIfPol"
  content = {
    tnMcpIfPolName = var.mcp_policy
  }
}

resource "aci_rest_managed" "infraRsL2IfPol" {
  count      = var.type != "breakout" && var.l2_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsl2IfPol"
  class_name = "infraRsL2IfPol"
  content = {
    tnL2IfPolName = var.l2_policy
  }
}

resource "aci_rest_managed" "infraRsStormctrlIfPol" {
  count      = var.type != "breakout" && var.storm_control_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsstormctrlIfPol"
  class_name = "infraRsStormctrlIfPol"
  content = {
    tnStormctrlIfPolName = var.storm_control_policy
  }
}

resource "aci_rest_managed" "infraRsL2PortSecurityPol" {
  count      = var.type != "breakout" && var.port_security_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsl2PortSecurityPol"
  class_name = "infraRsL2PortSecurityPol"
  content = {
    tnL2PortSecurityPolName = var.port_security_policy
  }
}

resource "aci_rest_managed" "infraRsQosPfcIfPol" {
  count      = var.type != "breakout" && var.priority_flow_control_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsqosPfcIfPol"
  class_name = "infraRsQosPfcIfPol"
  content = {
    tnQosPfcIfPolName = var.priority_flow_control_policy
  }
}

resource "aci_rest_managed" "infraRsLacpPol" {
  count      = (var.type == "vpc" || var.type == "pc") && var.port_channel_policy != "" ? 1 : 0
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

resource "aci_rest_managed" "infraRsNetflowMonitorPol" {
  for_each   = { for monitor in var.netflow_monitor_policies : monitor.name => monitor if var.type != "breakout" }
  dn         = "${aci_rest_managed.infraAccGrp.dn}/rsnetflowMonitorPol-[${each.value.name}]-${each.value.ip_filter_type}"
  class_name = "infraRsNetflowMonitorPol"
  content = {
    fltType                 = each.value.ip_filter_type
    tnNetflowMonitorPolName = each.value.name
  }
}
