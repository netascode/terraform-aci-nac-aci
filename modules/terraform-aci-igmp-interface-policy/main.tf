resource "aci_rest_managed" "igmpIfPol" {
  dn         = "uni/tn-${var.tenant}/igmpIfPol-${var.name}"
  class_name = "igmpIfPol"
  content = {
    name            = var.name
    descr           = var.description
    grpTimeout      = var.grp_timeout
    ifCtrl          = join(",", concat(var.allow_v3_asm == true ? ["allow-v3-asm"] : [], var.fast_leave == true ? ["fast-leave"] : [], var.report_link_local_groups == true ? ["rep-ll"] : []))
    lastMbrCnt      = var.last_member_count
    lastMbrRespTime = var.last_member_response_time
    querierTimeout  = var.querier_timeout
    queryIntvl      = var.query_interval
    robustFac       = var.robustness_variable
    rspIntvl        = var.query_response_interval
    startQueryCnt   = var.startup_query_count
    startQueryIntvl = var.startup_query_interval
    ver             = var.version_
  }
}

resource "aci_rest_managed" "igmpStRepPol" {
  count      = var.report_policy_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.igmpIfPol.dn}/igmpstrepPol-static-group"
  class_name = "igmpStRepPol"
  content = {
    joinType = "static-group"
  }
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_report_policy" {
  count      = var.report_policy_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.igmpStRepPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.report_policy_multicast_route_map}"
  }
}

resource "aci_rest_managed" "igmpRepPol" {
  count      = var.static_report_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.igmpIfPol.dn}/igmprepPol"
  class_name = "igmpRepPol"
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_static_report" {
  count      = var.static_report_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.igmpRepPol[0].dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.static_report_multicast_route_map}"
  }
}

resource "aci_rest_managed" "igmpStateLPol" {
  dn         = "${aci_rest_managed.igmpIfPol.dn}/igmpstateLPol"
  class_name = "igmpStateLPol"
  content = {
    max  = var.max_mcast_entries
    rsvd = var.reserved_mcast_entries
  }
}

resource "aci_rest_managed" "rtdmcRsFilterToRtMapPol_state_limit" {
  count      = var.state_limit_multicast_route_map != "" ? 1 : 0
  dn         = "${aci_rest_managed.igmpStateLPol.dn}/rsfilterToRtMapPol"
  class_name = "rtdmcRsFilterToRtMapPol"
  content = {
    tDn = "uni/tn-${var.tenant}/rtmap-${var.state_limit_multicast_route_map}"
  }
}
