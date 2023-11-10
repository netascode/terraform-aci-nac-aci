terraform {
  required_version = ">= 1.3.0"

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
  source                      = "../.."
  tenant                      = aci_rest_managed.fvTenant.content.name
  name                        = "SR1"
  description                 = "My Description"
  community                   = "no-export"
  community_mode              = "replace"
  dampening                   = true
  dampening_half_life         = 15
  dampening_max_suppress_time = 60
  dampening_reuse_limit       = 750
  dampening_suppress_limit    = 2000
  weight                      = 100
  next_hop                    = "1.1.1.1"
  metric                      = 1
  preference                  = 1
  metric_type                 = "ospf-type1"
  additional_communities = [
    {
      community   = "regular:as2-nn2:4:15"
      description = "My Community"
    }
  ]
  set_as_path          = true
  set_as_path_criteria = "prepend"
  set_as_path_count    = 0
  set_as_path_asn      = 65001
  set_as_path_order    = 5

  next_hop_propagation = true
  multipath            = true
}

data "aci_rest_managed" "rtctrlAttrP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlAttrP" {
  component = "rtctrlAttrP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlAttrP.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlAttrP.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "rtctrlSetComm" {
  dn = "${data.aci_rest_managed.rtctrlAttrP.id}/scomm"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetComm" {
  component = "rtctrlSetComm"

  equal "community" {
    description = "community"
    got         = data.aci_rest_managed.rtctrlSetComm.content.community
    want        = "no-export"
  }

  equal "setCriteria" {
    description = "setCriteria"
    got         = data.aci_rest_managed.rtctrlSetComm.content.setCriteria
    want        = "replace"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetComm.content.type
    want        = "community"
  }
}

data "aci_rest_managed" "rtctrlSetDamp" {
  dn = "${data.aci_rest_managed.rtctrlAttrP.id}/sdamp"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetDamp" {
  component = "rtctrlSetDamp"

  equal "halfLife" {
    description = "halfLife"
    got         = data.aci_rest_managed.rtctrlSetDamp.content.halfLife
    want        = "15"
  }

  equal "maxSuppressTime" {
    description = "maxSuppressTime"
    got         = data.aci_rest_managed.rtctrlSetDamp.content.maxSuppressTime
    want        = "60"
  }

  equal "reuse" {
    description = "reuse"
    got         = data.aci_rest_managed.rtctrlSetDamp.content.reuse
    want        = "750"
  }

  equal "suppress" {
    description = "suppress"
    got         = data.aci_rest_managed.rtctrlSetDamp.content.suppress
    want        = "2000"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetDamp.content.type
    want        = "dampening-pol"
  }
}


data "aci_rest_managed" "rtctrlSetWeight" {
  dn = "${data.aci_rest_managed.rtctrlAttrP.id}/sweight"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetWeight" {
  component = "rtctrlSetWeight"

  equal "weight" {
    description = "weight"
    got         = data.aci_rest_managed.rtctrlSetWeight.content.weight
    want        = "100"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetWeight.content.type
    want        = "rt-weight"
  }
}

data "aci_rest_managed" "rtctrlSetNh" {
  dn = "${data.aci_rest_managed.rtctrlAttrP.id}/nh"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetNh" {
  component = "rtctrlSetNh"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.rtctrlSetNh.content.addr
    want        = "1.1.1.1"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetNh.content.type
    want        = "ip-nh"
  }
}

data "aci_rest_managed" "rtctrlSetPref" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/spref"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetPref" {
  component = "rtctrlSetPref"

  equal "preference" {
    description = "addr"
    got         = data.aci_rest_managed.rtctrlSetPref.content.localPref
    want        = "1"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetPref.content.type
    want        = "local-pref"
  }
}


data "aci_rest_managed" "rtctrlSetRtMetric" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/smetric"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetRtMetric" {
  component = "rtctrlSetRtMetric"

  equal "metric" {
    description = "metric"
    got         = data.aci_rest_managed.rtctrlSetRtMetric.content.metric
    want        = "1"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetRtMetric.content.type
    want        = "metric"
  }
}


data "aci_rest_managed" "rtctrlSetRtMetricType" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/smetrict"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetRtMetricType" {
  component = "rtctrlSetRtMetricType"

  equal "metricType" {
    description = "metricType"
    got         = data.aci_rest_managed.rtctrlSetRtMetricType.content.metricType
    want        = "ospf-type1"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetRtMetricType.content.type
    want        = "metric"
  }
}


data "aci_rest_managed" "rtctrlSetAddComm" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/saddcomm-regular:as2-nn2:4:15"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetAddComm" {
  component = "rtctrlSetAddComm"

  equal "community" {
    description = "community"
    got         = data.aci_rest_managed.rtctrlSetAddComm.content.community
    want        = "regular:as2-nn2:4:15"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlSetAddComm.content.descr
    want        = "My Community"
  }

  equal "setCriteria" {
    description = "setCriteria"
    got         = data.aci_rest_managed.rtctrlSetAddComm.content.setCriteria
    want        = "append"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetAddComm.content.type
    want        = "community"
  }
}

data "aci_rest_managed" "rtctrlSetASPath" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/saspath-prepend"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetASPath" {
  component = "rtctrlSetASPath"

  equal "criteria" {
    description = "criteria"
    got         = data.aci_rest_managed.rtctrlSetASPath.content.criteria
    want        = "prepend"
  }

  equal "lastnum" {
    description = "lastnum"
    got         = data.aci_rest_managed.rtctrlSetASPath.content.lastnum
    want        = "0"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetASPath.content.type
    want        = "as-path"
  }
}


data "aci_rest_managed" "rtctrlSetASPathASN" {
  dn         = "${data.aci_rest_managed.rtctrlSetASPath.id}/asn-5"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetASPathASN" {
  component = "rtctrlSetASPathASN"

  equal "asn" {
    description = "asn"
    got         = data.aci_rest_managed.rtctrlSetASPathASN.content.asn
    want        = "65001"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.rtctrlSetASPathASN.content.order
    want        = "5"
  }
}

data "aci_rest_managed" "rtctrlSetNhUnchanged" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/nhunchanged"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetNhUnchanged" {
  component = "rtctrlSetNhUnchanged"

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetNhUnchanged.content.type
    want        = "nh-unchanged"
  }
}

data "aci_rest_managed" "rtctrlSetRedistMultipath" {
  dn         = "${data.aci_rest_managed.rtctrlAttrP.id}/redistmpath"
  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSetRedistMultipath" {
  component = "rtctrlSetRedistMultipath"

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlSetRedistMultipath.content.type
    want        = "redist-multipath"
  }
}
