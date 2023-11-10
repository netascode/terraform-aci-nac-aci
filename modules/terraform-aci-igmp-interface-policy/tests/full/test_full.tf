terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  name                              = "TEST_FULL"
  tenant                            = aci_rest_managed.fvTenant.content.name
  description                       = "My IGMP Interface Policy"
  grp_timeout                       = 10
  allow_v3_asm                      = true
  fast_leave                        = true
  report_link_local_groups          = true
  last_member_count                 = 5
  last_member_response_time         = 5
  querier_timeout                   = 10
  query_interval                    = 10
  robustness_variable               = 3
  query_response_interval           = 7
  startup_query_count               = 7
  startup_query_interval            = 7
  version_                          = "v3"
  report_policy_multicast_route_map = "RM1"
  static_report_multicast_route_map = "RM2"
  max_mcast_entries                 = 1000
  reserved_mcast_entries            = 100
  state_limit_multicast_route_map   = "RM3"
}

data "aci_rest_managed" "igmpIfPol" {
  dn = "${aci_rest_managed.fvTenant.id}/igmpIfPol-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "igmpIfPol" {
  component = "igmpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.igmpIfPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.igmpIfPol.content.descr
    want        = "My IGMP Interface Policy"
  }

  equal "grpTimeout" {
    description = "grpTimeout"
    got         = data.aci_rest_managed.igmpIfPol.content.grpTimeout
    want        = "10"
  }

  equal "ifCtrl" {
    description = "ifCtrl"
    got         = data.aci_rest_managed.igmpIfPol.content.ifCtrl
    want        = "allow-v3-asm,fast-leave,rep-ll"
  }

  equal "lastMbrCnt" {
    description = "lastMbrCnt"
    got         = data.aci_rest_managed.igmpIfPol.content.lastMbrCnt
    want        = "5"
  }

  equal "lastMbrRespTime" {
    description = "lastMbrRespTime"
    got         = data.aci_rest_managed.igmpIfPol.content.lastMbrRespTime
    want        = "5"
  }

  equal "querierTimeout" {
    description = "querierTimeout"
    got         = data.aci_rest_managed.igmpIfPol.content.querierTimeout
    want        = "10"
  }

  equal "queryIntvl" {
    description = "queryIntvl"
    got         = data.aci_rest_managed.igmpIfPol.content.queryIntvl
    want        = "10"
  }

  equal "robustFac" {
    description = "robustFac"
    got         = data.aci_rest_managed.igmpIfPol.content.robustFac
    want        = "3"
  }

  equal "rspIntvl" {
    description = "rspIntvl"
    got         = data.aci_rest_managed.igmpIfPol.content.rspIntvl
    want        = "7"
  }

  equal "startQueryCnt" {
    description = "startQueryCnt"
    got         = data.aci_rest_managed.igmpIfPol.content.startQueryCnt
    want        = "7"
  }

  equal "startQueryIntvl" {
    description = "startQueryIntvl"
    got         = data.aci_rest_managed.igmpIfPol.content.startQueryIntvl
    want        = "7"
  }

  equal "ver" {
    description = "ver"
    got         = data.aci_rest_managed.igmpIfPol.content.ver
    want        = "v3"
  }
}

data "aci_rest_managed" "igmpStRepPol" {
  dn = "${data.aci_rest_managed.igmpIfPol.id}/igmpstrepPol-static-group"

  depends_on = [module.main]
}

resource "test_assertions" "igmpStRepPol" {
  component = "igmpStRepPol"

  equal "joinType" {
    description = "joinType"
    got         = data.aci_rest_managed.igmpStRepPol.content.joinType
    want        = "static-group"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_report_policy" {
  dn = "${data.aci_rest_managed.igmpStRepPol.id}/rsfilterToRtMapPol"

  depends_on = [module.main]
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_report_policy" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_report_policy.content.tDn
    want        = "${aci_rest_managed.fvTenant.id}/rtmap-RM1"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_static_report" {
  dn = "${data.aci_rest_managed.igmpIfPol.id}/igmprepPol/rsfilterToRtMapPol"

  depends_on = [module.main]
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_static_report" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_static_report.content.tDn
    want        = "${aci_rest_managed.fvTenant.id}/rtmap-RM2"
  }
}

data "aci_rest_managed" "igmpStateLPol" {
  dn = "${data.aci_rest_managed.igmpIfPol.id}/igmpstateLPol"

  depends_on = [module.main]
}

resource "test_assertions" "igmpStateLPol" {
  component = "igmpStateLPol"

  equal "max" {
    description = "max"
    got         = data.aci_rest_managed.igmpStateLPol.content.max
    want        = "1000"
  }

  equal "rsvd" {
    description = "rsvd"
    got         = data.aci_rest_managed.igmpStateLPol.content.rsvd
    want        = "100"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_state_limit" {
  dn = "${data.aci_rest_managed.igmpStateLPol.id}/rsfilterToRtMapPol"

  depends_on = [module.main]
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_state_limit" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_state_limit.content.tDn
    want        = "${aci_rest_managed.fvTenant.id}/rtmap-RM3"
  }
}
