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

data "aci_rest_managed" "igmpSnoopPol" {
  dn = "${aci_rest_managed.fvTenant.id}/snPol-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "igmpSnoopPol" {
  component = "igmpSnoopPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.igmpSnoopPol.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.igmpSnoopPol.content.descr
    want        = ""
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.igmpSnoopPol.content.adminSt
    want        = "enabled"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.ctrl
    want        = ""
  }

  equal "lastMbrIntvl" {
    description = "lastMbrIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.lastMbrIntvl
    want        = "1"
  }

  equal "queryIntvl" {
    description = "queryIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.queryIntvl
    want        = "125"
  }

  equal "rspIntvl" {
    description = "rspIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.rspIntvl
    want        = "10"
  }

  equal "startQueryCnt" {
    description = "startQueryCnt"
    got         = data.aci_rest_managed.igmpSnoopPol.content.startQueryCnt
    want        = "2"
  }

  equal "startQueryIntvl" {
    description = "startQueryIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.startQueryIntvl
    want        = "31"
  }
}
