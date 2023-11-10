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

  name   = "TEST_MINIMAL"
  tenant = aci_rest_managed.fvTenant.content.name
}

data "aci_rest_managed" "igmpIfPol" {
  dn = "${aci_rest_managed.fvTenant.id}/igmpIfPol-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "igmpIfPol" {
  component = "igmpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.igmpIfPol.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.igmpIfPol.content.descr
    want        = ""
  }

  equal "grpTimeout" {
    description = "grpTimeout"
    got         = data.aci_rest_managed.igmpIfPol.content.grpTimeout
    want        = "260"
  }

  equal "ifCtrl" {
    description = "ifCtrl"
    got         = data.aci_rest_managed.igmpIfPol.content.ifCtrl
    want        = ""
  }

  equal "lastMbrCnt" {
    description = "lastMbrCnt"
    got         = data.aci_rest_managed.igmpIfPol.content.lastMbrCnt
    want        = "2"
  }

  equal "lastMbrRespTime" {
    description = "lastMbrRespTime"
    got         = data.aci_rest_managed.igmpIfPol.content.lastMbrRespTime
    want        = "1"
  }

  equal "querierTimeout" {
    description = "querierTimeout"
    got         = data.aci_rest_managed.igmpIfPol.content.querierTimeout
    want        = "255"
  }

  equal "queryIntvl" {
    description = "queryIntvl"
    got         = data.aci_rest_managed.igmpIfPol.content.queryIntvl
    want        = "125"
  }

  equal "robustFac" {
    description = "robustFac"
    got         = data.aci_rest_managed.igmpIfPol.content.robustFac
    want        = "2"
  }

  equal "rspIntvl" {
    description = "rspIntvl"
    got         = data.aci_rest_managed.igmpIfPol.content.rspIntvl
    want        = "25"
  }

  equal "startQueryCnt" {
    description = "startQueryCnt"
    got         = data.aci_rest_managed.igmpIfPol.content.startQueryCnt
    want        = "2"
  }

  equal "startQueryIntvl" {
    description = "startQueryIntvl"
    got         = data.aci_rest_managed.igmpIfPol.content.startQueryIntvl
    want        = "31"
  }

  equal "ver" {
    description = "ver"
    got         = data.aci_rest_managed.igmpIfPol.content.ver
    want        = "v2"
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
    want        = "unlimited"
  }

  equal "rsvd" {
    description = "rsvd"
    got         = data.aci_rest_managed.igmpStateLPol.content.rsvd
    want        = "undefined"
  }
}
