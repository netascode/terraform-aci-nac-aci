resource "aci_rest_managed" "pimIfPol" {
  dn          = "uni/tn-${var.tenant}/pimifpol-${var.name}"
  class_name  = "pimIfPol"
  escape_html = false
  content = {
    name          = var.name
    secureAuthKey = var.auth_key
    authT         = var.auth_type
    ctrl          = join(",", concat(var.mcast_dom_boundary == true ? ["border"] : [], var.passive == true ? ["passive"] : [], var.strict_rfc == true ? ["strict-rfc-compliant"] : []))
    drDelay       = var.designated_router_delay
    drPrio        = var.designated_router_priority
    helloItvl     = var.hello_interval
    jpInterval    = var.join_prune_interval
  }
  lifecycle {
    ignore_changes = [content["secureAuthKey"]]
  }
}

resource "aci_rest_managed" "pimNbrFilterPol" {
  count      = var.neighbor_filter_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimIfPol.dn}/nbrfilter"
  class_name = "pimNbrFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_neighbor_filter" {
  count      = var.neighbor_filter_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimNbrFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.neighbor_filter_policy}"
  }
}

resource "aci_rest_managed" "pimJPOutbFilterPol" {
  count      = var.join_prune_filter_policy_out != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimIfPol.dn}/jpoutbfilter"
  class_name = "pimJPOutbFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_join_prune_filter_out" {
  count      = var.join_prune_filter_policy_out != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimJPOutbFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.join_prune_filter_policy_out}"
  }
}

resource "aci_rest_managed" "pimJPInbFilterPol" {
  count      = var.neighbor_filter_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimIfPol.dn}/jpinbfilter"
  class_name = "pimJPInbFilterPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_join_prune_filter_in" {
  count      = var.join_prune_filter_policy_in != "" ? 1 : 0
  dn         = "${aci_rest_managed.pimJPInbFilterPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.join_prune_filter_policy_in}"
  }
}
